import 'package:poke_cap/global_exports.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(
        ThemeInitial(
          themeData: lightTheme,
          isDarkMode: false,
          isUserOverride: false,
        ),
      ) {
    on<InitializeThemeEvent>(_onInitializeTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  Future<void> _onInitializeTheme(
    InitializeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(
      ThemeInitial(
        themeData: event.systemIsDarkMode ? darkTheme : lightTheme,
        isDarkMode: event.systemIsDarkMode,
        isUserOverride: false, // Using system preference
      ),
    );
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final isDarkMode = !state.isDarkMode;
    emit(
      ThemeChanged(
        themeData: isDarkMode ? darkTheme : lightTheme,
        isDarkMode: isDarkMode,
        isUserOverride: true, // User manually toggled
      ),
    );
  }

  Future<void> _onSetTheme(
    SetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(
      ThemeChanged(
        themeData: event.isDarkMode ? darkTheme : lightTheme,
        isDarkMode: event.isDarkMode,
        isUserOverride: true, // User manually set
      ),
    );
  }
}
