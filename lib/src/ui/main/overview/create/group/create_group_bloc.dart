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
import 'dart:collection';

import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/util/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pattle/src/di.dart' as di;

final bloc = CreateGroupBloc();

class CreateGroupBloc {
  final me = di.getLocalUser();

  PublishSubject<List<User>> _userSubj = PublishSubject<List<User>>();
  Stream<List<User>> get users => _userSubj.stream.distinct();


  bool _isCreatingRoom = false;
  PublishSubject<bool> _isCreatingRoomSubj = PublishSubject<bool>();
  Stream<bool> get isCreatingRoom => _isCreatingRoomSubj.stream.distinct();

  final usersToAdd = List<User>();

  String groupName;

  Future<void> loadMembers() async {
    final users = HashSet<User>(
      equals: (User a, User b) => a.isIdenticalTo(b),
      hashCode: (User user) => user.id.hashCode
    );
    // Load members of some rooms, in the future
    // this'll be based on activity and what not
    await for (final room in me.rooms.upTo(count: 10)) {
      await for (final user in room.members.upTo(count: 20)) {
        if (!user.isIdenticalTo(me)) {
          users.add(user);
        }
      }
    }

    _userSubj.add(
      users.toList(growable: false)
      ..sort((User a, User b) => displayNameOf(a).compareTo(displayNameOf(b)))
    );
  }

  Future<RoomId> createRoom() async {
    if (!_isCreatingRoom) {
      _isCreatingRoom = true;
      _isCreatingRoomSubj.add(true);
      return me.rooms.create(
          name: groupName,
          invitees: usersToAdd
      ).whenComplete(() {
        _isCreatingRoom = false;
        _isCreatingRoomSubj.add(false);
      });

    }

    return null;
  }
}