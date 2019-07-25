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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/app.dart';
import 'package:pattle/src/ui/main/widgets/error.dart';
import 'package:pattle/src/ui/main/widgets/user_avatar.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/util/matrix_image.dart';
import 'package:pattle/src/ui/util/user.dart';

import 'package:pattle/src/ui/main/overview/create/group/create_group_bloc.dart';

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
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.chats,
      (route) => route.settings.name == Routes.chats
              && route.settings.arguments == null,
      arguments: bloc.createdRoom
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(l(context).newGroup),
        ios: (_) => CupertinoNavigationBarData(
          backgroundColor: CupertinoTheme.of(context).primaryColor,
          actionsForegroundColor: Colors.white,
          title: Text(
            l(context).appName,
            style: TextStyle(
                color: Colors.white
            ),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: createGroup,
            child: Text(l(context).confirm),
          )
        ),
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
                  child: PlatformTextField(
                    onChanged: (text) {
                      bloc.groupName = text;
                    },
                    maxLines: 1,
                    android: (_) => MaterialTextFieldData(
                      decoration: InputDecoration(
                        labelText: l(context).groupName,
                        filled: true
                      ),
                    ),
                    ios: (_) => CupertinoTextFieldData(
                      placeholder: l(context).groupName
                    ),
                  ),
                )
              )
            ],
          ),
          Text(l(context).participants),
          Expanded(
            child: _buildUserList(context)
          )
        ],
      ),
      android: (_) => MaterialScaffoldData(
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
                  child: PlatformCircularProgressIndicator(
                    android: (_) => MaterialProgressIndicatorData(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                );
              } else {
                return Icon(Icons.check);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    final children = List<Widget>();

    for (final user in bloc.usersToAdd) {
      children.add(Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 1/1,
                child: UserAvatar(
                  user: user,
                  radius: 32
                ),
              )
            ),
          ),
          Text(
            displayNameOf(user, context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ));
    }

    return GridView.count(
      crossAxisCount: 4,
      children: children
    );
  }
}

class CreateGroupDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateGroupDetailsPageState();
}