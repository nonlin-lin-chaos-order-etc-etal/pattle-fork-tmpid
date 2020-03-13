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
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image/image.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:mime/mime.dart';
import 'package:pattle/src/section/main/chat/event.dart';
import 'package:pattle/src/section/main/models/chat_item.dart';

import '../../../matrix.dart';
import '../../../util/room.dart';

import 'event.dart';
export 'event.dart';

import 'state.dart';
export 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final Matrix matrix;
  final Room room;

  StreamSubscription _syncSub;

  ChatBloc(this.matrix, this.room) {
    _syncSub = matrix.user.sync.listen((state) {
      if (state.dirtyRooms.contains(room)) {
        add(FetchChat());
      }
    });
  }

  List<Type> get _ignoredEvents => ignoredEventsOf(room, isOverview: false);

  LocalUser get me => matrix.user;

  // TODO: Move to separate bloc
  //bool _notifying = false;
  //bool _typing = false;
  //final _stopwatch = Stopwatch();
  //Timer _notTypingTimer;
  //String _lastInput;
  /*Future<void> notifyInputChanged(String input) async {
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
  }*/

  @override
  Future<void> close() async {
    await super.close();
    await _syncSub.cancel();
  }

  @override
  ChatState get initialState => ChatLoading();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is FetchChat) {
      yield await _fetch();
    }

    if (event is MarkAsRead) {
      await _markAllAsRead();
    }

    if (event is SendTextMessage) {
      await _sendMessage(event.message);
    }

    if (event is SendImageMessage) {
      await _sendImage(event.file);
    }
  }

  Future<ChatState> _fetch() async {
    final currentState = this.state;

    int page;
    if (currentState is ChatLoaded) {
      page = currentState.pageCount;
    } else {
      page = 0;
    }

    final events = await room.timeline.paginate(page: page);

    final chatItems = List<ChatItem>();

    // Remember: 'previous' is actually next in time
    RoomEvent previousEvent;
    RoomEvent event;
    for (event in events) {
      var shouldIgnore = false;
      // In direct chats, don't show the invite event between this user
      // and the direct user.
      //
      // Also in direct chats, don't show the join events between this user
      // and the direct user.
      if (room.isDirect) {
        if (event is InviteEvent) {
          final iInvitedYou =
              event.sender == me && event.subject == room.directUser;

          final youInvitedMe =
              event.sender == room.directUser && event.subject == me;

          shouldIgnore = iInvitedYou || youInvitedMe;
        } else if (event is JoinEvent) {
          final subject = event.subject;
          shouldIgnore = subject == me || subject == room.directUser;
        }
      }

      shouldIgnore |= event is JoinEvent &&
          event is! DisplayNameChangeEvent &&
          room.creator == event.subject;

      // Don't show creation events in rooms that are replacements
      shouldIgnore |= event is RoomCreationEvent && room.isReplacement;

      if (_ignoredEvents.contains(event.runtimeType) || shouldIgnore) {
        continue;
      }

      // Insert DateHeader if there's a day difference
      if (previousEvent != null &&
          event != null &&
          previousEvent.time.day != event.time.day) {
        chatItems.add(DateItem(previousEvent.time));
      }

      chatItems.add(ChatMessage(room, event));
      previousEvent = event;
    }

    bool endReached = false;
    // Add date header above first event in room
    if (event is RoomCreationEvent) {
      chatItems.add(DateItem(event.time));

      endReached = true;
    }

    if (currentState is ChatLoaded) {
      return currentState.copyWith(
        items: currentState.items + chatItems,
        pageCount: page + 1,
        endReached: endReached,
      );
    } else {
      return ChatLoaded(
        items: chatItems,
        pageCount: page + 1,
        endReached: endReached,
      );
    }
  }

  Future<void> _markAllAsRead() async {
    final latestEvent = (await room.timeline.get(upTo: 1)).first;

    final r = room as JoinedRoom;

    await r.markRead(until: latestEvent.id);
  }

  Future<void> _sendMessage(String text) async {
    final room = this.room;
    // TODO: Check if text is just whitespace
    if (room is JoinedRoom && text.isNotEmpty) {
      // Refresh the list every time the sent state changes.
      await for (var _ in room.send(TextMessage(body: text))) {
        add(FetchChat());
      }
    }
  }

  Future<void> _sendImage(File file) async {
    final fileName = file.path.split('/').last;

    final matrixUrl = await me.upload(
      byteStream: file.openRead(),
      length: await file.length(),
      fileName: fileName,
      contentType: lookupMimeType(fileName),
    );

    final image = decodeImage(file.readAsBytesSync());

    final r = room as JoinedRoom;

    final message = ImageMessage(
      url: matrixUrl,
      body: fileName,
      info: ImageInfo(
        width: image.width,
        height: image.height,
      ),
    );

    await for (var _ in r.send(message)) {
      add(FetchChat());
    }
  }
}
