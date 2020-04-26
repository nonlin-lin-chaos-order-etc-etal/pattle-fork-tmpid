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

import 'profile/tile.dart';

import '../../../resources/intl/localizations.dart';
import '../../../resources/theme.dart';

import '../../../app.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.intl.settings.title),
      ),
      body: ListView(
        children: <Widget>[
          ProfileSettingTile.withBloc(),
          Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.landscape,
              color: context.pattleTheme.data.listTileIconColor,
            ),
            title: Text(context.intl.settings.appearanceTileTitle),
            subtitle: Text(context.intl.settings.appearanceTileSubtitle),
            onTap: () => Navigator.of(context).pushNamed(
              Routes.settingsAppearance,
            ),
          )
        ],
      ),
    );
  }
}
