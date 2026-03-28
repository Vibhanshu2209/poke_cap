import 'package:flutter/material.dart';

class PokemonColors {
  // Light Mode Colors
  static const Color normal = Color(0xFFDDCBD0);
  static const Color fighting = Color(0xFFFCC1B0);
  static const Color flying = Color(0xFFB2D2E8);
  static const Color poison = Color(0xFFCFB7ED);
  static const Color ground = Color(0xFFF4D1A6);
  static const Color rock = Color(0xFFC5AEA8);
  static const Color bug = Color(0xFFC1E0C8);
  static const Color ghost = Color(0xFFD7C2D7);
  static const Color steel = Color(0xFFC2D4CE);
  static const Color fire = Color(0xFFEDC2C4);
  static const Color water = Color(0xFFCBDEED);
  static const Color grass = Color(0xFFC0D4C8);
  static const Color electric = Color(0xFFE2E2A0);
  static const Color psychic = Color(0xFFDDC0CF);
  static const Color ice = Color(0xFFC7D7DF);
  static const Color dragon = Color(0xFFCADCDF);
  static const Color dark = Color(0xFFC6C5E3);
  static const Color fairy = Color(0xFFE4C0CF);
  static const Color unknown = Color(0xFFC0DFDD);
  static const Color shadow = Color(0xFFCACACA);

  // Dark Mode Colors (darker variants)
  static const Color normalDark = Color(0xFF6B5A63);
  static const Color fightingDark = Color(0xFF7A4D3C);
  static const Color flyingDark = Color(0xFF4A5F7A);
  static const Color poisonDark = Color(0xFF5A4874);
  static const Color groundDark = Color(0xFF7A5F3D);
  static const Color rockDark = Color(0xFF5A4840);
  static const Color bugDark = Color(0xFF4A5F40);
  static const Color ghostDark = Color(0xFF5A4A5A);
  static const Color steelDark = Color(0xFF5A5F5A);
  static const Color fireDark = Color(0xFF7A3D3A);
  static const Color waterDark = Color(0xFF4A5F7A);
  static const Color grassDark = Color(0xFF4A5F40);
  static const Color electricDark = Color(0xFF6B6B3A);
  static const Color psychicDark = Color(0xFF6B4A5A);
  static const Color iceDark = Color(0xFF4A5F6B);
  static const Color dragonDark = Color(0xFF4A5F6B);
  static const Color darkDark = Color(0xFF524A5A);
  static const Color fairyDark = Color(0xFF6B3A4A);
  static const Color unknownDark = Color(0xFF4A5F5F);
  static const Color shadowDark = Color(0xFF535353);

  static const Color background = Color(0xFFDEEDED);
  static const Color statsFragmentBg = Color(0xFFB0D2D2);
  static const Color statsFragmentBgDark = Color(0xFF2A4A4A);
  static const Color searchField = Color(0xFFC9DDE2);
  static const Color buttonColor = Color(0xFF2E3156);
  static const Color statBarBg = Color(0xFF93B2B2);

  static Color getColorByType(String type, {bool isDarkMode = false}) {
    if (isDarkMode) {
      switch (type.toLowerCase()) {
        case 'normal':
          return normalDark;
        case 'fighting':
          return fightingDark;
        case 'flying':
          return flyingDark;
        case 'poison':
          return poisonDark;
        case 'ground':
          return groundDark;
        case 'rock':
          return rockDark;
        case 'bug':
          return bugDark;
        case 'ghost':
          return ghostDark;
        case 'steel':
          return steelDark;
        case 'fire':
          return fireDark;
        case 'water':
          return waterDark;
        case 'grass':
          return grassDark;
        case 'electric':
          return electricDark;
        case 'psychic':
          return psychicDark;
        case 'ice':
          return iceDark;
        case 'dragon':
          return dragonDark;
        case 'dark':
          return darkDark;
        case 'fairy':
          return fairyDark;
        case 'unknown':
          return unknownDark;
        case 'shadow':
          return shadowDark;
        default:
          return Colors.grey;
      }
    } else {
      switch (type.toLowerCase()) {
        case 'normal':
          return normal;
        case 'fighting':
          return fighting;
        case 'flying':
          return flying;
        case 'poison':
          return poison;
        case 'ground':
          return ground;
        case 'rock':
          return rock;
        case 'bug':
          return bug;
        case 'ghost':
          return ghost;
        case 'steel':
          return steel;
        case 'fire':
          return fire;
        case 'water':
          return water;
        case 'grass':
          return grass;
        case 'electric':
          return electric;
        case 'psychic':
          return psychic;
        case 'ice':
          return ice;
        case 'dragon':
          return dragon;
        case 'dark':
          return dark;
        case 'fairy':
          return fairy;
        case 'unknown':
          return unknown;
        case 'shadow':
          return shadow;
        default:
          return Colors.grey;
      }
    }
  }
}

class StringConst {
  static const String hp = "HP";
  static const String attack = "Attack";
  static const String defense = "Defense";
  static const String speed = "Speed";
  static const String specialAttack = "Sp. Attack";
  static const String specialDefense = "Sp. Def.";

  static String getContentString(String type) {
    switch (type) {
      case 'hp':
        return hp;
      case 'attack':
        return attack;
      case 'defense':
        return defense;
      case 'speed':
        return speed;
      case 'special-attack':
        return specialAttack;
      case 'special-defense':
        return specialDefense;

      default:
        return "";
    }
  }
}
