abstract class ThemeEvent {}

class InitializeThemeEvent extends ThemeEvent {
  final bool systemIsDarkMode;
  InitializeThemeEvent({required this.systemIsDarkMode});
}

class ToggleThemeEvent extends ThemeEvent {}

class SetThemeEvent extends ThemeEvent {
  final bool isDarkMode;
  SetThemeEvent({required this.isDarkMode});
}
