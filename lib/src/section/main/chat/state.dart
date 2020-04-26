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

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/chat.dart';
import '../models/chat_message.dart';

class ChatState extends Equatable {
  final Chat chat;
  final List<ChatMessage> messages;
  final bool endReached;
  final bool wasRefresh;

  ChatState({
    @required this.chat,
    @required this.messages,
    @required this.endReached,
    @required this.wasRefresh,
  });

  @override
  List<Object> get props => [chat, messages, endReached, wasRefresh];
}
