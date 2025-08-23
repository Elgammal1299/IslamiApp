import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:islami_app/core/services/setup_service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'is_dark_mode';

  ThemeCubit()
    : super(
        ThemeInitial(
          isDark: (sl<SharedPreferences>().getBool(_themeKey)) ?? false,
        ),
      );

  /// التبديل بين الثيمات + الحفظ
  Future<void> toggleTheme() async {
    if (state is LightThemeState) {
      await sl<SharedPreferences>().setBool(_themeKey, true);
      emit(const DarkThemeState(isDark: true));
    } else {
      await sl<SharedPreferences>().setBool(_themeKey, false);
      emit(const LightThemeState(isDark: false));
    }
  }

  /// تعيين الوضع الليلي مع الحفظ
  Future<void> setDark() async {
    await sl<SharedPreferences>().setBool(_themeKey, true);
    emit(
      const DarkThemeState(
        isDark: false, //await sl<SharedPreferences>().setBool(_themeKey, true),
      ),
    );
  }

  /// تعيين الوضع الفاتح مع الحفظ
  Future<void> setLight() async {
    await sl<SharedPreferences>().setBool(_themeKey, false);

    emit(
      const LightThemeState(
        isDark: false, //sl<SharedPreferences>().setBool(_themeKey, false),
      ),
    );
  }
}
