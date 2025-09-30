import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/reciters_model.dart';
import 'package:islami_app/core/router/app_routes.dart';

class CustomRecitersListItem extends StatelessWidget {
  const CustomRecitersListItem({
    super.key,
    required this.reciter,
    required this.isExpanded,
    required this.onTap,
  });
  final Reciters reciter;
  final bool isExpanded;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.mic, color: AppColors.white),
            ),
            title: Text(
              reciter.name ?? 'Unknown',
              style: context.textTheme.titleLarge,
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 30,
            ),
            onTap: onTap,
          ),
          if (isExpanded && reciter.moshaf != null)
            Column(
              children:
                  reciter.moshaf!.map((moshaf) {
                    return ListTile(
                      title: Text(
                        moshaf.name ?? "Unknown",
                        style: context.textTheme.bodyLarge,
                      ),
                      trailing: const Icon(
                        Icons.play_arrow,
                        color: AppColors.white,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.recitersSurahListRouter,
                          arguments: {
                            'moshaf': moshaf,
                            'name': reciter.name ?? '',
                          },
                        );
                      },
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }
}
