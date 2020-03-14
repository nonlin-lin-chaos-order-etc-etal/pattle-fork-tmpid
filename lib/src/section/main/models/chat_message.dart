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

import 'package:flutter/cupertino.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

class ChatMessage {
  final Room room;
  final RoomEvent event;

  final ChatMessage inReplyTo;
  final bool isMine;

  ChatMessage(
    this.room,
    this.event, {
    this.inReplyTo,
    @required this.isMine,
  });

  @override
  bool operator ==(other) {
    if (other is ChatMessage) {
      return room == other.room &&
          event == other.event &&
          inReplyTo == other.inReplyTo &&
          isMine == other.isMine;
    } else {
      return false;
    }
  }

  @override
  int get hashCode =>
      room.hashCode + event.hashCode + inReplyTo.hashCode + isMine.hashCode;
}
