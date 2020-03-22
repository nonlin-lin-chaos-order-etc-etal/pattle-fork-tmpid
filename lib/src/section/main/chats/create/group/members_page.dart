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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pattle/src/app.dart';
import 'package:pattle/src/resources/intl/localizations.dart';
import 'package:pattle/src/section/main/widgets/chat_member_tile.dart';

import '../../../../../matrix.dart';
import 'bloc.dart';

class CreateGroupMembersPage extends StatefulWidget {
  const CreateGroupMembersPage._({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateGroupMembersPageState();

  static Widget withBloc() {
    return BlocProvider(
      create: (c) => CreateGroupBloc(Matrix.of(c)),
      child: CreateGroupMembersPage._(),
    );
  }
}

class _CreateGroupMembersPageState extends State<CreateGroupMembersPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<CreateGroupBloc>(context).add(LoadUsers());
  }

  void _goToNext() {
    Navigator.of(context).pushNamed(
      Routes.chatsNewDetails,
      arguments: BlocProvider.of<CreateGroupBloc>(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.intl.chats.newGroup.title),
      ),
      body: Column(
        children: <Widget>[
          //ErrorBanner(),
          Expanded(child: _buildUserList(context))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToNext,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return BlocBuilder<CreateGroupBloc, CreateGroupState>(
      condition: (prevState, nextState) => nextState is UserListUpdated,
      builder: (context, state) {
        if (state is UserListUpdated) {
          final users = state.users;
          final bloc = BlocProvider.of<CreateGroupBloc>(context);

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) => ChatMemberTile(
              member: users[index],
              checkable: true,
              onSelected: () => bloc.add(AddMember(users[index])),
              onUnselected: () => bloc.add(RemoveMember(users[index])),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
