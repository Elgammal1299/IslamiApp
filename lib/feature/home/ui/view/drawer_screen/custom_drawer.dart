import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final String year = DateTime.now().year.toString();
  String version = '';
  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(AppImage.splashImageDark),
                  ),
                  Text(
                    'تطبيق وَارْتَقِ',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 🔹 Theme Switcher
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                final isDark = state is ThemeChanged ? state.isDark : false;

                return SwitchListTile(
                  title:  Text('الوضع الليلي',style: context.textTheme.bodyLarge?.copyWith(fontSize: 20.sp, fontFamily: 'Amiri',)),
                  secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                  value: isDark,
                  onChanged: (_) => context.read<ThemeCubit>().changeTheme(),
                );
              },
            ),

            const Divider(),

            // 🔹 Drawer Items
            _DrawerItem(
              icon: Icons.notifications,
              title: 'الإشعارات',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.notificationScreenRouter,
                );
              },
            ),
            _DrawerItem(
              icon: Icons.download,
              title: 'التنزيلات',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.downloadsRouter);
              },
            ),
            _DrawerItem(
              icon: Icons.info,
              title: 'عن التطبيق',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.aboutAppRouter);
              },
            ),
            _DrawerItem(
              icon: Icons.person,
              title: 'عن المطور',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.aboutUsRouter);
              },
            ),
            _DrawerItem(
              icon: Icons.share,
              title: 'مشاركة التطبيق',
              onTap: () {
                Navigator.pop(context);
                 Share.share(
                  'اكتشف تطبيق وَارْتَقِ - رفيقك اليومي للقرآن والأذكار! 🌙📖\n\n'
                  '🔹 استمع إلى القرآن الكريم بجودة عالية\n'
                  '🔹 تصفح الأذكار والأدعية اليومية\n'
                  '🔹 احصل على مواقيت الصلاة واتجاه القبلة\n'
                  '🔹 واجهة سهلة الاستخدام وتصميم جذاب\n\n'
                  'حمّل التطبيق الآن وارتقِ بتجربتك الروحية! 🙏✨\n\n'
                  'رابط التحميل: https://example.com/download',
    );
              },
            ),

            const Spacer(),
const SizedBox(height: 4),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'نسخة $version',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20.sp,
                          fontFamily: 'Amiri',),
                      ),
                    ),
                  ),
            // 🔹 Footer
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 12),
            //   child: Center(
            //     child: Text(
            //       ' جميع الحقوق محفوظة © $year',
            //       style: Theme.of(context).textTheme.bodySmall,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: context.textTheme.bodyLarge?.copyWith(fontSize: 20.sp, fontFamily: 'Amiri',)),
      onTap: onTap,
    );
  }
}
