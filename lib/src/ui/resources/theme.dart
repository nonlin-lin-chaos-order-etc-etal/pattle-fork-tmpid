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

final ThemeData lightTheme = new ThemeData(
  primarySwatch: LightColors.red,
  accentColor: LightColors.green,

  brightness: Brightness.light,
  primaryColorBrightness: Brightness.dark,
  accentColorBrightness: Brightness.dark,

  buttonTheme: ButtonThemeData(
    buttonColor: LightColors.red[500],
    textTheme: ButtonTextTheme.primary
  ),
  textTheme: Typography.blackMountainView
);

class LightColors {
  LightColors._();

  static const _redPrimary = 0xFFAA4139;

  static const MaterialColor red = const MaterialColor(
    _redPrimary,
    const <int, Color>{
      50:  const Color(0xFFf5E8E7),
      100: const Color(0xFFE6C6C4),
      200: const Color(0xFFD5A09C),
      300: const Color(0xFFC47A74),
      400: const Color(0xFFB75E57),
      500: const Color(_redPrimary),
      600: const Color(0xFFA33B33),
      700: const Color(0xFF99322C),
      800: const Color(0xFF902A24),
      900: const Color(0xFF7F1C17),
    },
  );

  static const _greenPrimary = 0xFF779d34;

  static const MaterialColor green = const MaterialColor(
    _redPrimary,
    const <int, Color>{
      50:  const Color(0xFFEFF3E7),
      100: const Color(0xFFD6E2C2),
      200: const Color(0xFFBBCE9A),
      300: const Color(0xFFA0BA71),
      400: const Color(0xFF8BAC52),
      500: const Color(_greenPrimary),
      600: const Color(0xFF6f952F),
      700: const Color(0xFF648B27),
      800: const Color(0xFF5A8121),
      900: const Color(0xFF476F15),
    },
  );
}