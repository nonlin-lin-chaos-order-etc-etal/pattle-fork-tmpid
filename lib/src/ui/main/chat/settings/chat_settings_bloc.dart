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

import 'dart:async';

import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/main/models/chat_item.dart';
import 'package:pattle/src/ui/main/sync_bloc.dart';
import 'package:pattle/src/ui/util/room.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pattle/src/di.dart' as di;

class ChatSettingsBloc {


  final Room room;

  ChatSettingsBloc(this.room);

  FutureOr<List<User>> getMembers({bool all = false}) {

    FutureOr<List<User>> filter(Iterable<User> members) {
      final list = members.toList();

      final futureOrMe = room.members[di.getLocalUser().id];

      FutureOr<List<User>> reorder(User me) {
        list.remove(me);
        list.insert(0, me);
        return list;
      }

      if (futureOrMe is Future<User>) {
        return futureOrMe.then(reorder);
      } else {
        return reorder(futureOrMe);
      }
    }

    final futureOrMembers = room.members.get(upTo: !all ? 6 : room.members.count);

    if (futureOrMembers is Future<Iterable<User>>) {
      return futureOrMembers.then(filter);
    } else {
      return filter(futureOrMembers);
    }
  }
}