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
  final ValueNotifier<bool> preReminderEnabled = ValueNotifier(true);

  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    todayTimes.dispose();
    namedTimes.dispose();
    currentPrayer.dispose();
    nextPrayer.dispose();
    countdown.dispose();
    preReminderEnabled.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      await _notificationService.init();
      final PrayerTimes times = await _prayerService.getTodayPrayerTimes();
      _updateStateWithTimes(times);
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

  void _updateStateWithTimes(PrayerTimes times) {
    todayTimes.value = times;
    namedTimes.value = _prayerService.getNamedTimes(times);
    currentPrayer.value = _prayerService.currentPrayer(times);
    nextPrayer.value = _prayerService.nextPrayer(times);
    _updateCountdown();
  }

  Future<void> _scheduleTodayAndTomorrow() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime tomorrow = today.add(const Duration(days: 1));

    // Today: schedule only future times
    await _notificationService.scheduleForDay(
      prayerTimes: namedTimes.value,
      day: today,
      preReminderEnabled: preReminderEnabled.value,
      prayerName: _displayName,
    );

    // Tomorrow: compute times using same coordinates
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
        preReminderEnabled: preReminderEnabled.value,
        prayerName: _displayName,
      );
    } catch (_) {
      // Ignore tomorrow scheduling failure silently
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (todayTimes.value == null) return;
      final Prayer newCurrent = _prayerService.currentPrayer(todayTimes.value!);
      final Prayer newNext = _prayerService.nextPrayer(todayTimes.value!);
      if (newCurrent != currentPrayer.value) {
        currentPrayer.value = newCurrent;
      }
      if (newNext != nextPrayer.value) {
        nextPrayer.value = newNext;
      }
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (todayTimes.value == null || nextPrayer.value == null) {
      countdown.value = Duration.zero;
      return;
    }
    final DateTime? nextTime = _prayerService.timeForPrayer(
      todayTimes.value!,
      nextPrayer.value!,
    );
    if (nextTime == null) {
      countdown.value = Duration.zero;
      return;
    }
    final now = DateTime.now();
    countdown.value =
        nextTime.isAfter(now) ? nextTime.difference(now) : Duration.zero;
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
        return '—';
    }
  }

  String _format(DateTime dt) => DateFormat.jm().format(dt);

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
                _buildReminderSwitch(),
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

  Widget _buildReminderSwitch() {
    return ValueListenableBuilder<bool>(
      valueListenable: preReminderEnabled,
      builder: (context, enabled, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('التذكير قبل الصلاة ب 10 دقائق'),
            Switch(
              value: enabled,
              onChanged: (v) async {
                preReminderEnabled.value = v;
                if (todayTimes.value != null) {
                  // Simply reschedule today/tomorrow to reflect toggle change
                  await _notificationService.cancelAll();
                  await _scheduleTodayAndTomorrow();
                }
              },
            ),
          ],
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
