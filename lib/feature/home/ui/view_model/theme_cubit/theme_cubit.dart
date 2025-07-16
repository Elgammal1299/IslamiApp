import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'is_dark_mode';

  ThemeCubit() : super(ThemeInitial());

  /// تحميل الثيم من SharedPreferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    if (isDark) {
      emit(DarkThemeState());
    } else {
      emit(LightThemeState());
    }
  }

  /// التبديل بين الثيمات + الحفظ
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state is LightThemeState) {
      await prefs.setBool(_themeKey, true);
      emit(DarkThemeState());
    } else {
      await prefs.setBool(_themeKey, false);
      emit(LightThemeState());
    }
  }

  /// تعيين الوضع الليلي مع الحفظ
  Future<void> setDark() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, true);
    emit(DarkThemeState());
  }

  /// تعيين الوضع الفاتح مع الحفظ
  Future<void> setLight() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, false);
    emit(LightThemeState());
  }
}
