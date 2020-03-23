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
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/intl/localizations.dart';
import '../../../resources/theme.dart';

import 'bloc.dart';
import 'widgets/header.dart';

class AppearancePage extends StatefulWidget {
  AppearancePage._();

  static Widget withGivenBloc(SettingsBloc settingsBloc) {
    return BlocProvider<SettingsBloc>.value(
      value: settingsBloc,
      child: AppearancePage._(),
    );
  }

  @override
  State<StatefulWidget> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  Brightness _brightness;

  @override
  Widget build(BuildContext context) {
    _brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.intl.settings.appearanceTileTitle),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              _brightness == Brightness.light
                  ? Icons.brightness_high
                  : Icons.brightness_3,
              color: redOnBackground(context),
            ),
            title: Header(context.intl.settings.brightnessTileTitle),
          ),
          RadioListTile(
            groupValue: _brightness,
            value: Brightness.light,
            onChanged: (brightness) {
              DynamicTheme.of(context).setBrightness(brightness);
            },
            title: Text(context.intl.settings.brightnessTileOptionLight),
          ),
          RadioListTile(
            groupValue: _brightness,
            value: Brightness.dark,
            onChanged: (brightness) {
              DynamicTheme.of(context).setBrightness(brightness);
            },
            title: Text(context.intl.settings.brightnessTileOptionLight),
          ),
          Divider(height: 1)
        ],
      ),
    );
  }
}
