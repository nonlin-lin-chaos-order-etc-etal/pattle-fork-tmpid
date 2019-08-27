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
import 'package:pattle/src/ui/main/settings/settings_bloc.dart';
import 'package:pattle/src/ui/main/widgets/user_avatar.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/user.dart';

import '../../../app.dart';

class ProfilePageState extends State<ProfilePage> {
  final bloc = SettingsBloc();

  Brightness brightness;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Hero(
                    tag: bloc.me.id,
                    child: UserAvatar(
                      user: bloc.me,
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
                      color: redOnBackground(context),
                    ),
                    title: Text('Name'),
                    subtitle: Text(displayNameOf(bloc.me)),
                    trailing: Icon(Icons.edit),
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.settingsProfileName,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.alternate_email,
                      color: redOnBackground(context),
                    ),
                    title: Text('Username'),
                    subtitle: Text(bloc.me.id.toString()),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}
