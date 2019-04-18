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
import 'package:pattle/src/ui/main/sync_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {

  JoinedRoom room;

  int _eventCount = 20;

  PublishSubject<bool> _isLoadingEventsSubj = PublishSubject<bool>();
  Stream<bool> get isLoadingEvents => _isLoadingEventsSubj.stream.distinct();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    if (!isLoading) {
      _isLoadingEventsSubj.add(false);
    } else {
      // If still loading after 2 seconds, notify the UI
      Future.delayed(const Duration(seconds: 2), () {
        if (isLoading) {
          _isLoadingEventsSubj.add(true);
        }
      });
    }
  }

  PublishSubject<List<RoomEvent>> _eventSubj = PublishSubject<List<RoomEvent>>();
  Stream<List<RoomEvent>> get events => _eventSubj.stream;

  Future<void> startLoadingEvents() async {
    await loadEvents();

    syncBloc.stream.listen((success) async => await loadEvents());
  }

  Future<void> requestMoreEvents() async {
    if (!_isLoading) {
      isLoading = true;
      _eventCount += 30;
      await loadEvents();
      isLoading = false;
    }
  }

  Future<void> loadEvents() async {
    var chatEvents = List<RoomEvent>();

    // Get all rooms and push them as a single list
    await for(RoomEvent event in room.events.upTo(_eventCount)) {
      chatEvents.add(event);
    }

    _eventSubj.add(List.of(chatEvents));
  }

  Future<void> sendMessage(String text) async {
    // TODO: Check if text is just whitespace
    if (text.isNotEmpty) {
      await room.send(TextMessage(body: text));
      await loadEvents();
    }

  }
}