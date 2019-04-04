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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/model/chat_overview.dart';
import 'package:pattle/src/ui/chat/chat_overview_bloc.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/util/date_format.dart';

class ChatOverviewPageState extends State<ChatOverviewPage> {

  @override
  void initState() {
    super.initState();

    bloc.startSync();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l(context).appName)
      ),
      body: Container(
        child: Scrollbar(
          child: buildOverviewList()
        ),
      )
    );
  }

  Widget buildOverviewList() {
    return StreamBuilder<List<ChatOverview>>(
      stream: bloc.chats,
      builder: (BuildContext context, AsyncSnapshot<List<ChatOverview>> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.active:
          case ConnectionState.done:
            var chats = snapshot.data;
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 1),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                var chat = chats[index];
                return buildChatOverview(chat);
              }
            );
        }
      }
    );
  }

  Widget buildChatOverview(ChatOverview chat) {

    final event = chat.latestEvent;
    var subtitle;
    // Handle events
    if (event is TextMessageEvent) {
      subtitle = event.body ?? 'null';
    } else {
      subtitle = event?.sender.toString() ?? 'null';
    }

    var time = formatAsListItem(context, chat.latestEvent?.time);

    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Expanded(
            child: Text(chat.name),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.subtitle
                    .copyWith(fontWeight: FontWeight.normal)
          )
        ]
      ),
      dense: false,
      onTap: () { },
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      subtitle: Text(subtitle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ChatOverviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatOverviewPageState();
}