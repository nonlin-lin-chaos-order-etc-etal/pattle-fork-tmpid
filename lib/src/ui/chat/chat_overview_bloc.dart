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
import 'package:pattle/src/model/chat_overview.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pattle/src/di.dart' as di;

final bloc = ChatOverviewBloc();

class ChatOverviewBloc {
  
  PublishSubject<List<ChatOverview>> _chatsSubj = PublishSubject<List<ChatOverview>>();
  Observable<List<ChatOverview>> get chats => _chatsSubj.stream;

  Observable<bool> syncStream;

  final LocalUser _user = di.getLocalUser();

  Future<void> loadChats() async {
    var chats = List<ChatOverview>();

    // Get all rooms and push them as a single list
    await for(Room room in _user.rooms.all()) {
      var latestEvent = await room.events.all()
          .lastWhere((event) => true, orElse: () => null);

      var chat = ChatOverview(
          id: room.id,
          name: room.name,
          latestEvent: latestEvent
      );

      chats.add(chat);
      print(chats.length);
    }

    _chatsSubj.add(List.of(chats));
  }

  Future<void> startSync() async {
    // Load from store before sync
    loadChats();

    Observable(_user.sync())
      .listen((success) async {
        if (success) {
          await loadChats();
        }
      });
  }
}