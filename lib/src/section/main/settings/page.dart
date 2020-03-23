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
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/intl/localizations.dart';
import '../../../resources/theme.dart';

import '../widgets/chat_member_avatar.dart';
import '../../../app.dart';
import '../../../matrix.dart';

import 'bloc.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage._({Key key});

  static Widget withBloc() {
    return BlocProvider<SettingsBloc>(
      create: (c) => SettingsBloc(Matrix.of(c)),
      child: SettingsPage._(),
    );
  }

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SettingsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.intl.settings.title),
      ),
      body: ListView(
        children: <Widget>[
          Material(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.settingsProfile,
                  arguments: bloc,
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    final me = state.me;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Hero(
                          tag: me.user.id,
                          child: ChatMemberAvatar(
                            member: me,
                            radius: 36,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                me.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(me.user.id.toString())
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.vpn_key, color: LightColors.red),
            title: Text(context.intl.settings.accountTileTitle),
            subtitle: Text(context.intl.settings.accountTileSubtitle),
          ),
          ListTile(
            leading: Icon(Icons.landscape, color: LightColors.red),
            title: Text(context.intl.settings.appearanceTileTitle),
            subtitle: Text(context.intl.settings.appearanceTileSubtitle),
            onTap: () => Navigator.of(context).pushNamed(
              Routes.settingsAppearance,
              arguments: bloc,
            ),
          )
        ],
      ),
    );
  }
}
