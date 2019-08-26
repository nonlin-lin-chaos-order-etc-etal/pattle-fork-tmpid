// Copyright (C) 2019  Wilko Manger
//
// This file is part of Pattle.
//
// Pattle is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Pattle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Pattle.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:pattle/src/ui/util/color.dart';

ThemeData theme(Brightness brightness) {
  return ThemeData(
    primarySwatch: LightColors.red,
    primaryColorDark: LightColors.red[700],
    accentColor: LightColors.red,
    brightness: brightness,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    cursorColor: LightColors.red,
    buttonTheme: ButtonThemeData(
      buttonColor: LightColors.red[500],
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: AppBarTheme(
      color: LightColors.red,
    ),
  );
}

Color chatBackgroundColor(BuildContext context) {
  return themed(
    context,
    light: LightColors.red[50],
    dark: Colors.grey[900],
  );
}

Color redOnBackground(BuildContext context) {
  return themed(
    context,
    light: LightColors.red[500],
    dark: LightColors.red[100],
  );
}

class LightColors {
  LightColors._();

  static const _redPrimary = 0xFFAA4139;

  static const MaterialColor red = MaterialColor(
    _redPrimary,
    <int, Color>{
      50: Color(0xFFf5E8E7),
      100: Color(0xFFE6C6C4),
      200: Color(0xFFD5A09C),
      300: Color(0xFFC47A74),
      400: Color(0xFFB75E57),
      450: Color(0xFFB15048),
      500: Color(_redPrimary),
      600: Color(0xFFA33B33),
      700: Color(0xFF99322C),
      800: Color(0xFF902A24),
      900: Color(0xFF7F1C17),
      1000: Color(0xFF771914),
    },
  );

  static const userColors = [
    Color(0xFF79740E),
    Color(0xFFB57614),
    Color(0xFF076678),
    Color(0xFF8F3F71),
    Color(0xFF427B58),
    Color(0xFF3C3836),
    Color(0xFFAF3A03),
  ];
}
