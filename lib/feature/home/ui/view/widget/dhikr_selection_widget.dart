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
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "اختر ذكرًا للسبحة",
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
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
                                ).primaryColor.withValues(alpha: 0.1)
                                : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            isSelected
                                ? Border.all(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 2,
                                )
                                : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              dhikr.text,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isSelected
                                        ? Theme.of(context).secondaryHeaderColor
                                        : Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
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
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onCustomDhikr,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "ذكر مخصص",
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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

class DhikrItem {
  final String text;
  final int? suggestedCount;

  DhikrItem({required this.text, this.suggestedCount});
}
