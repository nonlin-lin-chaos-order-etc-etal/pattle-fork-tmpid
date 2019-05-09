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
import 'package:pattle/src/ui/util/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pattle/src/di.dart' as di;
import 'package:flutter_html/flutter_html.dart';

import 'bubble.dart';
import 'message_bubble.dart';

class TextBubble extends MessageBubble {

  static const _replyMargin = 8.0;

  @override
  final TextMessageEvent event;

  final LocalUser me = di.getLocalUser();

  TextBubble({
    @required ChatEvent item,
    ChatItem previousItem,
    ChatItem nextItem,
    @required bool isMine,
    bool isRepliedTo = false
  }) :
    event = item.event,
    super(
      item: item,
      previousItem: previousItem,
      nextItem: nextItem,
      isMine: isMine,
      isRepliedTo: isRepliedTo
  );

  TextStyle _linkStyle(BuildContext context) {
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

  Widget _buildRepliedTo(BuildContext context) {
    final repliedId = event.content.inReplyToId;
    if (repliedId != null) {
      return FutureBuilder<Event>(
        future: event.room.events[repliedId],
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          final repliedTo = snapshot.data;
          if (repliedTo != null && repliedTo is TextMessageEvent) {
            return !isRepliedTo ? Padding(
              padding: EdgeInsets.only(
                top: !isMine ? 4 : 0,
                bottom: _replyMargin,
              ),
              // Only build the replied to message if this itself
              // is not a replied to message (to prevent very long
              // reply chains)
              child: Bubble.asReply(
                replyTo: repliedTo,
                isMine: repliedTo.sender.id == di.getLocalUser().id
              ),
            ) : Container();
          } else {
            return Container(height: 0, width: 0);
          }
        },
      );
    } else {
      return Container(height: 0, width: 0);
    }
  }

  Widget buildContent(BuildContext context) {
    return Html(
      data: event.content.formattedBody ?? '',
      useRichText: true,
      defaultTextStyle: textStyle(context),
      fillWidth: false,
      linkStyle: _linkStyle(context),
      onLinkTap: (url) async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
    );
  }


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
            _buildRepliedTo(context),
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
            _buildRepliedTo(context),
            SizedBox(height: 4),
            buildContent(context),
            SizedBox(height: 4),
            buildTime(context)
          ],
        ),
      )
    );

}