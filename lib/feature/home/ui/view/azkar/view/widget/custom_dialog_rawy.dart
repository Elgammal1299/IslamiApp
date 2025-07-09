import 'package:flutter/material.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/model/supplication_model.dart';

class CustomDialogRawy extends StatelessWidget {
  const CustomDialogRawy({super.key, required this.supplication});

  final SupplicationModel supplication;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color(0xFFF2F2F2),
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
                title: Row(
                  children: const [
                    Icon(Icons.menu_book_rounded, color: Color(0xFF2B6777)),
                    SizedBox(width: 8),
                    Text(
                      "الراوي",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B6777),
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Text(
                    supplication.note!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B6777),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text("إغلاق"),
                  ),
                ],
              ),
        );
      },
      child: const Text(
        " الراوي",
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFFB2D1D8),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
