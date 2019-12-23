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
import 'package:pattle/src/app.dart';
import 'package:pattle/src/resources/localizations.dart';
import 'package:pattle/src/section/main/widgets/error.dart';
import 'package:pattle/src/section/main/widgets/user_avatar.dart';

import '../../../../../util/user.dart';
import 'create_group_bloc.dart';

class CreateGroupDetailsPageState extends State<CreateGroupDetailsPage> {
  @override
  void initState() {
    super.initState();

    bloc.loadMembers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> createGroup() async {
    // TODO: Navigate to newly created
    await bloc.createRoom();
    await Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.chats,
      (route) =>
          route.settings.name == Routes.chats &&
          route.settings.arguments == null,
      arguments: bloc.createdRoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l(context).newGroup),
      ),
      body: Column(
        children: <Widget>[
          ErrorBanner(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (text) {
                      bloc.groupName = text;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: l(context).groupName,
                      filled: true,
                    ),
                  ),
                ),
              )
            ],
          ),
          Text(l(context).participants),
          Expanded(child: _buildUserList(context))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        child: StreamBuilder<bool>(
          stream: bloc.isCreatingRoom,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            final isCreatingRoom = snapshot.data ?? false;
            if (isCreatingRoom) {
              return SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else {
              return Icon(Icons.check);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    final children = List<Widget>();

    for (final user in bloc.usersToAdd) {
      children.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: UserAvatar(user: user, radius: 32),
                ),
              ),
            ),
            Text(
              user.getDisplayName(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.count(crossAxisCount: 4, children: children);
  }
}

class CreateGroupDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateGroupDetailsPageState();
}
