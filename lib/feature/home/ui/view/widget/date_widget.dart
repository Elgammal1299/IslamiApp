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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
     child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
      
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showHijri = !_showHijri;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _showHijri ? 'التاريخ الهجري' : 'التاريخ الميلادي',
                        style: TextStyle(
                          color:  Theme.of(context).primaryColorDark,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Uthmanic',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _showHijri ? _getHijriDate() : _getGregorianDate(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Uthmanic',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.swap_horiz_rounded,
                      color: Theme.of(context).primaryColorDark,
                      size: 20.sp,
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