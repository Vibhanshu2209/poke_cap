import 'package:flutter/material.dart';

abstract class ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;
  final bool isUserOverride; // true if user manually toggled, false if using system

  ThemeState({
    required this.themeData,
    required this.isDarkMode,
    this.isUserOverride = false,
  });
}

class ThemeInitial extends ThemeState {
  ThemeInitial({
    required ThemeData themeData,
    required bool isDarkMode,
    bool isUserOverride = false,
  }) : super(themeData: themeData, isDarkMode: isDarkMode, isUserOverride: isUserOverride);
}

class ThemeChanged extends ThemeState {
  ThemeChanged({
    required ThemeData themeData,
    required bool isDarkMode,
    bool isUserOverride = false,
  }) : super(themeData: themeData, isDarkMode: isDarkMode, isUserOverride: isUserOverride);
}
