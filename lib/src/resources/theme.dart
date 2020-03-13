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

import '../util/color.dart';

final _theme = ThemeData(
  primarySwatch: LightColors.red,
  primaryColorDark: LightColors.red[700],
  accentColor: LightColors.red,
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

final lightTheme = _theme.copyWith(
  brightness: Brightness.light,
);

final darkTheme = ThemeData.dark().merge(_theme).copyWith(
      //brightness: Brightness.dark,
      toggleableActiveColor: LightColors.red[400],
      textSelectionHandleColor: LightColors.red[400],
    );

extension Themes on ThemeData {
  ThemeData merge(ThemeData other) {
    return this.copyWith(
      brightness: other.brightness ?? this.brightness,
      primaryColor: other.primaryColor ?? this.primaryColor,
      primaryColorBrightness:
          other.primaryColorBrightness ?? this.primaryColorBrightness,
      primaryColorLight: other.primaryColorLight ?? this.primaryColorLight,
      primaryColorDark: other.primaryColorDark ?? this.primaryColorDark,
      accentColor: other.accentColor ?? this.accentColor,
      accentColorBrightness:
          other.accentColorBrightness ?? this.accentColorBrightness,
      canvasColor: other.canvasColor ?? this.canvasColor,
      scaffoldBackgroundColor:
          other.scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      bottomAppBarColor: other.bottomAppBarColor ?? this.bottomAppBarColor,
      cardColor: other.cardColor ?? this.cardColor,
      dividerColor: other.dividerColor ?? this.dividerColor,
      focusColor: other.focusColor ?? this.focusColor,
      hoverColor: other.hoverColor ?? this.hoverColor,
      highlightColor: other.highlightColor ?? this.highlightColor,
      splashColor: other.splashColor ?? this.splashColor,
      splashFactory: other.splashFactory ?? this.splashFactory,
      selectedRowColor: other.selectedRowColor ?? this.selectedRowColor,
      unselectedWidgetColor:
          other.unselectedWidgetColor ?? this.unselectedWidgetColor,
      disabledColor: other.disabledColor ?? this.disabledColor,
      buttonColor: other.buttonColor ?? this.buttonColor,
      buttonTheme: other.buttonTheme ?? this.buttonTheme,
      toggleButtonsTheme: other.toggleButtonsTheme ?? this.toggleButtonsTheme,
      secondaryHeaderColor:
          other.secondaryHeaderColor ?? this.secondaryHeaderColor,
      textSelectionColor: other.textSelectionColor ?? this.textSelectionColor,
      cursorColor: other.cursorColor ?? this.cursorColor,
      textSelectionHandleColor:
          other.textSelectionHandleColor ?? this.textSelectionHandleColor,
      backgroundColor: other.backgroundColor ?? this.backgroundColor,
      dialogBackgroundColor:
          other.dialogBackgroundColor ?? this.dialogBackgroundColor,
      indicatorColor: other.indicatorColor ?? this.indicatorColor,
      hintColor: other.hintColor ?? this.hintColor,
      errorColor: other.errorColor ?? this.errorColor,
      toggleableActiveColor:
          other.toggleableActiveColor ?? this.toggleableActiveColor,
      textTheme: other.textTheme ?? this.textTheme,
      primaryTextTheme: other.primaryTextTheme ?? this.primaryTextTheme,
      accentTextTheme: other.accentTextTheme ?? this.accentTextTheme,
      inputDecorationTheme:
          other.inputDecorationTheme ?? this.inputDecorationTheme,
      iconTheme: other.iconTheme ?? this.iconTheme,
      primaryIconTheme: other.primaryIconTheme ?? this.primaryIconTheme,
      accentIconTheme: other.accentIconTheme ?? this.accentIconTheme,
      sliderTheme: other.sliderTheme ?? this.sliderTheme,
      tabBarTheme: other.tabBarTheme ?? this.tabBarTheme,
      tooltipTheme: other.tooltipTheme ?? this.tooltipTheme,
      cardTheme: other.cardTheme ?? this.cardTheme,
      chipTheme: other.chipTheme ?? this.chipTheme,
      platform: other.platform ?? this.platform,
      materialTapTargetSize:
          other.materialTapTargetSize ?? this.materialTapTargetSize,
      applyElevationOverlayColor:
          other.applyElevationOverlayColor ?? this.applyElevationOverlayColor,
      pageTransitionsTheme:
          other.pageTransitionsTheme ?? this.pageTransitionsTheme,
      appBarTheme: other.appBarTheme ?? this.appBarTheme,
      bottomAppBarTheme: other.bottomAppBarTheme ?? this.bottomAppBarTheme,
      colorScheme: other.colorScheme ?? this.colorScheme,
      dialogTheme: other.dialogTheme ?? this.dialogTheme,
      floatingActionButtonTheme:
          other.floatingActionButtonTheme ?? this.floatingActionButtonTheme,
      typography: other.typography ?? this.typography,
      cupertinoOverrideTheme:
          other.cupertinoOverrideTheme ?? this.cupertinoOverrideTheme,
      snackBarTheme: other.snackBarTheme ?? this.snackBarTheme,
      bottomSheetTheme: other.bottomSheetTheme ?? this.bottomSheetTheme,
      popupMenuTheme: other.popupMenuTheme ?? this.popupMenuTheme,
      bannerTheme: other.bannerTheme ?? this.bannerTheme,
      dividerTheme: other.dividerTheme ?? this.dividerTheme,
      buttonBarTheme: other.buttonBarTheme ?? this.buttonBarTheme,
    );
  }

  Widget withTransparentAppBar({@required Widget child}) => Builder(
        builder: (context) {
          return Theme(
            data: copyWith(
              appBarTheme: AppBarTheme(
                color: Colors.transparent,
                iconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
                elevation: 0,
              ),
            ),
            child: child,
          );
        },
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

Color userColor(BuildContext context, int index) => themed(
      context,
      light: LightColors.userColors[index],
      dark: DarkColors.userColors[index],
    );

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
    Color(0xFFAF3A03),
  ];
}

class DarkColors {
  DarkColors._();

  static const userColors = [
    Color(0xFFE7DF35),
    Color(0xFFECB258),
    Color(0xFF25D1F2),
    Color(0xFFC780AC),
    Color(0xFF81BB98),
    Color(0xFFFB783C),
  ];
}
