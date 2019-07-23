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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/main/chat/chat_bloc.dart';
import 'package:pattle/src/ui/main/chat/settings/chat_settings_bloc.dart';
import 'package:pattle/src/ui/main/widgets/chat_name.dart';
import 'package:pattle/src/ui/resources/theme.dart';

import 'package:pattle/src/di.dart' as di;
import 'package:pattle/src/ui/util/matrix_image.dart';
import 'package:pattle/src/ui/util/room.dart';


class ChatSettingsPageState extends State<ChatSettingsPage> {

  final me = di.getLocalUser();
  final ChatSettingsBloc bloc;
  final Room room;

  ChatSettingsPageState(this.room) : bloc = ChatSettingsBloc(room);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: LightColors.red[50],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 128.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: ChatName(room: room, style: TextStyle(
                  shadows: [Shadow(
                    offset: Offset(0.25, 0.25),
                    blurRadius: 1,
                  )],
                ),),
                background: Image(
                  image: MatrixImage(avatarUrlOf(room)),
                  fit: BoxFit.cover,
                )),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            _buildDescription(),
          ],
        )
      ),
    );
  }

  Widget _buildDescription() {
    if (room.topic == null) {
      return Container(height: 0);
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Description',
                    style: TextStyle(
                      color: LightColors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(room.topic),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class ChatSettingsPage extends StatefulWidget {

  final Room room;

  ChatSettingsPage(this.room);

  @override
  State<StatefulWidget> createState() => ChatSettingsPageState(room);
}