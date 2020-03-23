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
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import '../../../app.dart';
import '../../../resources/intl/localizations.dart';

import '../../../matrix.dart';
import 'bloc.dart';
import 'widgets/chat_list.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage._();

  static Widget withBloc() {
    return BlocProvider<ChatsBloc>(
      create: (context) => ChatsBloc(Matrix.of(context)),
      child: ChatsPage._(),
    );
  }

  @override
  State<StatefulWidget> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  void _goToCreateGroup() {
    Navigator.of(context).pushNamed(Routes.chatsNew);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.bloc<ChatsBloc>().add(LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.intl.appName),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, Routes.settings),
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.group),
                    SizedBox(width: 8),
                    Text(context.intl.chats.personal.toUpperCase()),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Mdi.bullhorn),
                    SizedBox(width: 8),
                    Text(context.intl.chats.public.toUpperCase()),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _ChatsTab(personal: true),
            _ChatsTab(personal: false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _goToCreateGroup,
          child: Icon(Icons.chat),
        ),
      ),
    );
  }
}

class _ChatsTab extends StatelessWidget {
  final bool personal;

  const _ChatsTab({Key key, this.personal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(builder: (context, state) {
      if (state is ChatsLoaded) {
        return ChatList(
          chats: personal ? state.personal : state.public,
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
