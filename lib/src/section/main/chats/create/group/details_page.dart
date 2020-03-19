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
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/app.dart';
import 'package:pattle/src/resources/localizations.dart';
import 'package:pattle/src/section/main/widgets/error.dart';
import 'package:pattle/src/section/main/widgets/chat_member_avatar.dart';

import 'bloc.dart';

class CreateGroupDetailsPage extends StatefulWidget {
  CreateGroupDetailsPage._();

  @override
  State<StatefulWidget> createState() => _CreateGroupDetailsPageState();

  static Widget withGivenBloc(CreateGroupBloc bloc) {
    return BlocProvider<CreateGroupBloc>.value(
      value: bloc,
      child: CreateGroupDetailsPage._(),
    );
  }
}

class _CreateGroupDetailsPageState extends State<CreateGroupDetailsPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<CreateGroupBloc>(context).add(LoadUsers());
  }

  Future<void> _createGroup() async {
    final bloc = BlocProvider.of<CreateGroupBloc>(context);

    bloc.add(CreateGroup());
  }

  void _onGroupCreated(Room room) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.chats,
      (route) =>
          route.settings.name == Routes.chats &&
          route.settings.arguments == null,
      arguments: room,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateGroupBloc, CreateGroupState>(
      listener: (context, state) {
        if (state is CreatedGroup) {
          _onGroupCreated(state.room);
        }
      },
      child: Scaffold(
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
                        BlocProvider.of<CreateGroupBloc>(context).add(
                          UpdateGroupName(text),
                        );
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
        floatingActionButton: BlocBuilder<CreateGroupBloc, CreateGroupState>(
          builder: (context, state) {
            Widget child;

            if (state is CreatingGroup) {
              child = SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else {
              child = Icon(Icons.check);
            }

            return FloatingActionButton(
              onPressed: _createGroup,
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return BlocBuilder<CreateGroupBloc, CreateGroupState>(
      condition: (prevState, nextState) =>
          prevState?.members?.length != nextState?.members?.length,
      builder: (context, state) {
        final children = List<Widget>();

        for (final member in state?.members) {
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
                      child: ChatMemberAvatar(member: member, radius: 32),
                    ),
                  ),
                ),
                Text(
                  member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return GridView.count(crossAxisCount: 4, children: children);
      },
    );
  }
}
