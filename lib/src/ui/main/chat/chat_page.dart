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
import 'package:pattle/src/ui/main/chat/chat_bloc.dart';
import 'package:pattle/src/ui/main/chat/widgets/text_message.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/matrix_image.dart';

import 'package:pattle/src/di.dart' as di;

class ChatPageState extends State<ChatPage> {

  final me = di.getLocalUser();
  final ChatBloc bloc = ChatBloc();
  final Room room;

  ChatPageState(this.room) {
    bloc.room = room;
  }

  @override
  void initState() {
    super.initState();
    bloc.startLoadingEvents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget avatar = Container();
    if (room.avatarUrl != null) {
      avatar = Hero(
        tag: room.id,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: MatrixImage(room.avatarUrl),
        )
      );
    }

    return Scaffold(
      backgroundColor: LightColors.red[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            avatar,
            SizedBox(
              width: 16,
            ),
            Text(room.name),
          ],
        ),
      ),
      body: _buildEventsList()
    );
  }

  Widget _buildEventsList() {
    return StreamBuilder<List<MessageEvent>>(
      stream: bloc.events,
      builder: (BuildContext context, AsyncSnapshot<List<MessageEvent>> snapshot) {
        print(snapshot.connectionState);
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.active:
          case ConnectionState.done:
            var chatEvents = snapshot.data;
            return ListView.builder(
              itemCount: chatEvents.length,
              itemBuilder: (context, index) {
                final event = chatEvents[index];
                final isMine = event.sender == me;

                print('${event.sender.name ?? event.sender.id} == me');

                var previousEvent, nextEvent;
                if (index != 0) {
                  previousEvent = chatEvents[index - 1];
                }

                if (index != chatEvents.length - 1) {
                  nextEvent = chatEvents[index + 1];
                }

                return _buildEventItem(
                  event,
                  previousEvent,
                  nextEvent,
                  isMine
                );
              }
            );
        }
      }
    );
  }

  Widget _buildEventItem(
      Event event, Event previousEvent, Event nextEvent, bool isMine) {

    if (event is TextMessageEvent) {
      return TextMessage(
        message: event,
        previousEvent: previousEvent,
        nextEvent: nextEvent,
        isMine: isMine,
      );
    } else {
      return Container();
    }
  }
}

class ChatPage extends StatefulWidget {

  final Room room;

  ChatPage(this.room);

  @override
  State<StatefulWidget> createState() => ChatPageState(room);
}