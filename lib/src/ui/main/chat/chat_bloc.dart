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

class ChatBloc {

  final Room room;

  StreamSubscription syncSub;

  ChatBloc(this.room) {
    syncSub = syncBloc.stream.listen((_) => _shouldRefreshSubj.add(true));
  }

  List<Type> get ignoredEvents => ignoredEventsOf(room, isOverview: false);

  PublishSubject<bool> _isLoadingEventsSubj = PublishSubject<bool>();
  Stream<bool> get isLoadingEvents => _isLoadingEventsSubj.stream.distinct();

  final me = di.getLocalUser();

  int _maxPagesCount;
  int get maxPageCount => _maxPagesCount;

  int _currentPage;

  PublishSubject<bool> _hasReachedEndSubj = PublishSubject<bool>();
  Stream<bool> get hasReachedEnd => _hasReachedEndSubj.stream.distinct();

  PublishSubject<bool> _shouldRefreshSubj = PublishSubject<bool>();
  Stream<bool> get shouldRefresh => _shouldRefreshSubj.stream;

  FutureOr<List<ChatItem>> getPage(int page) {
    _currentPage = page;
    final chatItems = List<ChatItem>();

    List<ChatItem> toChatItems(Iterable<RoomEvent> events) {
      // Remember: 'previous' is actually next in time
      RoomEvent previousEvent;
      RoomEvent event;
      for(event in events) {
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

        shouldIgnore |=
            event is JoinEvent && event is! DisplayNameChangeEvent
                && room.creator.isIdenticalTo(event.content.subject);

        // Don't show creation events in rooms that are replacements
        shouldIgnore |= event is RoomCreationEvent && room.isReplacement;

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

      // Add date header above first event in room
      if (event is RoomCreationEvent) {
        chatItems.add(DateItem(event.time));

        _maxPagesCount = _currentPage + 1;
        _hasReachedEndSubj.add(true);
      }

      return chatItems.isNotEmpty ? chatItems : null;
    }

    final futureOrEvents = room.timeline.paginate(page: page);

    if (futureOrEvents is Iterable<RoomEvent>) {
      return toChatItems(futureOrEvents);
    } else {
      final future = futureOrEvents as Future<Iterable<RoomEvent>>;

      return future.then((events) => toChatItems(events));
    }
  }

  Future<void> sendMessage(String text) async {
    final room = this.room;
    // TODO: Check if text is just whitespace
    if (room is JoinedRoom && text.isNotEmpty) {
      // Refresh the list every time the sent state changes.
      await for (var sentState in room.send(TextMessage(body: text))) {
        _shouldRefreshSubj.add(true);
      }
    }
  }


  bool _notifying = false;
  bool _typing = false;
  final _stopwatch = Stopwatch();
  Timer _notTypingTimer;
  String _lastInput;
  Future<void> notifyInputChanged(String input) async {
    final room = this.room as JoinedRoom;

    if (!_notifying) {
      // Ignore null -> to '' input, triggers when clicking
      // on the textfield
      if (_lastInput == null && input.isEmpty) return;

      _lastInput = input;

      _notifying = true;

      _notTypingTimer?.cancel();

      if (_stopwatch.elapsed >= const Duration(seconds: 4) ||
          !_stopwatch.isRunning) {
        _typing = true;

        await room.setIsTyping(true, timeout: const Duration(seconds: 7));

        _stopwatch.reset();
        _stopwatch.start();
      }

      _notifying = false;
    }

    _notTypingTimer = Timer(const Duration(seconds: 5), () async {
      if (_typing) {
        _typing = false;
        await room.setIsTyping(false);
      }
    });
  }


  void cleanUp() {
    syncSub.cancel();
  }
}