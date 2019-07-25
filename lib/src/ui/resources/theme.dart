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
  brightness: Brightness.light,
  primaryColorBrightness: Brightness.dark,
  accentColorBrightness: Brightness.dark,
  cursorColor: LightColors.red,
  buttonTheme: ButtonThemeData(
    buttonColor: LightColors.red[500],
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: Typography.blackMountainView,
);

class LightColors {
  LightColors._();

  static const _redPrimary = 0xFFAA4139;

  static const MaterialColor red = const MaterialColor(
    _redPrimary,
    const <int, Color>{
      50: const Color(0xFFf5E8E7),
      100: const Color(0xFFE6C6C4),
      200: const Color(0xFFD5A09C),
      300: const Color(0xFFC47A74),
      400: const Color(0xFFB75E57),
      450: const Color(0xFFB15048),
      500: const Color(_redPrimary),
      600: const Color(0xFFA33B33),
      700: const Color(0xFF99322C),
      800: const Color(0xFF902A24),
      900: const Color(0xFF7F1C17),
    },
  );

  static const userColors = [
    const Color(0xFF79740E),
    const Color(0xFFB57614),
    const Color(0xFF076678),
    const Color(0xFF8F3F71),
    const Color(0xFF427B58),
    const Color(0xFF3C3836),
    const Color(0xFFAF3A03),
  ];
}
