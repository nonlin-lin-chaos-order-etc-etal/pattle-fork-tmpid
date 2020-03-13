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
import 'package:bloc/bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import '../../../../../matrix.dart';
import '../../../../../util/user.dart';

import 'event.dart';
export 'event.dart';

import 'state.dart';
export 'state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final Matrix matrix;

  bool _isCreatingGroup = false;

  final _members = List<User>();

  String _groupName;

  JoinedRoom _createdRoom;
  JoinedRoom get createdRoom => _createdRoom;

  CreateGroupBloc(this.matrix);

  @override
  CreateGroupState get initialState => InitialCreateGroupState();

  Stream<CreateGroupState> _loadUsers() async* {
    final users = Set<User>();
    // Load members of some rooms, in the future
    // this'll be based on activity and what not
    for (final room in await matrix.user.rooms.get(upTo: 10)) {
      for (final user in await room.members.get(upTo: 20)) {
        if (user != matrix.user) {
          users.add(user);
        }
      }
    }

    yield UserListUpdated(
      users.toList(growable: false)
        ..sort(
          (User a, User b) => a.displayName.compareTo(b.displayName),
        ),
      members: _members,
    );
  }

  Stream<CreateGroupState> _createGroup() async* {
    if (!_isCreatingGroup) {
      _isCreatingGroup = true;

      yield CreatingGroup(members: _members);

      final id = await matrix.user.rooms.create(
        name: _groupName,
        invitees: _members,
      );

      // Await the next sync so the room has been processed
      final syncState = await matrix.user.sync.first;
      if (syncState.succeeded) {
        _createdRoom = await matrix.user.rooms[id];
      }

      _isCreatingGroup = false;
      yield CreatedGroup(_createdRoom, members: _members);
    }
  }

  @override
  Stream<CreateGroupState> mapEventToState(CreateGroupEvent event) async* {
    if (event is CreateGroup) {
      yield* _createGroup();
    }

    if (event is LoadUsers) {
      yield* _loadUsers();
    }

    if (event is AddMember) {
      _members.add(event.user);
      yield MemberListUpdated(_members);
    }

    if (event is RemoveMember) {
      _members.remove(event.user);
      yield MemberListUpdated(_members);
    }
  }
}
