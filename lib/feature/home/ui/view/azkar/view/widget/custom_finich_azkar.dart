import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/notification/widget/local_notification_service.dart';

class CustomFinichAzkar extends StatelessWidget {
  const CustomFinichAzkar({super.key});

  @override
  Widget build(BuildContext context) {
    void scheduleExampleNotification() {
      final now = DateTime.now();
      final scheduleTime = now.add(const Duration(seconds: 10)); // بعد 10 ثواني

      LocalNotificationService.scheduleNotification(
        id: 1,
        title: 'احسنت',
        body: 'جزاك الله خيرا',
        dateTime: scheduleTime,
        repeat: null, // لو عايز تكرار يومي استخدم: DateTimeComponents.time
        payload: 'notification_1',
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset(AppImage.congratulationsImage),
            const SizedBox(height: 50),
            Text(
              "زادك الله نورًا وطمأنينة. أحسنت!",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 22),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
                  scheduleExampleNotification();
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).hintColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: Text(
                  'القائمة الرئيسية',
                  style: context.textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
