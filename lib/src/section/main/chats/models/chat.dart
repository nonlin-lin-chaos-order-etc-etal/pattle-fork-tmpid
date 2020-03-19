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

import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:meta/meta.dart';
import 'package:pattle/src/section/main/models/chat_member.dart';
import 'package:pattle/src/section/main/models/chat_message.dart';

/// Chat overview used in the 'chats' page.
class Chat {
  final Room room;

  // TODO: When members are able to being accessed syncly, use member names
  //       for groups
  final String name;

  final Uri avatarUrl;

  final ChatMessage latestMessage;
  final ChatMessage latestMessageForSorting;

  final bool isJustYou;

  final ChatMember directMember;

  Chat({
    @required this.room,
    this.latestMessage,
    this.latestMessageForSorting,
    this.isJustYou = false,
    this.directMember,
  })  : name = room.name ??
            (room.isDirect ? directMember.name : room.id.toString()),
        avatarUrl = room.avatarUrl ??
            (room.isDirect ? directMember.user.avatarUrl : room.avatarUrl);
}
