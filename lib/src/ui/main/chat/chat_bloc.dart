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
import 'package:pattle/src/ui/main/models/chat_item.dart';
import 'package:pattle/src/ui/main/sync_bloc.dart';
import 'package:pattle/src/ui/util/room.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pattle/src/di.dart' as di;

class ChatBloc {

  Room room;

  int _eventCount = 20;

  List<Type> get ignoredEvents => ignoredEventsOf(room, isOverview: false);

  PublishSubject<bool> _isLoadingEventsSubj = PublishSubject<bool>();
  Stream<bool> get isLoadingEvents => _isLoadingEventsSubj.stream.distinct();

  final me = di.getLocalUser();

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

  PublishSubject<List<ChatItem>> _itemSubj = PublishSubject<List<ChatItem>>();
  Stream<List<ChatItem>> get items => _itemSubj.stream;

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
    final chatItems = List<ChatItem>();

    // Remember: 'previous' is actually next in time
    RoomEvent previousEvent;
    RoomEvent event;
    await for(event in room.timeline.upTo(count: _eventCount)) {

      var shouldIgnore = false;
      // In direct chats, don't show the invite event between this user
      // and the direct user.
      //
      // Also in direct chats, don't show the join events between this user
      // and the direct user.
      if (room.isDirect) {
        if (event is InviteEvent) {
          final iInvitedYou = event.sender.isIdenticalTo(me)
              && event.content.subject.isIdenticalTo(room.directUser);

          final youInvitedMe = event.sender.isIdenticalTo(room.directUser)
              && event.content.subject.isIdenticalTo(me);

          shouldIgnore = iInvitedYou || youInvitedMe;
        } else if (event is JoinEvent) {
          final subject = event.content.subject;
          shouldIgnore = subject.isIdenticalTo(me)
            || subject.isIdenticalTo(room.directUser);
        }
      }

      shouldIgnore = shouldIgnore ||
        event is JoinEvent && event is! DisplayNameChangeEvent
        && room.creator.isIdenticalTo(event.content.subject);

      if (ignoredEvents.contains(event.runtimeType) || shouldIgnore) {
        continue;
      }

      // Insert DateHeader if there's a day difference
      if (previousEvent != null && event != null
          && previousEvent.time.day != event.time.day) {
        chatItems.add(DateItem(previousEvent.time));
      }

      chatItems.add(ChatEvent(event));

      previousEvent = event;
    }

    // Add DateHeader above all events
    chatItems.add(DateItem(event.time));

    _itemSubj.add(List.of(chatItems));
  }

  Future<void> sendMessage(String text) async {
    final room = this.room;
    // TODO: Check if text is just whitespace
    if (room is JoinedRoom && text.isNotEmpty) {
      // Refresh the list every time the sent state changes.
      await for (var sentState in room.send(TextMessage(body: text))) {
        await loadEvents();
      }
    }
  }
}