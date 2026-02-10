import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/feature/home/data/model/home_model.dart';

class HomeItemCard extends StatelessWidget {
  final HomeItemModel item;

  const HomeItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.route);
        log('Navigating to ${item.route}', name: 'HomeItemCard');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          

        color:  Theme.of(context).cardColor,
         
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Image.asset(item.image, fit: BoxFit.contain,),
              ),
            ),

            // Text section
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: Text(
                item.name,
                style:  TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 20.sp,
                  fontFamily: 'uthmanic',
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
