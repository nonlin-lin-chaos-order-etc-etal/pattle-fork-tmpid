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
import 'package:pattle/src/ui/main/models/chat_item.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bubble.dart';
import 'message_bubble.dart';

class TextBubble extends MessageBubble {

  @override
  final TextMessageEvent event;

  TextBubble({
    @required ChatEvent item,
    @required ChatItem previousItem,
    @required ChatItem nextItem,
    @required bool isMine
  }) :
    event = item.event,
    super(
      item: item,
      previousItem: previousItem,
      nextItem: nextItem,
      isMine: isMine
  );

  TextStyle linkStyle(BuildContext context) {
    if (isMine) {
      return textStyle(context).copyWith(
        decoration: TextDecoration.underline
      );
    } else {
      return textStyle(context).copyWith(
        color: Theme.of(context).primaryColor,
        decoration: TextDecoration.underline
      );
    }
  }

  Widget buildContent(BuildContext context) =>
    Html(
      data: event.content.formattedBody ?? '',
      useRichText: true,
      defaultTextStyle: textStyle(context),
      fillWidth: false,
      linkStyle: linkStyle(context),
      onLinkTap: (url) async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
    );

  @protected
  Widget buildMine(BuildContext context) {

    Widget bottom = Container(height: 0, width: 0);
    if (isEndOfGroup) {
      bottom = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          buildSentState(context),
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