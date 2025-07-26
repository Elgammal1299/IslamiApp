import 'package:islami_app/feature/home/ui/view_model/theme_cubit/theme_cubit.dart';

class ThemeInitializer {
  final ThemeCubit themeCubit = ThemeCubit();

  Future<void> init() async {
    await themeCubit.loadTheme();
  }
}
