import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:islami_app/core/router/app_routes.dart';

/// Handles notification payload and routes accordingly.
void handleNotification(BuildContext context, Map<String, dynamic> data) {
  try {
    log('📨 Notification data received: $data');

    final String? type = data['type']?.toString().toLowerCase();
    final String? route = data['route']?.toString().toLowerCase();
    final String? id = data['id']?.toString();
    final String? slug = data['slug']?.toString();

    if (id != null) _markNotificationAsRead(id);

    if (route != null) {
      _navigateByRoute(context, route, slug);
    } else if (type != null) {
      _navigateByType(context, type, slug, data);
    } else {
      log("⚠️ No 'route' or 'type' found in notification");
      _goToDefault(context);
    }
  } catch (e) {
    log('❌ Error in handleNotification: $e');
  }
}

/// Optional: Mark as read from backend
Future<void> _markNotificationAsRead(String id) async {
  try {
    // await getIt<NotificationRepo>().markAsRead(id);
    log('✅ Marked as read: $id');
  } catch (e) {
    log('❌ Error marking as read: $e');
  }
}

/// Routing based on [route] field
void _navigateByRoute(BuildContext context, String route, String? slug) {
  switch (route) {
    case '/notifications':
    case '/profile':
    case '/invoice_details':
      Navigator.pushNamed(context, AppRoutes.homeRoute);
      break;

    case '/home_details_qadim':
    case '/home_details_muntahi':
    case '/home_details_jaraa':
    case '/home_details_sayantaliq':
      _navigateWithSlug(context, slug);
      break;

    case '/azkar_page':
      Navigator.pushNamed(context, AppRoutes.quranViewRouter);
      break;

    default:
      log('⚠️ Unknown route: $route');
      _goToDefault(context);
  }
}

/// Routing based on [type] field
void _navigateByType(
  BuildContext context,
  String type,
  String? slug,
  Map<String, dynamic> data,
) {
  switch (type) {
    case 'auction':
      final auctionType = data['auction_type']?.toString().toLowerCase();
      log("🏷 Auction type: $auctionType");
      _navigateWithSlug(context, slug);
      break;

    case 'invoice':
    case 'system':
      Navigator.pushNamed(context, AppRoutes.homeRoute);
      break;

    case 'azkar':
      Navigator.pushNamed(context, AppRoutes.quranViewRouter);
      break;

    default:
      log('⚠️ Unknown type: $type');
      _goToDefault(context);
  }
}

/// Navigate to home with optional slug
void _navigateWithSlug(BuildContext context, String? slug) {
  Navigator.pushNamed(
    context,
    AppRoutes.homeRoute,
    arguments: slug != null ? {'slug': slug} : null,
  );
}

/// Fallback
void _goToDefault(BuildContext context) {
  Navigator.pushNamed(context, AppRoutes.homeRoute);
}
