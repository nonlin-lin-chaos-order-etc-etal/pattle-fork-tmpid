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
import 'package:pattle/src/section/main/models/chat_member.dart';
import 'package:pattle/src/section/main/models/chat_message.dart';

import '../../../matrix.dart';
import '../../../util/room.dart';
import 'models/chat.dart';

import 'event.dart';
export 'event.dart';

import 'state.dart';
export 'state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final Matrix _matrix;

  ChatsBloc(this._matrix);

  Future<List<Chat>> _getChats() async {
    final me = _matrix.user;

    await me.sync.first;

    final chats = List<Chat>();

    // Get all rooms and push them as a single list
    for (Room room in await me.rooms.get()) {
      // Don't show rooms that have been upgraded
      if (room.isUpgraded) {
        continue;
      }

      // TODO: Add optional filter argument to up to call
      final latestEvent =
          (await room.timeline.get(upTo: 10, allowRemote: false)).firstWhere(
        (event) => !room.ignoredEvents.contains(event.runtimeType),
        orElse: () => null,
      );

      var latestEventForSorting =
          (await room.timeline.get(upTo: 10, allowRemote: false)).firstWhere(
        (event) =>
            (event is! MemberChangeEvent ||
                (event is JoinEvent &&
                    event is! DisplayNameChangeEvent &&
                    event is! AvatarChangeEvent &&
                    event.subject.id == me.id)) &&
            event is! RedactionEvent,
        orElse: () => null,
      );

      // If there is no non-MemberChangeEvent in the last
      // 10 messages, just settle for the most recent one (which ever
      // type it is).
      if (latestEventForSorting == null) {
        latestEventForSorting = latestEvent;
      }

      final chat = Chat(
        room: room,
        name: await room.getDisplayName(),
        isJustYou: room.members.count == 1,
        latestMessage: latestEvent != null
            ? await ChatMessage.create(
                room,
                latestEvent,
                isMe: (u) => u == _matrix.user,
              )
            : null,
        latestMessageForSorting: latestEventForSorting != null
            ? ChatMessage(
                room,
                latestEventForSorting,
                sender: await ChatMember.fromUser(
                  room,
                  latestEventForSorting.sender,
                  isYou: latestEventForSorting.sender == _matrix.user,
                ),
              )
            : null,
      );

      chats.add(chat);
    }

    chats.sort((a, b) {
      if (a.room.highlightedUnreadNotificationCount > 0 &&
          b.room.highlightedUnreadNotificationCount <= 0) {
        return 1;
      } else if (a.room.highlightedUnreadNotificationCount <= 0 &&
          b.room.highlightedUnreadNotificationCount > 0) {
        return -1;
      } else if (a.room.totalUnreadNotificationCount > 0 &&
          b.room.totalUnreadNotificationCount <= 0) {
        return 1;
      } else if (a.room.totalUnreadNotificationCount <= 0 &&
          b.room.totalUnreadNotificationCount > 0) {
        return -1;
      } else if (a.latestMessageForSorting != null &&
          b.latestMessageForSorting != null) {
        return a.latestMessageForSorting.event.time.compareTo(
          b.latestMessageForSorting.event.time,
        );
      } else if (a.latestMessageForSorting != null &&
          b.latestMessageForSorting == null) {
        return 1;
      } else if (a.latestMessageForSorting == null &&
          b.latestMessageForSorting != null) {
        return -1;
      } else {
        return 0;
      }
    });

    return chats.reversed.toList();
  }

  Future<ChatsState> _loadChats() async {
    final chats = await _getChats();

    final personalChats = chats
        .where(
          (chat) =>
              chat.room.joinRule == JoinRule.invite ||
              chat.room.joinRule == JoinRule.private,
        )
        .toList();

    final publicChats = chats
        .where(
          (chat) =>
              chat.room.joinRule == JoinRule.public ||
              chat.room.joinRule == JoinRule.knock,
        )
        .toList();

    return ChatsLoaded(personal: personalChats, public: publicChats);
  }

  @override
  ChatsState get initialState => ChatsLoading();

  @override
  Stream<ChatsState> mapEventToState(ChatsEvent event) async* {
    if (event is LoadChats) {
      print('loading chats');
      yield await _loadChats();
    }
  }
}
