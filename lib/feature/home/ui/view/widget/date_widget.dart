import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  bool _showHijri = true;

  String _getHijriDate() {
    HijriCalendar.setLocal('ar');
    var hijriDate = HijriCalendar.now();
    return '${hijriDate.hDay} ${hijriDate.getLongMonthName()} ${hijriDate.hYear} هـ';
  }

  String _getGregorianDate() {
    final now = DateTime.now();
    final formatter = DateFormat('d MMMM yyyy', 'ar');
    return '${formatter.format(now)} م';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColorDark.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showHijri = !_showHijri;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           Text(
                  _showHijri ? _getHijriDate() : _getGregorianDate(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Uthmanic',
                  ),
                ),
                SizedBox(width: 12.w),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                color: Theme.of(context).primaryColorDark,
                size: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}