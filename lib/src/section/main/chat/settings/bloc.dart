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

import 'package:bloc/bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import '../../../../matrix.dart';
import 'event.dart';
export 'event.dart';

import 'state.dart';
export 'state.dart';

class ChatSettingsBloc extends Bloc<ChatSettingsEvent, ChatSettingsState> {
  final Matrix _matrix;
  final Room _room;

  ChatSettingsBloc(this._matrix, this._room);

  @override
  // TODO: implement initialState
  ChatSettingsState get initialState => ChatSettingsUninitialized();

  @override
  Stream<ChatSettingsState> mapEventToState(ChatSettingsEvent event) async* {
    if (event is FetchMembers) {
      final me = await _room.members[_matrix.user.id];

      final members = List.of(
        await _room.members.get(upTo: !event.all ? 6 : _room.members.count),
      );

      members.remove(me);
      members.insert(0, me);

      yield MembersLoaded(members);
    }
  }
}
