// Copyright (C) 2019  wilko
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

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/date_format.dart';
import 'package:pattle/src/ui/util/display_name.dart';

import 'bubble.dart';
import 'message_bubble.dart';


class TextBubble extends MessageBubble {

  @override
  final TextMessageEvent event;

  TextBubble({
    @required this.event,
    @required RoomEvent previousEvent,
    @required RoomEvent nextEvent,
    @required bool isMine
  }) : super(
    event: event,
    previousEvent: previousEvent,
    nextEvent: nextEvent,
    isMine: isMine
  );

  Widget buildContent(BuildContext context) =>
    Text(event.content.body ?? '',
      style: textStyle(context)
    );

  @protected
  Widget buildMine(BuildContext context) {

    Widget bottom = Container(height: 0, width: 0);
    if (isEndOfGroup) {
      final icon = event.sentState == SentState.waiting
          ? Icons.access_time
          : Icons.check;

      bottom = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Icon(icon,
            color: Colors.white,
            size: 14
          ),
          SizedBox(width: 4),
          buildTime(context),
        ],
      );
    }

    return InkWell(
      onTap: () { },
      customBorder: border(),
      child: Padding(
        padding: Bubble.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            buildContent(context),
            SizedBox(height: 4),
            bottom
          ],
        ),
      )
    );
  }



  @protected
  Widget buildTheirs(BuildContext context) =>
    InkWell(
      onTap: () { },
      customBorder: border(),
      child: Padding(
        padding: Bubble.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildSender(context),
            SizedBox(height: 4),
            buildContent(context),
            SizedBox(height: 4),
            buildTime(context)
          ],
        ),
      )
    );

}