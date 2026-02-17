import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_card_body_azkar.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_count_azkar_button.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_count_repet_item.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_finich_azkar.dart';

class SupplicationReaderScreen extends StatefulWidget {
  final List<AzkarYawmiModel> supplications;

  const SupplicationReaderScreen({super.key, required this.supplications});

  @override
  State<SupplicationReaderScreen> createState() =>
      _SupplicationReaderScreenState();
}

class _SupplicationReaderScreenState extends State<SupplicationReaderScreen> {
  int currentIndex = 0;
  int repeatCount = 0;

  void _handleTap() {
    final current = widget.supplications[currentIndex];
    final maxCount = current.count;

    if (repeatCount + 1 < maxCount) {
      setState(() => repeatCount++);
    } else {
      setState(() {
        currentIndex++;
        repeatCount = 0;
      });
    }
  }

  void _skipSupplication() {
    setState(() {
      currentIndex++;
      repeatCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= widget.supplications.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('تمت القراءة')),
        body: const CustomFinichAzkar(),
      );
    }

    final current = widget.supplications[currentIndex];

    final maxCount = current.count;
    final progress = repeatCount / maxCount;
    // final listProgress = (currentIndex + 1) / widget.supplications.length;

    return Scaffold(
      appBar: AppBar(title: const Text('الذكر')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              140,
            ), // علشان نسيب مساحة للزر
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCardBodyAzkar(current: current),
                const SizedBox(height: 24),
                //عدد الاذكار
                CustomCountRepetItem(
                  currentIndex: currentIndex,
                  widget: widget,
                  maxCount: maxCount,
                  currentCount: repeatCount,
                ),

                TextButton(
                  onPressed: _skipSupplication,
                  child: Text(
                    'تخطي الذكر',
                    style: context.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          CustomCountAzkarButton(onTap: _handleTap, progress: progress),
        ],
      ),
    );
  }
}
