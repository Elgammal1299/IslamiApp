import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/helper/audio_manager.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/audio_manager_cubit/audio_cubit.dart';
import 'package:islami_app/islami_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(
    BlocProvider(
      create: (context) => AudioCubit(AudioManager()),
      child: const IslamiApp(),
    ),
  );
}
