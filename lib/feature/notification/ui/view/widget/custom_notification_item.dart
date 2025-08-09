import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/notification/ui/view_model/cubit/notification_cubit.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';

class CustomNotificationItem extends StatelessWidget {
  final MapEntry<dynamic, dynamic> entry;

  const CustomNotificationItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final key = entry.key;
    final model = entry.value;
    final isRead = model.isRead ?? false;

    return InkWell(
      onTap: () {
        context.read<NotificationCubit>().markAsRead(key);
        final NotificationModel model = entry.value;
        if (model.type == 'scheduled') {
          Navigator.pushNamed(context, AppRoutes.azkarYawmiScreen);
        } else {
          Navigator.pushNamed(
            context,
            AppRoutes.notificationViewRouter,
            arguments: {'title': model.title, 'body': model.body},
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color:
              isRead
                  ? Theme.of(context).cardColor
                  : Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(model.title, style: context.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(model.body, style: context.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
