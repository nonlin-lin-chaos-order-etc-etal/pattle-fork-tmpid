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
import 'package:pattle/src/app.dart';
import 'package:pattle/src/resources/localizations.dart';

import '../../../matrix.dart';
import 'bloc.dart';
import 'widgets/chat_overview_list.dart';

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
  int _currentTab = 0;

  void _switchTabTo(int index) {
    // Temporary: Don't do anything for the calls tab
    if (index > 1) {
      return;
    }

    final bloc = context.bloc<ChatsBloc>();
    if (_currentTab == 0) {
      bloc.add(LoadPublicChats());
    } else {
      bloc.add(LoadPersonalChats());
    }

    setState(() {
      _currentTab = index;
    });
  }

  void _goToCreateGroup() {
    Navigator.of(context).pushNamed(Routes.chatsNew);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.bloc<ChatsBloc>().add(LoadPersonalChats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l(context).appName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          //ErrorBanner(),
          Expanded(
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 200),
              firstChild: _ChatsTab(),
              secondChild: _ChatsTab(),
              crossFadeState: _currentTab == 0
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              alignment: Alignment.center,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateGroup,
        child: Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            title: Text(l(context).personal),
          ),
          BottomNavigationBarItem(
            icon: Icon(Mdi.bullhorn),
            title: Text(l(context).public),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            title: Text(l(context).calls),
          )
        ],
        currentIndex: _currentTab,
        onTap: _switchTabTo,
      ),
    );
  }
}

class _ChatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(builder: (context, state) {
      if (state is ChatsLoaded) {
        return ChatOverviewList(chats: state.chats);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
