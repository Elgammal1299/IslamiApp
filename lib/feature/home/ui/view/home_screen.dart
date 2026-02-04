import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        // leading: BlocBuilder<ThemeCubit, ThemeState>(
        //   builder: (context, state) {
        //     final isDark = state is ThemeChanged ? state.isDark : false;

        //     return IconButton(
        //       icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        //       onPressed: () => context.read<ThemeCubit>().changeTheme(),
        //     );
        //   },
        // ),
        // leading: IconButton(
        //   icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        //   onPressed: () => context.read<ThemeCubit>().changeTheme(),
        // ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, AppRoutes.notificationScreenRouter);
        //     },
        //     icon: const Icon(Icons.notifications),
        //   ),
        // ],
      ),
      drawer: const CustomDrawer(),

      // Body with slivers
      body: CustomScrollView(
        slivers: [
          // Azkar Random
          // const SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 16.0, right: 16, left: 16),
          //     child: AzkarRandom(),
          //   ),
          // ),

          // ✅ Next Prayer Widget
          // const SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //     child: NextPrayerWidget(),
          //   ),
          // ),

          // ✅ Bookmark Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
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
          ),

          // Grid of items
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return HomeItemCard(item: items[index]);
              }, childCount: items.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).secondaryHeaderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: theme.cardColor,
      ),
      child: Padding(
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
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        "آية $ayah - صفحة $pageNumber",
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.quranViewRouter,
                      arguments: {"pageNumber": pageNumber},
                    );
                  },
                  child: Text(
                    'متابعة القرءة',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const Divider(),
            const NextPrayerWidget(),
          ],
        ),
      ),
    );
  }
}

class NextPrayerWidget extends StatelessWidget {
  const NextPrayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: SharedPrayerTimesProvider.instance,
      builder: (context, child) {
        final provider = SharedPrayerTimesProvider.instance;

        if (provider.nextPrayer == null || provider.namedTimes.isEmpty) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.prayertimesRouter);
          },
          child: Row(
            children: [
              Text(
                'متبقي على صلاة${provider.getPrayerName(provider.nextPrayer!)}',
                style: theme.textTheme.titleLarge,
              ),
              const Spacer(),
              Text(
                provider.formatCountdown(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
