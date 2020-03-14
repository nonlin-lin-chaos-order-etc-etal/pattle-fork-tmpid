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
import '../../../../../../../util/user.dart';

import '../../message.dart';

/// Content for a [MessageBubble] with a [TextMessageEvent].
///
/// Must have a [MessageBubble] ancestor.
class TextContent extends StatelessWidget {
  static const _replyMargin = 8.0;
  static const _replyLeftPadding = 12.0;
  @override
  Widget build(BuildContext context) {
    final info = MessageBubble.of(context);

    final needsBorder = info.isReply && info.message.inReplyTo?.isMine == true;

    return Clickable(
      child: CustomPaint(
        painter: needsBorder
            ? _ReplyBorderPainter(
                color: info.message.isMine
                    ? Colors.white
                    : info.message.event.sender.getColor(context),
                borderRadius: info.borderRadius,
              )
            : null,
        child: Padding(
          padding: EdgeInsets.all(8).copyWith(
            left: needsBorder ? _replyLeftPadding : null,
          ),
          child: Column(
            crossAxisAlignment: info.message.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              Sender(
                padding: EdgeInsets.only(bottom: 4),
              ),
              // Only build the replied-to message if this itself
              // is not a replied-to message (to prevent very long
              // reply chains)
              if (info.message.inReplyTo != null && info.isReply)
                Padding(
                    padding: EdgeInsets.only(
                      top: !info.message.isMine ? 4 : 0,
                      bottom: _replyMargin,
                    ),
                    child: Container() // TODO: REPLY
                    ),
              _Content(),
              SizedBox(height: 4),
              MessageInfo(),
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
    final info = MessageBubble.of(context);
    assert(info.message.event is TextMessageEvent);
    final event = info.message.event as TextMessageEvent;

    final html = Html(
      data: event.content.formattedBody ?? '',
      useRichText: true,
      fillWidth: false,
      linkStyle: TextStyle(
        decoration: TextDecoration.underline,
        color: !info.message.isMine
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
          Sender(),
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
