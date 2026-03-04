import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';

class DhikrSelectionWidget extends StatelessWidget {
  final List<DhikrItem> dhikrList;
  final DhikrItem? selectedDhikr;
  final Function(DhikrItem) onDhikrSelected;
  final VoidCallback onCustomDhikr;

  const DhikrSelectionWidget({
    super.key,
    required this.dhikrList,
    required this.onDhikrSelected,
    required this.onCustomDhikr,
    this.selectedDhikr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      // margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).shadowColor,
        //     blurRadius: 10,
        //     offset: const Offset(0, 5),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Text(
            "اختر ذكرًا للسبحة",
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
              fontFamily: 'Amiri',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: dhikrList.length,
              itemBuilder: (context, index) {
                final dhikr = dhikrList[index];
                final isSelected = selectedDhikr?.text == dhikr.text;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => onDhikrSelected(dhikr),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(
                                  context,
                                ).cardColor
                                : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            isSelected
                                ? Border.all(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 2,
                                )
                                : Border.all(
                                  color: Colors.grey,
                                  width:1,
                                ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              dhikr.text,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontFamily: 'Amiri',
                                fontSize: 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColorDark
                                        : Theme.of(
                                          context,
                                        ).primaryColorDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColorDark,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // const SizedBox(height: 15),
          // Row(
          //   children: [
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: onCustomDhikr,
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Theme.of(context).primaryColor,
          //           foregroundColor: Theme.of(context).colorScheme.onSurface,
          //           padding: const EdgeInsets.symmetric(vertical: 12),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //         ),
          //         child: Text(
          //           "ذكر مخصص",
          //           style: context.textTheme.titleMedium?.copyWith(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class DhikrItem {
  final String text;
  final int? suggestedCount;

  DhikrItem({required this.text, this.suggestedCount});
}
