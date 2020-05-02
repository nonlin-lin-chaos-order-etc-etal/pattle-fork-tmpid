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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as path;

import 'auth/bloc.dart';
import 'models/chat.dart';

class Matrix {
  static final MoorStore store = MoorStore(
    LazyDatabase(() async {
      final dataDir = await getApplicationDocumentsDirectory();
      return VmDatabase(File(path.join(dataDir.path, 'pattle.sqlite')));
    }),
  );

  // Used for listening to auth state changes
  final AuthBloc _authBloc;

  MyUser _user;
  MyUser get user => _user;

  final Completer<void> _firstSyncCompleter = Completer();
  Future<void> get firstSync => _firstSyncCompleter.future;

  final Completer<void> _userAvailable = Completer();
  Future<void> get userAvaible => _userAvailable.future;

  var _chats = <RoomId, Chat>{};
  Map<RoomId, Chat> get chats => _chats;

  Matrix(this._authBloc) {
    _authBloc.listen(_processAuthState);
  }

  Future<void> _processAuthState(AuthState state) async {
    if (state is Authenticated) {
      _user = state.user;
      _userAvailable.complete();
      _user.startSync();

      await _user.updates.firstSync.then(_processUpdate);
      _firstSyncCompleter.complete();

      _user.updates.listen(_processUpdate);
    }

    if (state is NotAuthenticated) {
      _user?.stopSync();
      _user = null;
    }
  }

  void _processUpdate(Update update) {
    _user = update.user;

    _chats = Map.fromEntries(
      _user.rooms.where((r) => !r.isUpgraded).map(
            (r) => MapEntry(
              r.id,
              r.toChat(myId: _user.id),
            ),
          ),
    );

    _chatUpdatesController.add(
      ChatsUpdate(
        chats: _chats,
        // TODO: Add toMap in SDK
        delta: Map.fromEntries(
          update.delta.rooms.map((room) => MapEntry(room.id, room)),
        ),
        timelineLoad: update is RequestUpdate<Timeline>,
      ),
    );
  }

  final _chatUpdatesController = StreamController<ChatsUpdate>.broadcast();

  Stream<ChatUpdate> updatesFor(RoomId roomId) => _chatUpdatesController.stream
      .map(
        (update) => ChatUpdate(
          chat: update.chats[roomId],
          delta: update.delta[roomId],
          timelineLoad: update.timelineLoad,
        ),
      )
      .where((update) => update.delta != null);

  static Matrix of(BuildContext context) => Provider.of<Matrix>(
        context,
        listen: false,
      );
}

@immutable
class ChatsUpdate {
  final Map<RoomId, Chat> chats;
  final Map<RoomId, Room> delta;

  final bool timelineLoad;

  ChatsUpdate({
    @required this.chats,
    @required this.delta,
    @required this.timelineLoad,
  });
}

class ChatUpdate {
  final Chat chat;
  final Room delta;

  final bool timelineLoad;

  ChatUpdate({
    @required this.chat,
    @required this.delta,
    @required this.timelineLoad,
  });
}
