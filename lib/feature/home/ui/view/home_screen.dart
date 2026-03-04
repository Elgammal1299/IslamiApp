import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/surah/surah_cubit.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/reading_progress_cubit.dart';
import 'package:islami_app/feature/home/data/model/home_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/quran_dua_cubit/quran_dua_cubit.dart';
import 'package:islami_app/feature/home/ui/view/widget/custom_drawer.dart';
import 'package:islami_app/feature/home/ui/view/widget/date_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/home_item_card.dart';
import 'package:islami_app/feature/home/services/prayer_times_service.dart';
import 'package:islami_app/feature/khatmah/utils/khatmah_constants.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:quran/quran.dart' as quran;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SurahCubit>(context, listen: false).getSurahs();
  checkForUpdate(context);
    // Initialize the shared prayer times provider
    SharedPrayerTimesProvider.instance.initialize();

    if (!Hive.isBoxOpen(KhatmahConstants.hadithBoxName)) {
      Hive.openBox<List>(KhatmahConstants.hadithBoxName);
    }
  }


Future<void> checkForUpdate(BuildContext context) async {
  final newVersion = NewVersionPlus(
    androidId: "com.islamic.wartaqi.app", 
  );

  final status = await newVersion.getVersionStatus();

  if (status != null && status.canUpdate) {
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: "تحديث جديد متاح 🚀",
      dialogText: "يوجد إصدار جديد من التطبيق، يُفضل التحديث للحصول على أحدث المميزات.",
      updateButtonText: "حدث الآن",
      dismissButtonText: "لاحقًا",
    );
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
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          "اقْرَأْ وَارْتَقِ وَرَتِّلْ",
          style: context.textTheme.titleLarge!.copyWith(
            fontFamily: 'Amiri',
            fontSize: 22.sp,
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
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
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
          
          // const SliverToBoxAdapter(child: SizedBox(height: 100)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: AnimatedAyahSwitcher(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class AnimatedAyahSwitcher extends StatelessWidget {
  const AnimatedAyahSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranDuaCubit, QuranDuaState>(
      builder: (context, state) {
        if (state is! QuranDuaLoaded) {
          return const SizedBox.shrink();
        }

        final dua = state.duas[state.currentIndex];

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, .25),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text(
                  'آية اليوم',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    height: 1.4,
                    color: AppColors.primary2,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                key: ValueKey(state.currentIndex),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dua.content,
                      textAlign: TextAlign.justify,
                      style:  TextStyle(
                        fontFamily: 'uthmanic',
                        fontWeight: FontWeight.bold,

                        fontSize: 25,
                        height: 1.4,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            dua.reference,
                            style:  TextStyle(
                              fontFamily: 'uthmanic',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 1.4,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'نسخ الآية',
                          icon: const Icon(
                            Icons.copy_rounded,
                            size: 24,
                            color: AppColors.primary2,
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: dua.content));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نسخ الآية'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh_rounded,
                            size: 22,
                            color: AppColors.primary2,
                          ),
                          tooltip: 'تغيير',
                          onPressed: () {
                            context.read<QuranDuaCubit>().nextManual();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
                        'متابعة القراءة',

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


