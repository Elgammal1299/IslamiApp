import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/supplication_reader_screen.dart';

class CustomAzkarYawmiListViewItem extends StatelessWidget {
  const CustomAzkarYawmiListViewItem({
    super.key,
    required this.items,
    required this.category,
  });

  final List<AzkarYawmiModel> items;
  final String category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SupplicationReaderScreen(supplications: items),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    category,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${items.length} ذكر',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  size: 24,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
