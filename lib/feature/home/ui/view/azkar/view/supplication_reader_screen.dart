import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/azkar_yawmi_model.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view/widget/custom_card_body_azkar.dart';

class SupplicationReaderScreen extends StatefulWidget {
  final List<AzkarYawmiModel> supplications;

  const SupplicationReaderScreen({super.key, required this.supplications});

  @override
  State<SupplicationReaderScreen> createState() =>
      _SupplicationReaderScreenState();
}

class _SupplicationReaderScreenState extends State<SupplicationReaderScreen> {
  late List<int> userCounts;

  @override
  void initState() {
    super.initState();
    userCounts = List.filled(widget.supplications.length, 0);
  }

  void _handleTap(int index) {
    final current = widget.supplications[index];
    final maxCount = current.count;

    if (userCounts[index] < maxCount) {
      setState(() {
        userCounts[index]++;
      });

      // Optional: Logic to handle completion of all azkar could go here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الذكر')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.supplications.length,
        itemBuilder: (context, index) {
          final current = widget.supplications[index];
          return CustomCardBodyAzkar(
            current: current,
            currentCount: userCounts[index],
            maxCount: current.count,
            onTap: () => _handleTap(index),
          );
        },
      ),
    );
  }
}
