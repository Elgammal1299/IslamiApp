import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/notification/ui/view/widget/custom_notification_item.dart';
import 'package:islami_app/feature/notification/ui/view_model/cubit/notification_cubit.dart';

class CustomNotificationList extends StatelessWidget {
  final List<MapEntry<dynamic, dynamic>> notifications;

  const CustomNotificationList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(child: Text('لا توجد إشعارات'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<NotificationCubit>().init();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MarkAllAsReadButton(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final  entry = notifications[index];
                return CustomNotificationItem(entry: entry);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkAllAsReadButton extends StatelessWidget {
  const _MarkAllAsReadButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          context.read<NotificationCubit>().markAllAsRead();
        },
        child: Text(
          "تحديد الكل كمقروء",
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: Colors.blue),
        ),
      ),
    );
  }
}
