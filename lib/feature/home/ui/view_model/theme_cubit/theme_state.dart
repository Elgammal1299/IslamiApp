part of 'theme_cubit.dart';

sealed class ThemeState extends Equatable {
  final bool isDark;
 const ThemeState({required this.isDark});
  @override
  List<Object?> get props => [];
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial({required super.isDark});
}

class LightThemeState extends ThemeState {
  const LightThemeState({required super.isDark});
}

class DarkThemeState extends ThemeState {
  const DarkThemeState({required super.isDark});
}
