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

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

class ChatMember {
  final User user;

  final String name;
  final bool isYou;
  final DisplayColor displayColor;

  ChatMember(
    this.user, {
    @required this.name,
    @required this.isYou,
  }) : displayColor =
            DisplayColor.values[user.id.hashCode % DisplayColor.values.length];

  static Future<ChatMember> fromUser(
    Room room,
    User user, {
    @required bool isYou,
  }) async {
    final currentName = (await room.members.getStateOf(user.id)).name;

    return ChatMember(
      user,
      name: currentName ?? user.id.toString().split(':')[0],
      isYou: isYou,
    );
  }

  @override
  bool operator ==(other) => user == other?.user;

  @override
  int get hashCode => user.hashCode;
}

enum DisplayColor {
  greenYellow,
  yellow,
  blue,
  purple,
  green,
  red,
}
