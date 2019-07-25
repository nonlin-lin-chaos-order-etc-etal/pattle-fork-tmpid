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
import 'package:pattle/src/ui/main/widgets/user_item.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/matrix_image.dart';
import 'package:pattle/src/ui/util/user.dart';

import 'package:pattle/src/ui/main/overview/create/group/create_group_bloc.dart';

class CreateGroupMembersPageState extends State<CreateGroupMembersPage> {

  @override
  void initState() {
    super.initState();

    bloc.loadMembers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goToNext() {
    Navigator.of(context).pushNamed(Routes.chatsNewDetails);
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
            onPressed: goToNext,
            child: Text(l(context).next),
          )
        ),
      ),
      body: Column(
        children: <Widget>[
          ErrorBanner(),
          Expanded(
            child: _buildUserList(context)
          )
        ],
      ),
      android: (_) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          onPressed: goToNext,
          child: Icon(Icons.arrow_forward),
        ),
      )
    );
  }

  Widget _buildUserList(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: bloc.users,
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        final users = snapshot.data;
        if (users != null) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) =>
                UserItem(
                  user: users[index],
                  checkable: true,
                  onSelected: () => bloc.usersToAdd.add(users[index]),
                  onUnselected: () => bloc.usersToAdd.remove(users[index]),
                ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class CreateGroupMembersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateGroupMembersPageState();
}