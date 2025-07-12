import 'package:flutter/material.dart';
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
        title: '✅ احسنت',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_rounded,
              color: Theme.of(context).primaryColor,
              size: 150,
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/images4.png', width: 200, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
