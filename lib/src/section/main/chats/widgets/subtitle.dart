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
import 'package:pattle/src/resources/theme.dart';
import 'package:pattle/src/section/main/chats/models/chat_overview.dart';

import '../../../../matrix.dart';
import '../../../../util/user.dart';

import 'image_subtitle.dart';
import 'member_subtitle.dart';
import 'redacted_subtitle.dart';
import 'text_subtitle.dart';
import 'topic_subtitle.dart';
import 'typing_subtitle.dart';
import 'unsupported_subtitle.dart';

abstract class Subtitle extends StatelessWidget {
  static const iconSize = 20.0;

  final Room room;
  final RoomEvent event;

  @protected
  final String senderName;

  final bool isMine;

  Subtitle(Matrix matrix, this.room, this.event)
      : isMine = event?.sender == matrix.user,
        senderName =
            event != null && event.sender != matrix.user && !room.isDirect
                ? '${event.sender.displayName}: '
                : '';

  static Widget forChat(ChatOverview chat) {
    return Builder(
      builder: (context) {
        final matrix = Matrix.of(context);

        // TODO: typingUsers should not contain nulls
        if (chat.room.isSomeoneElseTyping &&
            !chat.room.typingUsers.any((u) => u == null)) {
          return TypingSubtitle(matrix, chat.room);
        } else {
          final event = chat.latestEvent;
          if (event == null) {
            return UnsupportedSubtitle(matrix, chat.room, event);
          }

          if (event is TextMessageEvent) {
            return TextSubtitle(matrix, chat.room, event);
          } else if (event is ImageMessageEvent) {
            return ImageSubtitle(matrix, chat.room, event);
          } else if (event is MemberChangeEvent) {
            return MemberSubtitle(matrix, chat.room, event);
          } else if (event is RedactedEvent) {
            return RedactedSubtitle(matrix, chat.room, event);
          } else if (event is TopicChangeEvent) {
            return TopicSubtitle(matrix, chat.room, event);
          }

          return UnsupportedSubtitle(matrix, chat.room, event);
        }
      },
    );
  }

  TextStyle textStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .body1
      .copyWith(color: Theme.of(context).textTheme.caption.color);

  TextSpan senderSpan(BuildContext context, {String sender}) => TextSpan(
        text: sender ?? senderName,
        style: Theme.of(context).textTheme.body1.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.caption.color,
            ),
      );

  Widget buildSentStateIcon(BuildContext context) {
    if (isMine) {
      return Icon(
        event.sentState != SentState.sent ? Icons.access_time : Icons.check,
        size: Subtitle.iconSize,
        color: Colors.grey,
      );
    } else {
      return Container(height: 0, width: 0);
    }
  }

  Widget buildNotificationCount(BuildContext context) {
    if (room.totalUnreadNotificationCount <= 0) {
      return Container();
    }

    return SizedBox(
      height: 21,
      width: 21,
      child: ClipOval(
        child: Container(
          color: room.highlightedUnreadNotificationCount > 0
              ? LightColors.red
              : Colors.grey,
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Center(
              child: Text(
                room.totalUnreadNotificationCount.toString(),
                style: textStyle(context).copyWith(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
