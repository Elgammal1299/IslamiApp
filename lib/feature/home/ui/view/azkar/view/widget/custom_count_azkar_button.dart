import 'package:flutter/material.dart';

class CustomCountAzkarButton extends StatelessWidget {
  const CustomCountAzkarButton({super.key, this.onTap, this.progress});
  final Function()? onTap;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
