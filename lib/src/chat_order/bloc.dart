// Copyright (C) 2020  Wilko Manger
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

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat.dart';

import 'event.dart';
import 'state.dart';

export 'event.dart';
export 'state.dart';

class ChatOrderBloc extends Bloc<ChatOrderEvent, ChatOrderState> {
  static const _personalKey = 'personal';
  static const _publicKey = 'public';

  final SharedPreferences _preferences;

  ChatOrderBloc(this._preferences);

  @override
  ChatOrderState get initialState => _getFromPreferences();

  @override
  Stream<ChatOrderState> mapEventToState(ChatOrderEvent event) async* {
    if (event is UpdateChatOrder) {
      Map<RoomId, DateTime> set(List<Chat> chats, String key) {
        var map = Map<RoomId, DateTime>.fromIterable(
          chats,
          key: (chat) => chat.room.id,
          value: (chat) =>
              chat.latestMessageForSorting?.event?.time ??
              DateTime.fromMillisecondsSinceEpoch(0),
        );

        final current = key == _personalKey ? state.personal : state.public;

        map = {
          ...current,
          ...map,
        }.sorted;

        _preferences.setString(
          key,
          json.encode(
            map.map(
              (key, value) => MapEntry(
                key.toString(),
                value.millisecondsSinceEpoch,
              ),
            ),
          ),
        );

        return map;
      }

      yield ChatOrderState(
        personal: set(event.personal, _personalKey),
        public: set(event.public, _publicKey),
      );
    }
  }

  ChatOrderState _getFromPreferences() {
    Map<RoomId, DateTime> get(String key) {
      final encoded = _preferences.getString(key);

      if (encoded == null) {
        return {};
      }

      final decoded = json.decode(encoded) as Map<String, dynamic>;

      return decoded.map(
        (key, value) => MapEntry(
          RoomId(key),
          DateTime.fromMillisecondsSinceEpoch(value),
        ),
      );
    }

    return ChatOrderState(
      personal: get(_personalKey),
      public: get(_publicKey),
    );
  }
}

extension on Map<RoomId, DateTime> {
  Map<RoomId, DateTime> get sorted {
    return Map.fromEntries(
      entries.toList()
        ..sort(
          (a, b) => -a.value.compareTo(b.value),
        ),
    );
  }
}
