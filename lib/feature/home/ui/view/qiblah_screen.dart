import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/gps.png'),
              Text(
                "!! يرجى تفعيل الموقع",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              Image.asset('assets/images/gps.png', width: 300, height: 300),
              Text(
                "يجب منح إذن الوصول للموقع",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            return Center(child: Text("حدث خطأ في تحديد القبلة"));
          }

          final qiblahDirection = snapshot.data;
          final angle = qiblahDirection!.qiblah; // بالدرجات
          final angleInRadians = angle * (pi / 180); // بالراديان

          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/Compass.svg',
                  width: 300,
                  height: 300,
                ),

                Transform.rotate(
                  angle: angleInRadians,
                  child: SvgPicture.asset(
                    'assets/images/needle.svg',
                    width: 270,
                    height: 270,
                  ),
                ),
                Transform.rotate(
                  angle: angleInRadians,
                  child: Transform.translate(
                    offset: Offset(0, -170), // المسافة من المركز (سالب للأعلى)
                    child: Image.asset(
                      'assets/images/Qibla.png',
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
