import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeFonts();
  }

  Future<void> _initializeFonts() async {
    // تحميل الخطوط الخاصة بالمكتبة
    await QcfFontLoader.setupFontsAtStartup(
      onProgress: (double progress) {
        if (!mounted) return;
        setState(() {
          _loadingProgress = progress;
        });
      },
    );

    // تأخير بسيط لإظهار اكتمال التحميل
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Image.asset(
              AppImage.splashImageLight,
                width: 150.w,
                height: 150.h,
              ),
            const SizedBox(height: 20),
            Text(
          "اقْرَأْ وَارْتَقِ وَرَتِّلْ",
          style: context.textTheme.titleLarge!.copyWith(
            fontFamily: 'Amiri',
            fontSize: 22.sp,
          ),
        ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _loadingProgress,
                  minHeight: 8,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'جاري تجهيز المصحف... ${(_loadingProgress * 100).toStringAsFixed(1)}%',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
