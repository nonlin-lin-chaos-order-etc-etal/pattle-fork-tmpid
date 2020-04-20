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

import '../models/chat_message.dart';

import '../../../matrix.dart';
import '../../../util/room.dart';

import 'event.dart';
import 'state.dart';

export 'state.dart';
export 'event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static const _pageSize = 30;

  final Matrix _matrix;
  Room _room;

  StreamSubscription _syncSub;

  ChatBloc(this._matrix, this._room) {
    _syncSub = _room.updates.onlySync.listen((update) {
      _room = update.user.rooms[_room.id];
      add(FetchChat(refresh: true));
    });
  }

  MyUser get me => _matrix.user;

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
  ChatState get initialState => _loadMessages();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is FetchChat) {
      if (!event.refresh) {
        yield state.copyWith(loadingMore: true);

        final update = await _room.timeline.load(count: _pageSize);
        _room = update.user.rooms[_room.id];
      }

      yield _loadMessages();
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

  ChatState _loadMessages() {
    final messages = <ChatMessage>[];

    RoomEvent event;
    for (event in _room.timeline) {
      var shouldIgnore = false;
      // In direct chats, don't show the invite event between this user
      // and the direct user.
      //
      // Also in direct chats, don't show the join events between this user
      // and the direct user.
      if (_room.isDirect) {
        if (event is InviteEvent) {
          final iInvitedYou =
              event.senderId == me && event.subjectId == _room.directUserId;

          final youInvitedMe =
              event.senderId == _room.directUserId && event.subjectId == me.id;

          shouldIgnore = iInvitedYou || youInvitedMe;
        } else if (event is JoinEvent) {
          final subject = event.subjectId;
          shouldIgnore = subject == me || subject == _room.directUserId;
        }
      }

      shouldIgnore |= event is JoinEvent &&
          event is! DisplayNameChangeEvent &&
          _room.creatorId == event.subjectId;

      // Don't show creation events in rooms that are replacements
      shouldIgnore |= event is RoomCreationEvent && _room.isReplacement;

      if (_room.ignoredEvents.contains(event.runtimeType) || shouldIgnore) {
        continue;
      }

      ChatMessage inReplyTo;
      if (event is MessageEvent && event.content?.inReplyToId != null) {
        // TODO: Might not be loaded?
        final inReplyToEvent = _room.timeline[event.content.inReplyToId];

        if (inReplyToEvent != null) {
          inReplyTo = ChatMessage(
            _room,
            inReplyToEvent,
            isMe: (id) => id == _matrix.user.id,
          );
        }
      }

      messages.add(
        ChatMessage(
          _room,
          event,
          inReplyTo: inReplyTo,
          isMe: (id) => id == _matrix.user.id,
        ),
      );
    }

    var endReached = false;
    if (event is RoomCreationEvent) {
      endReached = true;
    }

    return ChatState(
      messages: messages,
      endReached: endReached,
    );
  }

  Future<void> _markAllAsRead() async {
    await _room.markRead(until: _room.timeline.first.id);
  }

  Future<void> _sendMessage(String text) async {
    // TODO: Check if text is just whitespace
    if (text.isNotEmpty) {
      // Refresh the list every time the sent state changes.
      await for (var _ in _room.send(TextMessage(body: text))) {
        add(FetchChat(refresh: true));
      }
    }
  }

  Future<void> _sendImage(File file) async {
    final fileName = file.path.split('/').last;

    final matrixUrl = await me.upload(
      bytes: file.openRead(),
      length: await file.length(),
      fileName: fileName,
      contentType: lookupMimeType(fileName),
    );

    final image = decodeImage(file.readAsBytesSync());

    final message = ImageMessage(
      url: matrixUrl,
      body: fileName,
      info: ImageInfo(
        width: image.width,
        height: image.height,
      ),
    );

    await for (var _ in _room.send(message)) {
      add(FetchChat(refresh: true));
    }
  }
}
