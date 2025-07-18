import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/data/model/home_model.dart';

class HomeItemCard extends StatelessWidget {
  final HomeItemModel item;

  const HomeItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).secondaryHeaderColor,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Column(
            children: [
              // ✅ BODY: صورة فوق على خلفية فاتحة
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),
              ),

              // ✅ FOOTER: اسم داخل شريط مزخرف أو لون متدرج
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),

                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      item.name,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
