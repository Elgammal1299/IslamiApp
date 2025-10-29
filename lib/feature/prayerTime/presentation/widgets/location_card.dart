import 'package:flutter/material.dart';

import 'package:islami_app/feature/prayerTime/presentation/widgets/arabic_date_time.dart';

class LocationCardWidget extends StatelessWidget {
  final String? locationName;
  final bool isUpdating;
  final VoidCallback onUpdate;

  const LocationCardWidget({
    super.key,
    required this.locationName,
    required this.isUpdating,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ArabicDateTimeWidget(),
              isUpdating
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: onUpdate,
                    tooltip: 'تحديث الموقع',
                  ),
            ],
          ),

          if (locationName != null)
            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(locationName!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                )),
              ],
            )
          else
            const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('جاري تحديد الموقع...'),
              ],
            ),
        ],
      ),
    );
  }
}
