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

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../../../util/color.dart';
import '../../../../../../../util/chat_member.dart';

import '../../message.dart';

/// Content for a [MessageBubble] with a [TextMessageEvent].
///
/// Must have a [MessageBubble] ancestor.
class TextContent extends StatelessWidget {
  static const _replyLeftPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    final bubble = MessageBubble.of(context);

    final needsBorder =
        !bubble.message.room.isDirect && bubble.reply?.isMine == false ||
            bubble.message.isMine && bubble.reply?.isMine == true;

    return Clickable(
      child: CustomPaint(
        painter: needsBorder
            ? _ReplyBorderPainter(
                color: bubble.message.isMine && bubble.reply?.isMine == true
                    ? Colors.white
                    : bubble.message.sender.color(context),
                borderRadius: bubble.borderRadius,
              )
            : null,
        child: Padding(
          padding: EdgeInsets.all(8).copyWith(
            left: needsBorder ? _replyLeftPadding : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (Sender.necessary(context))
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Sender(),
                ),
              // Only build the replied-to message if this itself
              // is not a replied-to message (to prevent very long
              // reply chains)
              if (bubble.message.inReplyTo != null) ...[
                SizedBox(height: 4),
                MessageBubble.withContent(
                  message: bubble.message.inReplyTo,
                  reply: bubble.message,
                ),
                SizedBox(height: 8)
              ],
              Wrap(
                runAlignment: bubble.message.isMine
                    ? WrapAlignment.end
                    : WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 4,
                runSpacing: 4,
                children: <Widget>[
                  _Content(),
                  if (MessageInfo.necessary(context))
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: MessageInfo(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bubble = MessageBubble.of(context);
    assert(bubble.message.event is TextMessageEvent);
    final event = bubble.message.event as TextMessageEvent;

    final html = Html(
      data: event.content.formattedBody ?? '',
      useRichText: true,
      fillWidth: false,
      linkStyle: TextStyle(
        decoration: TextDecoration.underline,
        color: !bubble.message.isMine
            ? themed(
                context,
                light: Theme.of(context).primaryColor,
                dark: Colors.white,
              )
            : null,
      ),
      renderNewlines: true,
      onLinkTap: (url) async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
    );

    if (event is! EmoteMessageEvent) {
      return html;
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (Sender.necessary(context)) Sender(),
          Flexible(
            child: html,
          )
        ],
      );
    }
  }
}

class _ReplyBorderPainter extends CustomPainter {
  static const width = 4.0;

  final Color color;

  /// Only the top left and bottom left values are used, because the line
  /// is drawn left.
  final BorderRadius borderRadius;

  _ReplyBorderPainter({@required this.color, @required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(Offset(0, 0), Offset(width, size.height)),
        topLeft: borderRadius.topLeft,
        bottomLeft: borderRadius.bottomLeft,
      ),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_ReplyBorderPainter oldDelegate) =>
      color != oldDelegate.color;
}
