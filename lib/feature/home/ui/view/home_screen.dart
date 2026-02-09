import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart' show HijriCalendar;
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/reading_progress_cubit.dart';
import 'package:islami_app/feature/home/data/model/home_model.dart';
import 'package:islami_app/feature/home/ui/view/widget/custom_drawer.dart';
import 'package:islami_app/feature/home/ui/view/widget/home_item_card.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';
import 'package:islami_app/feature/khatmah/utils/khatmah_constants.dart';
import 'package:quran/quran.dart' as quran;


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SurahCubit>(context, listen: false).getSurahs();

    // Initialize the shared prayer times provider
    SharedPrayerTimesProvider.instance.initialize();

    if (!Hive.isBoxOpen(KhatmahConstants.hadithBoxName)) {
      Hive.openBox<List>(KhatmahConstants.hadithBoxName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = context.watch<ThemeCubit>().state is ThemeChanged;

    // final isDark =
    //     context.watch<ThemeCubit>().state is ThemeChanged &&
    //     (context.watch<ThemeCubit>().state as ThemeChanged).isDark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "اقْرَأْ وَارْتَقِ وَرَتِّلْ",
          style: context.textTheme.titleLarge!.copyWith(
            color: AppColors.white,
            fontFamily: 'uthmanic',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      drawer: const CustomDrawer(),

      // Body with slivers
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.asset('assets/images/banner.png'),
                    const Positioned(bottom: 0, child: PrayerAndDateWidget()),
                    Positioned(
                      child: BlocBuilder<
                        ReadingProgressCubit,
                        ReadingProgressState
                      >(
                        builder: (context, state) {
                          if (state is ReadingProgressInitial) {
                            return const SizedBox.shrink();
                          }

                          if (state is ReadingProgressError) {
                            return const SizedBox.shrink();
                          }

                          if (state is ReadingProgressLoaded) {
                            final surah = state.surah;
                            final ayah = state.ayah;
                            final pageNumber = state.page;

                            return CustomReadingQuran(
                              pageNumber: pageNumber,
                              surah: surah,
                              ayah: ayah,
                            );
                          }

                          // Default case - return empty widget
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Prayer Times & Date Widget (Combined)
          const SliverToBoxAdapter(child: DateWidget()),

          // Grid of items
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return HomeItemCard(item: items[index]);
              }, childCount: items.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class CustomReadingQuran extends StatelessWidget {
  const CustomReadingQuran({
    super.key,
    required this.pageNumber,
    required this.surah,
    required this.ayah,
  });

  final int pageNumber;
  final int surah;
  final int ayah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quran.getSurahNameArabic(surah),
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontFamily: 'uthmanic',
                      ),
                    ),
                    // SizedBox(height: 4.h),
                    Text(
                      "آية $ayah - صفحة $pageNumber",
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontFamily: 'uthmanic',
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.quranViewRouter,
                          arguments: {"pageNumber": pageNumber},
                        );
                      },
                      child: Text(
                        'متابعة القرءة',

                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'uthmanic',
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PrayerAndDateWidget extends StatefulWidget {
  const PrayerAndDateWidget({super.key});

  @override
  State<PrayerAndDateWidget> createState() => _PrayerAndDateWidgetState();
}

class _PrayerAndDateWidgetState extends State<PrayerAndDateWidget> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SharedPrayerTimesProvider.instance,
      builder: (context, child) {
        final provider = SharedPrayerTimesProvider.instance;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              // Prayer Times Section
              if (provider.nextPrayer != null && provider.namedTimes.isNotEmpty)
                Row(
                  children: [
                    Text(
                      'الصلاة القادمة : ',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontFamily: 'uthmanic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'صلاة ${provider.getPrayerName(provider.nextPrayer!)}',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'uthmanic',
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.prayertimesRouter,
                        );
                      },
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        color: AppColors.white,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class DateWidget extends StatefulWidget {
  const DateWidget({super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  bool _showHijri = true;

  String _getHijriDate() {
    HijriCalendar.setLocal('ar');
    var hijriDate = HijriCalendar.now();
    return '${hijriDate.hDay} ${hijriDate.getLongMonthName()} ${hijriDate.hYear} هـ';
  }

  String _getGregorianDate() {
    final now = DateTime.now();
    final formatter = DateFormat('d MMMM yyyy', 'ar');
    return '${formatter.format(now)} م';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        color: Theme.of(context).cardColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showHijri = !_showHijri;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _showHijri ? 'التاريخ الهجري' : 'التاريخ الميلادي',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Uthmanic',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _showHijri ? _getHijriDate() : _getGregorianDate(),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Uthmanic',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    color: AppColors.black,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
