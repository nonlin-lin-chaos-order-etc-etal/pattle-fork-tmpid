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
import 'package:provider/provider.dart';

import '../section/main/models/chat_member.dart';

const creteRound = 'CreteRound';

final PattleTheme pattleLightTheme = PattleTheme(
  primaryColorOnBackground: PattleTheme._primarySwatch[500],
  linkColor: PattleTheme._primarySwatch,
  chat: ChatTheme(
    backgroundColor: PattleTheme._primarySwatch[50],
    inputColor: Colors.white,
    myMessageColor: PattleTheme._primarySwatch[450],
    theirMessageColor: Colors.white,
    stateMessageColor: PattleTheme._primarySwatch[100],
    myRedactedContentColor: Colors.grey[300],
    theirRedactedContentColor: Colors.grey[700],
  ),
  userColors: {
    DisplayColor.greenYellow: Color(0xFF79740E),
    DisplayColor.yellow: Color(0xFFB57614),
    DisplayColor.blue: Color(0xFF076678),
    DisplayColor.purple: Color(0xFF8F3F71),
    DisplayColor.green: Color(0xFF427B58),
    DisplayColor.red: Color(0xFFAF3A03),
  },
  themeData: (base) => base.copyWith(brightness: Brightness.light),
);

final PattleTheme pattleDarkTheme = PattleTheme(
  primaryColorOnBackground: PattleTheme._primarySwatch[100],
  linkColor: Colors.white,
  chat: ChatTheme(
    backgroundColor: Colors.grey[900],
    inputColor: Colors.grey[800],
    myMessageColor: PattleTheme._primarySwatch[700],
    theirMessageColor: Colors.grey[800],
    stateMessageColor: PattleTheme._primarySwatch[900],
    myRedactedContentColor: Colors.white30,
    theirRedactedContentColor: Colors.white70,
  ),
  userColors: {
    DisplayColor.greenYellow: Color(0xFFE7DF35),
    DisplayColor.yellow: Color(0xFFECB258),
    DisplayColor.blue: Color(0xFF25D1F2),
    DisplayColor.purple: Color(0xFFC780AC),
    DisplayColor.green: Color(0xFF81BB98),
    DisplayColor.red: Color(0xFFFB783C),
  },
  themeData: (base) => base.copyWith(
    brightness: Brightness.dark,
    toggleableActiveColor: PattleTheme._primarySwatch[400],
    textSelectionHandleColor: PattleTheme._primarySwatch[400],
  ),
);

class PattleTheme {
  static const _redPrimary = 0xFFAA4139;
  static const _primarySwatch = MaterialColor(
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

  final MaterialColor primarySwatch;

  final ThemeData themeData;

  static ThemeData _baseThemeData(MaterialColor primary) {
    return ThemeData(
      primarySwatch: primary,
      primaryColorDark: primary[700],
      accentColor: primary,
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      cursorColor: primary,
      buttonTheme: ButtonThemeData(
        buttonColor: primary[500],
        textTheme: ButtonTextTheme.primary,
      ),
      appBarTheme: AppBarTheme(
        color: primary,
      ),
    );
  }

  PattleTheme({
    this.primarySwatch = _primarySwatch,
    @required this.primaryColorOnBackground,
    @required this.linkColor,
    @required this.chat,
    @required this.userColors,
    ThemeData Function(ThemeData base) themeData,
  }) : themeData = themeData == null
            ? _baseThemeData(primarySwatch)
            : themeData(_baseThemeData(primarySwatch));

  Color get primaryColor => themeData.primaryColor;

  Color get primaryColorLight => themeData.primaryColorLight;

  Color get primaryColorDark => themeData.primaryColorDark;

  final Color primaryColorOnBackground;

  final Color linkColor;

  final ChatTheme chat;

  final Map<DisplayColor, Color> userColors;

  static PattleTheme of(BuildContext context, {bool listen = true}) =>
      Provider.of<PattleTheme>(
        context,
        listen: listen,
      );
}

class ChatTheme {
  final Color backgroundColor;
  final Color inputColor;

  final Color myMessageColor;
  final Color theirMessageColor;

  final Color stateMessageColor;

  final Color myRedactedContentColor;
  final Color theirRedactedContentColor;

  ChatTheme({
    @required this.backgroundColor,
    @required this.inputColor,
    @required this.myMessageColor,
    @required this.theirMessageColor,
    @required this.stateMessageColor,
    @required this.myRedactedContentColor,
    @required this.theirRedactedContentColor,
  });
}

extension PattleThemeContext on BuildContext {
  PattleTheme get pattleTheme => PattleTheme.of(this);
}
