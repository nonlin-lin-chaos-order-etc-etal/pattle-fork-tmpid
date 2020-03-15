// Copyright (C) 2020  wilko
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
import 'package:pattle/src/section/main/models/chat_message.dart';

class MessageState extends StatelessWidget {
  final ChatMessage message;
  final Color color;
  final double size;

  const MessageState({
    Key key,
    this.message,
    this.color,
    this.size,
  }) : super(key: key);

  static bool necessary(ChatMessage message) => message.isMine;

  @override
  Widget build(BuildContext context) {
    return Icon(
      message.event.sentState != SentState.sent
          ? Icons.access_time
          : Icons.check,
      color: color,
      size: size,
    );
  }
}
