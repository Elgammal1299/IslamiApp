import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/notification/ui/view/widget/custom_notification_list.dart';
import 'package:islami_app/feature/notification/ui/view_model/cubit/notification_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<NotificationCubit>().clearAll();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            return CustomNotificationList(notifications: state.notifications);
          } else if (state is NotificationError) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
