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
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/main/chat/settings/chat_settings_bloc.dart';
import 'package:pattle/src/ui/main/widgets/chat_name.dart';
import 'package:pattle/src/ui/main/widgets/user_item.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/resources/theme.dart';

import 'package:pattle/src/di.dart' as di;
import 'package:pattle/src/ui/util/future_or_builder.dart';
import 'package:pattle/src/ui/util/matrix_image.dart';
import 'package:pattle/src/ui/util/room.dart';

class ChatSettingsPageState extends State<ChatSettingsPage> {
  final me = di.getLocalUser();
  final ChatSettingsBloc bloc;
  final Room room;

  bool previewMembers;

  ChatSettingsPageState(this.room) : bloc = ChatSettingsBloc(room);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    previewMembers = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.red[50],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 128.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: ChatName(
                  room: room,
                  style: TextStyle(
                    shadows: [
                      Shadow(
                        offset: Offset(0.25, 0.25),
                        blurRadius: 1,
                      )
                    ],
                  ),
                ),
                background: Image(
                  image: MatrixImage(avatarUrlOf(room)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                _buildDescription(),
                SizedBox(height: 16),
                _buildMembers(),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    if (room.isDirect) {
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
                    l(context).description,
                    style: TextStyle(
                      color: LightColors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    room.topic ?? l(context).noDescriptionSet,
                    style: TextStyle(
                      fontStyle: room.topic == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembers() {
    if (room.isDirect) {
      return Container(height: 0);
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    l(context).xParticipants(bloc.room.members.count),
                    style: TextStyle(
                      color: LightColors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                FutureOrBuilder<Iterable<User>>(
                  futureOr: bloc.getMembers(all: !previewMembers),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<Iterable<User>> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return Container(height: 0);
                    }

                    final members = snapshot.data.toList(growable: false);

                    final isWaiting =
                        snapshot.connectionState == ConnectionState.waiting;
                    final allShown = members.length == bloc.room.members.count;

                    return MediaQuery.removePadding(
                      context: context,
                      removeLeft: true,
                      removeRight: true,
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: (previewMembers && !allShown) || isWaiting
                            ? members.length + 1
                            : members.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Item after all members
                          if (index == members.length) {
                            return _buildShowMoreItem(
                              context,
                              members.length,
                              isWaiting,
                            );
                          }

                          return UserItem(
                            user: members[index],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShowMoreItem(BuildContext context, int count, bool isWaiting) {
    return ListTile(
      leading: Icon(Icons.keyboard_arrow_down, size: 32),
      title: Text(l(context).xMore(bloc.room.members.count - count)),
      subtitle: isWaiting ? LinearProgressIndicator() : null,
      onTap: () => setState(() {
        previewMembers = false;
      }),
    );
  }
}

class ChatSettingsPage extends StatefulWidget {
  final Room room;

  ChatSettingsPage(this.room);

  @override
  State<StatefulWidget> createState() => ChatSettingsPageState(room);
}
