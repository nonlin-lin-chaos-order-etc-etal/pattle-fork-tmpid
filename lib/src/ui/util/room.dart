// Copyright (C) 2019  wilko
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

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/util/user.dart';
import 'package:pattle/src/di.dart' as di;

Uri avatarUrlOf(Room room)
  => room.isDirect? room.directUser.avatarUrl : room.avatarUrl;

Future<String> nameOf(BuildContext context, Room room) async {
  if (room.name != null) {
    return room.name;
  }

  if (room.isDirect) {
    return displayNameOf(room.directUser);
  }

  final members = await room.members.upTo(6).toList();
  var name = '';
  if (members != null) {
    if (members.length == 1) {
      name = l(context).you;
      // TODO: Check for aliases (public chats)
    } else {
      var i = 0;
      for (User member in members) {
        if (i > 4) {
          name += ' ${l(context).andOthers}';
          break;
        }

        if (i != 0) {
          name += ', ';
        }

        if (member != di.getLocalUser()) {
          name += displayNameOf(member);
          i++;
        }
      }
    }
  } else {
    return room.id.toString();
  }

  return name;
}