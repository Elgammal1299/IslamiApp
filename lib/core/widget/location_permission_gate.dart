import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// A reusable gate that requests and enforces location permission and services
/// just-in-time for features that require location (Play policy compliant).
class LocationPermissionGate extends StatefulWidget {
  final Widget child;
  final VoidCallback? onGrantedOnce;

  const LocationPermissionGate({
    super.key,
    required this.child,
    this.onGrantedOnce,
  });

  @override
  State<LocationPermissionGate> createState() => _LocationPermissionGateState();
}

class _LocationPermissionGateState extends State<LocationPermissionGate> {
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;
  bool _grantedCallbackFired = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    setState(() {
      _serviceEnabled = serviceEnabled;
      _permission = permission;
      _checking = false;
    });
  }

  Future<void> _request() async {
    final LocationPermission p = await Geolocator.requestPermission();
    setState(() => _permission = p);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_serviceEnabled) {
      return _PermissionScaffold(
        title: 'خدمة الموقع غير مفعلة',
        description:
            'يتطلب هذا القسم تفعيل خدمة الموقع لحساب اتجاه القبلة والمواقيت بدقة.',
        primaryText: 'فتح إعدادات الموقع',
        onPrimary: () async {
          await Geolocator.openLocationSettings();
          await _check();
        },
      );
    }

    if (_permission == LocationPermission.denied) {
      return _PermissionScaffold(
        title: 'إذن الموقع غير ممنوح',
        description:
            'نحتاج إذن الوصول للموقع أثناء الاستخدام لحساب القبلة ومواقيت الصلاة.',
        primaryText: 'امنح الإذن',
        onPrimary: () async {
          await _request();
          await _check();
        },
      );
    }

    if (_permission == LocationPermission.deniedForever) {
      return _PermissionScaffold(
        title: 'الإذن مرفوض دائمًا',
        description:
            'لقد رفضت الإذن مسبقًا. يمكنك منحه من إعدادات التطبيق للمتابعة.',
        primaryText: 'فتح إعدادات التطبيق',
        onPrimary: () async {
          await Geolocator.openAppSettings();
          await _check();
        },
      );
    }

    // Granted (whileInUse or always)
    if (!_grantedCallbackFired) {
      _grantedCallbackFired = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onGrantedOnce?.call();
      });
    }
    return widget.child;
  }
}

class _PermissionScaffold extends StatelessWidget {
  final String title;
  final String description;
  final String primaryText;
  final VoidCallback onPrimary;

  const _PermissionScaffold({
    required this.title,
    required this.description,
    required this.primaryText,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: onPrimary, child: Text(primaryText)),
            ],
          ),
        ),
      ),
    );
  }
}
