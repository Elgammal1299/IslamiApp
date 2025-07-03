import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/reciters_model.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/widget/reciters_surah_list.dart';

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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.mic, color: Colors.white),
            ),
            title: Text(reciter.name ?? 'Unknown'),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
            onTap: onTap,
          ),
          if (isExpanded && reciter.moshaf != null)
            Column(
              children:
                  reciter.moshaf!.map((moshaf) {
                    return ListTile(
                      title: Text(moshaf.name ?? "Unknown"),
                      trailing: Icon(Icons.play_arrow, color: Colors.green),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RecitersSurahList(
                                  server: moshaf.server ?? '',
                                  surahList: moshaf.surahList ?? '1,2,3',
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
