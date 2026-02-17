import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:islami_app/core/router/app_routes.dart';

/// Centralized navigation for all notifications.
/// - source == 'local'  -> go to AzkarYawmiScreen
/// - fallback (default) -> open NotificationView with passed data
void handleNotification(BuildContext context, Map<String, dynamic> payload) {
  try {
    final String source = (payload['source'] ?? 'local').toString();
    final String title = (payload['title'] ?? '').toString();
    final String body = (payload['body'] ?? '').toString();

    if (source == 'local' || source == 'scheduled') {
      log('🔔 Notification tapped -> navigating to AzkarYawmiScreen');
      Navigator.of(context).pushNamed(AppRoutes.azkarYawmiScreen);
      return;
    }

    if (source == 'khatmah') {
      final String khatmahId = (payload['khatmahId'] ?? '').toString();
      log(
        '🔔 Khatmah Notification tapped -> navigating to Khatmah: $khatmahId',
      );

      Navigator.of(context).pushNamed(
        AppRoutes.khatmahDetailsRouter,
        arguments: {'khatmahId': khatmahId},
      );

      return;
    }

    // fallback for any other source
    log('📨 Notification -> NotificationView');
    Navigator.pushNamed(
      context,
      AppRoutes.notificationViewRouter,
      arguments: {'title': title, 'body': body},
    );
  } catch (e) {
    log('❌ Error in handleNotification: $e');
  }
}
