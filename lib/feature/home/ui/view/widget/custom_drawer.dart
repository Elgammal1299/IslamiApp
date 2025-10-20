import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
                  const SizedBox(height: 4),
                  Text(
                    'نسخة $version',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
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
                  title: const Text('الوضع الليلي'),
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
              icon: Icons.people,
              title: 'من نحن',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.aboutUsRouter);
              },
            ),

            const Spacer(),

            // 🔹 Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  ' جميع الحقوق محفوظة © $year',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
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
      title: Text(title, style: context.textTheme.bodyLarge),
      onTap: onTap,
    );
  }
}
