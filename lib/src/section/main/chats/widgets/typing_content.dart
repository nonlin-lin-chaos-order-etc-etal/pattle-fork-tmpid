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
import 'package:pattle/src/resources/localizations.dart';
import 'package:pattle/src/resources/theme.dart';
import 'package:pattle/src/section/main/chats/models/chat.dart';

class TypingContent extends StatelessWidget {
  final Chat chat;

  const TypingContent({Key key, @required this.chat}) : super(key: key);

  List<TextSpan> _span(BuildContext context, Room room) {
    if (room.isDirect) {
      return l(context).typing;
    }

    if (room.typingUsers.length == 1) {
      return l(context).isTyping(
        TextSpan(
          text: room.typingUsers.first.name,
        ),
      );
    }

    if (room.typingUsers.length == 2) {
      return l(context).areTyping(
        TextSpan(
          text: room.typingUsers.first.name,
        ),
        TextSpan(
          text: room.typingUsers[1].name,
        ),
      );
    }

    return l(context).andMoreAreTyping(
      TextSpan(
        text: room.typingUsers.first.name,
      ),
      TextSpan(
        text: room.typingUsers[1].name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          color: redOnBackground(context),
          fontWeight: FontWeight.bold,
        ),
        children: _span(context, chat.room),
      ),
    );
  }
}
