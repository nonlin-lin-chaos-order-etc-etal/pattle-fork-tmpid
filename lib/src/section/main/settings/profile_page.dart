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

import 'bloc.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage._();

  static Widget withGivenBloc(SettingsBloc settingsBloc) {
    return BlocProvider<SettingsBloc>.value(
      value: settingsBloc,
      child: ProfilePage._(),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.intl.settings.profileTitle),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final me = state.me;

          return Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Hero(
                        tag: me.userId,
                        child: ChatMemberAvatar(
                          member: me,
                          radius: 96,
                        ),
                      ),
                      Positioned(
                        right: -1,
                        bottom: -1,
                        child: FloatingActionButton(
                          child: Icon(Icons.photo_camera),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: context.pattleTheme.primaryColorOnBackground,
                        ),
                        title: Text(context.intl.common.name),
                        subtitle: Text(me.name),
                        trailing: Icon(Icons.edit),
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.settingsProfileName,
                          arguments: BlocProvider.of<SettingsBloc>(context),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.alternate_email,
                          color: context.pattleTheme.primaryColorOnBackground,
                        ),
                        title: Text(context.intl.common.username),
                        subtitle: Text(me.userId.toString()),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
