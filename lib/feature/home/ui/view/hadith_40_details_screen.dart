import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/feature/home/data/model/hadith_40_model.dart';

class Hadith40DetailsScreen extends StatelessWidget {
  final Hadith40Model model;
  const Hadith40DetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.category),centerTitle: true,
      foregroundColor: Theme.of(context).primaryColorDark,
      backgroundColor: Theme.of(context).cardColor,
        actions: [
          IconButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: '${model.hadith}\n\nشرح الحديث:\n${model.description}',
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم نسخ الحديث والشرح'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                model.hadith,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Amiri',
                  fontSize: 22.sp,
                  height: 1.6,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "شرح الحديث",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                  fontFamily: 'Amiri',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  const Divider(),
                  Text(
                    textAlign: TextAlign.justify,
                    model.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                               fontFamily: 'Amiri',
                      fontSize: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
