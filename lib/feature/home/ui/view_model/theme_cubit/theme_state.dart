part of 'theme_cubit.dart';

sealed class ThemeState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ThemeInitial extends ThemeState {}

class LightThemeState extends ThemeState {}

class DarkThemeState extends ThemeState {}
