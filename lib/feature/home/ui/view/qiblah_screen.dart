import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:islami_app/core/widget/location_permission_gate.dart';
import 'package:islami_app/feature/home/services/location_service.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen> {
  final LocationService _locationService = sl<LocationService>();

  /// Calculate bearing (in degrees) from the user's location to the Kaaba.
  double _qiblaBearing(double lat, double lng) {
    const kaabaLat = 21.4225 * pi / 180;
    const kaabaLng = 39.8262 * pi / 180;
    final latRad = lat * pi / 180;
    final lngRad = lng * pi / 180;

    final dLng = kaabaLng - lngRad;
    final y = sin(dLng) * cos(kaabaLat);
    final x = cos(latRad) * sin(kaabaLat) -
        sin(latRad) * cos(kaabaLat) * cos(dLng);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  @override
  Widget build(BuildContext context) {
    final stored = _locationService.getStoredLocation();

    // First time – no stored location, need to get it once
    if (stored == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("اتجاه القبلة")),
        body: LocationPermissionGate(
          onGrantedOnce: () async {
            try {
              await _locationService.updateLocation();
              if (mounted) setState(() {});
            } catch (_) {}
          },
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final bearing = _qiblaBearing(stored.latitude, stored.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text("اتجاه القبلة"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث الموقع',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await _locationService.updateLocation();
                if (mounted) setState(() {});
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث الموقع بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (_) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('تعذر تحديث الموقع. تأكد من تفعيل خدمة الموقع'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                "حدث خطأ في تحديد القبلة",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          final heading = snapshot.data!.heading ?? 0;
          final qiblaAngle = (bearing - heading) * (pi / 180);

          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppImage.compassDarkImage
                      : AppImage.compassImage,
                  width: 300,
                  height: 300,
                ),
                Transform.rotate(
                  angle: qiblaAngle,
                  child: SvgPicture.asset(
                    AppImage.needleImage,
                    width: 270,
                    height: 270,
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Image.asset(
                    AppImage.kaabaImage,
                    width: 40,
                    height: 40,
                  ),
                ),
                Transform.rotate(
                  angle: qiblaAngle,
                  child: Transform.translate(
                    offset: const Offset(0, -170),
                    child: Image.asset(
                      AppImage.kaabaImage,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
