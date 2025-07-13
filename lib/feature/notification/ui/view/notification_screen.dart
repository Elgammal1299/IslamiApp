import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/notification/data/model/notification_model.dart';
import 'package:islami_app/feature/notification/ui/view_model/cubit/notification_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📬 الإشعارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
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
          }

          if (state is NotificationError) {
            return Center(child: Text('❌ ${state.message}'));
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(child: Text('لا توجد إشعارات بعد 📭'));
            }

            final List<NotificationModel> items =
                state.notifications.reversed.toList();

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(item.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.body),
                      const SizedBox(height: 4),
                      Text(
                        item.dateTime.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(item.type),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
