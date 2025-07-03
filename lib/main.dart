import 'package:flutter/material.dart';
import 'package:islami_app/islami_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const IslamiApp());
}
