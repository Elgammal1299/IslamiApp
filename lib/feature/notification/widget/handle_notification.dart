import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:islami_app/core/router/app_routes.dart';

/// Centralized navigation for all notifications.
/// - source == 'local'  -> go to AzkarYawmiScreen
/// - source == 'firebase' (default) -> open NotificationView with passed data
void handleNotification(BuildContext context, Map<String, dynamic> payload) {
  try {
    final String source = (payload['source'] ?? 'firebase').toString();
    final String title = (payload['title'] ?? '').toString();
    final String body = (payload['body'] ?? '').toString();

    if (source == 'local') {
      log('🔔 Local notification tapped -> navigating to AzkarYawmiScreen');
      Navigator.of(context).pushNamed(AppRoutes.azkarYawmiScreen);
      return;
    }

    // Firebase: either route + data or default NotificationView
    final Object? routeObj = payload['route'];
    final String? route = routeObj is String ? routeObj : null;

    if (route != null && route.isNotEmpty) {
      log('📨 Firebase notification with explicit route: $route');
      Navigator.of(
        context,
      ).pushNamed(route, arguments: {'title': title, 'body': body, ...payload});
      return;
    }

    log('📨 Firebase notification -> NotificationView');
    Navigator.pushNamed(
      context,
      AppRoutes.notificationViewRouter,
      arguments: {'title': title, 'body': body},
    );
  } catch (e) {
    log('❌ Error in handleNotification: $e');
  }
}
