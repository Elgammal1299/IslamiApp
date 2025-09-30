import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islami_app/feature/home/services/notification_service.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final PrayerTimesService _prayerService = PrayerTimesService();
  final PrayerNotificationService _notificationService =
      PrayerNotificationService();

  final ValueNotifier<PrayerTimes?> todayTimes = ValueNotifier(null);
  final ValueNotifier<Map<Prayer, DateTime>> namedTimes = ValueNotifier({});
  final ValueNotifier<Prayer?> currentPrayer = ValueNotifier(null);
  final ValueNotifier<Prayer?> nextPrayer = ValueNotifier(null);
  final ValueNotifier<Duration> countdown = ValueNotifier(Duration.zero);
  // Removed preReminderEnabled since pre-reminders are disabled

  Timer? _ticker;
  DateTime? _lastUpdate;

  // Dynamic summer offset based on DST detection
  Duration get summerOffset => _prayerService.getTimeOffset();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    // Cancel timer first to prevent updates to disposed ValueNotifiers
    _ticker?.cancel();
    _ticker = null;

    // Then dispose all ValueNotifiers
    todayTimes.dispose();
    namedTimes.dispose();
    currentPrayer.dispose();
    nextPrayer.dispose();
    countdown.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      await _notificationService.init();

      // Ensure all permissions are granted for reliable notifications
      final permissionsGranted = await _notificationService.ensurePermissions();
      if (!permissionsGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('إعداد الإشعارات مطلوب لضمان عمل الأذان'),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }

      final PrayerTimes times = await _prayerService.getTodayPrayerTimes();
      _setTimes(times);
      await _scheduleTodayAndTomorrow();
      _startTicker();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _setTimes(PrayerTimes times) {
    todayTimes.value = times;
    _lastUpdate = DateTime.now();
    // Apply summer time offset consistently
    namedTimes.value = _prayerService.getNamedTimes(
      times,
      offset: summerOffset,
    );

    _refreshPrayers();
  }

  void _refreshPrayers() {
    // Check if widget is still mounted before updating ValueNotifiers
    if (!mounted || todayTimes.value == null) return;

    final PrayerTimes t = todayTimes.value!;
    currentPrayer.value = _prayerService.currentPrayer(t);
    nextPrayer.value = _prayerService.nextPrayer(t);

    final DateTime? nextTime =
        nextPrayer.value != null
            ? _prayerService.timeForPrayer(t, nextPrayer.value!)
            : null;

    if (nextTime != null && nextTime.isAfter(DateTime.now())) {
      // Apply summer offset to countdown calculation for consistency
      final adjustedTime = nextTime.add(summerOffset);
      countdown.value = adjustedTime.difference(DateTime.now());
    } else {
      countdown.value = Duration.zero;
    }
  }

  Future<void> _scheduleTodayAndTomorrow() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime tomorrow = today.add(const Duration(days: 1));

    // Schedule today
    await _notificationService.scheduleForDay(
      prayerTimes: namedTimes.value,
      day: today,
      preReminderEnabled: false, // Pre-reminders are disabled
      prayerName: _displayName,
    );

    // Schedule tomorrow
    try {
      final pos = await _prayerService.getCurrentPosition();
      final tmrTimes = _prayerService.getPrayerTimesForDate(
        latitude: pos.latitude,
        longitude: pos.longitude,
        date: tomorrow,
      );
      final tmrNamed = _prayerService.getNamedTimes(tmrTimes);
      await _notificationService.scheduleForDay(
        prayerTimes: tmrNamed,
        day: tomorrow,
        preReminderEnabled: false, // Pre-reminders are disabled
        prayerName: _displayName,
      );
    } catch (e) {
      if (kDebugMode) debugPrint("Tomorrow scheduling failed: $e");
    }
  }

  void _startTicker() {
    // Cancel any existing timer
    _ticker?.cancel();

    // Only start timer if widget is still mounted
    if (mounted) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        // Check if still mounted before calling _refreshPrayers
        if (mounted) {
          _checkAndRefreshIfNeeded();
        }
      });
    }
  }

  void _checkAndRefreshIfNeeded() {
    // Check if we need to refresh for new day
    final now = DateTime.now();

    if (_lastUpdate != null) {
      final isNewDay =
          now.day != _lastUpdate!.day ||
          now.month != _lastUpdate!.month ||
          now.year != _lastUpdate!.year;

      if (isNewDay) {
        _load(); // Reload prayer times for new day
        return;
      }
    }

    _refreshPrayers();
  }

  String _displayName(Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      case Prayer.none:
        return 'انتهت الصلوات';
    }
  }

  String _format(DateTime dt) => DateFormat('h:mm a', 'ar').format(dt);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة')),
      body: ValueListenableBuilder<PrayerTimes?>(
        valueListenable: todayTimes,
        builder: (context, times, _) {
          if (times == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(theme),
                const SizedBox(height: 16),
                ValueListenableBuilder<Map<Prayer, DateTime>>(
                  valueListenable: namedTimes,
                  builder: (context, prayers, _) {
                    return Column(
                      children:
                          prayers.entries
                              .map((e) => _buildTile(e.key, e.value))
                              .toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildDebugSection(),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return ValueListenableBuilder2<Prayer?, Prayer?>(
      first: currentPrayer,
      second: nextPrayer,
      builder: (context, current, next, _) {
        return ValueListenableBuilder<Duration>(
          valueListenable: countdown,
          builder: (context, d, _) {
            final String hh = d.inHours.toString().padLeft(2, '0');
            final String mm = (d.inMinutes % 60).toString().padLeft(2, '0');
            final String ss = (d.inSeconds % 60).toString().padLeft(2, '0');
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الصلاة الحالية: ${current != null ? _displayName(current) : '-'}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      next == null
                          ? '—'
                          : 'الصلاة التالية: ${_displayName(next)} بعد $hh:$mm:$ss',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTile(Prayer p, DateTime t) {
    return ValueListenableBuilder<Prayer?>(
      valueListenable: currentPrayer,
      builder: (context, current, _) {
        final bool isCurrent = current == p;
        return Card(
          elevation: isCurrent ? 2 : 0,
          color: isCurrent ? Colors.green.withOpacity(0.08) : null,
          child: ListTile(
            leading: Icon(_iconFor(p), color: isCurrent ? Colors.green : null),
            title: Text(_displayName(p)),
            trailing: Text(_format(t)),
          ),
        );
      },
    );
  }

  IconData _iconFor(Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return Icons.bedtime;
      case Prayer.sunrise:
        return Icons.wb_sunny_outlined;
      case Prayer.dhuhr:
        return Icons.wb_sunny;
      case Prayer.asr:
        return Icons.cloud_queue;
      case Prayer.maghrib:
        return Icons.nightlight_round;
      case Prayer.isha:
        return Icons.nights_stay;
      case Prayer.none:
        return Icons.more_horiz;
    }
  }

  Widget _buildDebugSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إعدادات الإشعارات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _notificationService.testNotification();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم إرسال إشعار تجريبي'),
                          ),
                        );
                      }
                    },
                    child: const Text('اختبار الإشعار'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final pending =
                          await _notificationService.getPendingNotifications();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'الإشعارات المجدولة: ${pending.length}',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('التحقق من الجدولة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper for listening to two ValueNotifiers at once
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, _) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}
