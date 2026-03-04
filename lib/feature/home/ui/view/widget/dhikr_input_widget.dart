import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';

class DhikrInputWidget extends StatelessWidget {
  final TextEditingController dhikrController;
  final TextEditingController targetController;
  final VoidCallback onSave;

  const DhikrInputWidget({
    super.key,
    required this.dhikrController,
    required this.targetController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
        //     blurRadius: 10,
        //     offset: const Offset(0, 5),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "إضافة ذكر للسبحة",
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
              fontFamily: 'Amiri',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          TextField(
            style:  TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
            ),
            autofocus: true,

            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            controller: dhikrController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "اكتب الذكر هنا (مطلوب)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              hintStyle: TextStyle(
                color: Theme.of(context).primaryColorDark
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style:  TextStyle(
                       color: Theme.of(context).primaryColorDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',

                  ),
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "العدد المطلوب (اختياري)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                     
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                     hintStyle: TextStyle(
                color: Theme.of(context).primaryColorDark
              ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Theme.of(context).primaryColorDark,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  "حفظ",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: 'Amiri',
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
