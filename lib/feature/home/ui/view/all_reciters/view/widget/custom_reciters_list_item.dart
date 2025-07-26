import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/reciters_model.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/widget/reciters_surah_list.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';

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
              style: Theme.of(context).textTheme.titleLarge,
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
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: const Icon(Icons.play_arrow, color: AppColors.white),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider(
                                  create:
                                      (context) => AudioCubit(AudioManager()),
                                  child: RecitersSurahList(
                                    moshaf: moshaf,
                                    name: reciter.name ?? '',
                                  ),
                                );
                              },
                            ),
                          ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }
}
