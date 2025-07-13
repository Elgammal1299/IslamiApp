import 'package:flutter/material.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/notification/ui/view_model/cubit/notification_cubit.dart';

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
        Navigator.pushNamed(context, AppRoutes.homeRoute);
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
            Text(model.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(model.body, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
