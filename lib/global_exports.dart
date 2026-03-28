export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:flutter/material.dart';
export 'package:go_router/go_router.dart';
export 'package:dio/dio.dart';
export 'package:get_it/get_it.dart';
export 'package:provider/provider.dart';
export 'core/constants.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:poke_cap/core/constants.dart';

final logger = Logger(level: Level.all);

extension WebWidthConstrained on Widget {
  ConstrainedBox limitedwidth() {
    return ConstrainedBox(
        constraints: BoxConstraints.tight(const Size.fromWidth(500)),
        child: center());
  }

  Center center() {
    return Center(child: this);
  }

  ConstrainedBox bottomNav() {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 60, maxWidth: 500));
  }
}

extension StringToTextWidget on String {
  Text tw(
      {double? fontSize, Color? fontColor, TextStyle? ts, TextAlign? align}) {
    return Text(this,
        textAlign: align ?? TextAlign.start,
        style: ts ?? TextStyle(fontSize: fontSize, color: fontColor));
  }

  RichText richtw({double? fontSize, Color? fontColor, TextStyle? ts}) {
    return RichText(
        text: TextSpan(
            text: this,
            style: ts ?? TextStyle(fontSize: fontSize, color: fontColor)));
  }

  String capitalizeFirstLetter() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  double parseAsDoubleOrElse({double defaultVal = 0.0}) {
    try {
      return double.parse(this);
    } catch (_) {
      return defaultVal;
    }
  }

  int parseAsIntOrElse({int defaultVal = 0}) {
    try {
      return int.parse(this);
    } catch (_) {
      return defaultVal;
    }
  }
}

List<Widget> listOfWidgetsWithSpacing(List<Widget> widgets,
    {double width = 4.0, double height = 4.0, Widget? seperatorWidget}) {
  if (widgets.isEmpty) return [];

  List<Widget> spacedWidgets = [];
  for (int i = 0; i < widgets.length; i++) {
    spacedWidgets.add(widgets[i]);
    if (i < widgets.length - 1) {
      spacedWidgets.add(seperatorWidget ??
          SizedBox(
              width: width, height: height)); // Add spacing between widgets
    }
  }
  return spacedWidgets;
}

ThemeData get lightTheme => ThemeData(
      sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: PokemonColors.buttonColor,
          primaryColorDark: PokemonColors.statBarBg,
          primaryColorLight: PokemonColors.electric,
          valueIndicatorTextStyle: TextStyle(color: PokemonColors.background)),
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.light, // Ensures this is a light theme
      ),
    );

ThemeData get darkTheme => ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.dark, // Ensures this is a dark theme
      ),
    );

extension ShortHands on Widget {
  Center center() {
    return Center(child: this);
  }

  Padding padAll(double? value) {
    return Padding(padding: EdgeInsets.all(value ?? 8), child: this);
  }

  Padding padX(double? value) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: value ?? 8), child: this);
  }

  Padding padY(double? value) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: value ?? 8), child: this);
  }
}
