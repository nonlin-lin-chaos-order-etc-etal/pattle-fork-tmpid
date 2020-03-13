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

abstract class ChatItem {}

class DateItem implements ChatItem {
  final DateTime date;

  DateItem(this.date);
}

class ChatMessage<T extends RoomEvent> implements ChatItem {
  final Room room;
  final T event;

  ChatMessage(this.room, this.event);

  ChatMessage<E> as<E extends RoomEvent>() {
    final e = event;
    if (e is E) {
      return ChatMessage<E>(room, e);
    } else {
      return null;
    }
  }
}
