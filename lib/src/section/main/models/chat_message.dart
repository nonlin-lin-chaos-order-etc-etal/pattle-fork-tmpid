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

import 'package:meta/meta.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/section/main/models/chat_member.dart';

class ChatMessage {
  final Room room;
  final RoomEvent event;
  final ChatMember sender;

  final ChatMessage inReplyTo;
  bool get isMine => sender.isYou;

  /// Message that redacted this message, if any.
  final ChatMessage redaction;

  /// Subject of a member change state change, if any.
  final ChatMember subject;

  ChatMessage(
    this.room,
    this.event, {
    @required this.sender,
    this.inReplyTo,
    this.redaction,
    this.subject,
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

  static Future<ChatMessage> create(
    Room room,
    RoomEvent event, {
    ChatMessage inReplyTo,
    @required bool Function(User) isMe,
  }) async {
    ChatMessage redactionMessage;
    ChatMember subject;

    if (event is RedactedEvent) {
      redactionMessage = ChatMessage(
        room,
        event.redaction,
        sender: await ChatMember.fromUser(
          room,
          event.redaction.sender,
          isYou: isMe(event.redaction.sender),
        ),
      );
    } else if (event is MemberChangeEvent) {
      subject = await ChatMember.fromUser(
        room,
        event.subject,
        isYou: isMe(event.subject),
      );
    }

    return ChatMessage(
      room,
      event,
      sender: await ChatMember.fromUser(
        room,
        event.sender,
        isYou: isMe(event.sender),
      ),
      inReplyTo: inReplyTo,
      redaction: redactionMessage,
      subject: subject,
    );
  }

  @override
  int get hashCode =>
      room.hashCode + event.hashCode + inReplyTo.hashCode + isMine.hashCode;
}
