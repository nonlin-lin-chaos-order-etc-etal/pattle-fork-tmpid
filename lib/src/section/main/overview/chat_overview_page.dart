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
import 'package:mdi/mdi.dart';
import 'package:pattle/src/app.dart';
import 'package:pattle/src/resources/localizations.dart';
import 'package:pattle/src/section/main/widgets/error.dart';

import 'chat_overview_bloc.dart';
import 'widgets/chat_overview_list.dart';

class ChatOverviewPageState extends State<ChatOverviewPage> {
  int _currentTab = 0;

  final personalTab = ChatOverviewList(chats: bloc.personalChats);
  final publicTab = ChatOverviewList(chats: bloc.publicChats);

  void _switchTabTo(int index) {
    // Temporary: Don't do anything for the calls tab
    if (index > 1) {
      return;
    }

    setState(() {
      _currentTab = index;
    });
  }

  void goToCreateGroup() {
    Navigator.of(context).pushNamed(Routes.chatsNew);
  }

  @override
  void initState() {
    super.initState();

    bloc.loadAndListen();
  }

  @override
  void dispose() {
    super.dispose();
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
          ErrorBanner(),
          Expanded(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: personalTab,
              secondChild: publicTab,
              crossFadeState: _currentTab == 0
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              alignment: Alignment.center,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToCreateGroup,
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

class ChatOverviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatOverviewPageState();
}
