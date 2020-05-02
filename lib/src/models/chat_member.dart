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

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

@immutable
class ChatMember extends Equatable {
  final UserId userId;

  final String name;
  final Uri avatarUrl;

  final bool isYou;
  final DisplayColor displayColor;

  ChatMember(
    this.userId, {
    @required this.name,
    this.avatarUrl,
    @required this.isYou,
  }) : displayColor =
            DisplayColor.values[userId.hashCode % DisplayColor.values.length];

  factory ChatMember.fromRoomAndUserId(
    Room room,
    UserId userId, {
    @required bool isMe,
  }) {
    final currentMember = room.members.get(userId);

    return ChatMember(
      userId,
      name: currentMember?.name ?? userId.toString().split(':')[0],
      avatarUrl: currentMember?.avatarUrl,
      isYou: isMe,
    );
  }

  @override
  List<Object> get props => [userId, name, isYou, displayColor];
}

enum DisplayColor {
  greenYellow,
  yellow,
  blue,
  purple,
  green,
  red,
}
