import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islami_app/core/constant/app_image.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen> {
  bool _hasPermission = false;
  bool _locationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationEnabled = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    setState(() {
      _hasPermission =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      _locationEnabled = serviceEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_locationEnabled) {
      return Scaffold(
        appBar: AppBar(title: const Text('القبلة')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImage.gpsImage),
              Text(
                "!! يرجى تفعيل الموقع",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImage.gpsImage, width: 300, height: 300),
              Text(
                "يجب منح إذن الوصول للموقع",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("اتجاه القبلة")),
      body: StreamBuilder<QiblahDirection>(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "حدث خطأ في تحديد القبلة",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          final qiblahDirection = snapshot.data;
          final angle = qiblahDirection!.qiblah; // بالدرجات
          final angleInRadians = angle * (pi / 180); // بالراديان

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
                  angle: angleInRadians,
                  child: SvgPicture.asset(
                    AppImage.needleImage,
                    width: 270,
                    height: 270,
                  ),
                ),
                Transform.rotate(
                  angle: angleInRadians,
                  child: Transform.translate(
                    offset: const Offset(0, -170), // المسافة من المركز (سالب للأعلى)
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
