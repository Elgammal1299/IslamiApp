import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/reading_progress_cubit.dart';
import 'package:islami_app/feature/home/data/model/hadith_model.dart';
import 'package:islami_app/feature/home/data/model/home_model.dart';
import 'package:islami_app/feature/home/ui/view/widget/custom_drawer.dart';
import 'package:islami_app/feature/home/ui/view/widget/home_item_card.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';
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
    if (!Hive.isAdapterRegistered(HadithModelAdapter().typeId)) {
      Hive.registerAdapter(HadithModelAdapter());
    }

    if (!Hive.isBoxOpen('hadiths')) {
      Hive.openBox<List>('hadiths');
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
                    const Positioned(
                       bottom: 0,
                      child: PrayerAndDateWidget()),
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
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 8.0,
          //       vertical: 4.0,
          //     ),
          //     child: const PrayerAndDateWidget(),
          //   ),
          // ),

          // Grid of items
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return HomeItemCard(item: items[index]);
              }, childCount: items.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
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
// class PrayerAndDateWidget extends StatefulWidget {
//   const PrayerAndDateWidget({super.key});

//   @override
//   State<PrayerAndDateWidget> createState() => _PrayerAndDateWidgetState();
// }

// class _PrayerAndDateWidgetState extends State<PrayerAndDateWidget> {
//   bool _showHijri = true;

//   String _getHijriDate() {
//     HijriCalendar.setLocal('ar');
//     var hijriDate = HijriCalendar.now();
//     return '${hijriDate.hDay} ${hijriDate.getLongMonthName()} ${hijriDate.hYear} هـ';
//   }

//   String _getGregorianDate() {
//     final now = DateTime.now();
//     final formatter = DateFormat('d MMMM yyyy', 'ar');
//     return '${formatter.format(now)} م';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return ListenableBuilder(
//       listenable: SharedPrayerTimesProvider.instance,
//       builder: (context, child) {
//         final provider = SharedPrayerTimesProvider.instance;

//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: LinearGradient(
//               colors:
//                   isDark
//                       ? [
//                         AppColors.darkPrimary,
//                         AppColors.darkPrimary.withOpacity(0.7),
//                       ]
//                       : [AppColors.primary, const Color(0xFF1E5A6B)],
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.primary.withOpacity(0.4),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Prayer Times Section
//               if (provider.nextPrayer != null && provider.namedTimes.isNotEmpty)
//                 Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'الصلاة القادمة',
//                               style: TextStyle(
//                                 color: AppColors.white.withOpacity(0.85),
//                                 fontSize: 13.sp,
//                                 fontFamily: 'Cairo',
//                               ),
//                             ),
//                             SizedBox(height: 4.h),
//                             Text(
//                               'صلاة ${provider.getPrayerName(provider.nextPrayer!)}',
//                               style: TextStyle(
//                                 color: AppColors.white,
//                                 fontSize: 22.sp,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'uthmanic',
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16.w,
//                             vertical: 8.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             provider.formatCountdown(),
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.white,
//                               fontSize: 18.sp,
//                               fontFamily: 'Cairo',
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pushNamed(
//                               context,
//                               AppRoutes.prayertimesRouter,
//                             );
//                           },
//                           icon: Icon(
//                             Icons.arrow_circle_left_outlined,
//                             color: AppColors.white,
//                             size: 30.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12.h),
//                     Divider(
//                       color: AppColors.white.withOpacity(0.2),
//                       thickness: 1,
//                     ),
//                     SizedBox(height: 12.h),
//                   ],
//                 ),

//               // Date Section (Toggleable)
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _showHijri = !_showHijri;
//                   });
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _showHijri ? 'التاريخ الهجري' : 'التاريخ الميلادي',
//                           style: TextStyle(
//                             color: AppColors.white.withOpacity(0.85),
//                             fontSize: 13.sp,
//                             fontFamily: 'Cairo',
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           _showHijri ? _getHijriDate() : _getGregorianDate(),
//                           style: TextStyle(
//                             color: AppColors.white,
//                             fontSize: 17.sp,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Cairo',
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(8.w),
//                       decoration: BoxDecoration(
//                         color: AppColors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.swap_horiz_rounded,
//                         color: AppColors.white,
//                         size: 20.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
