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

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pattle/src/resources/localizations.dart';
import 'package:pattle/src/section/main/chats/models/chat_overview.dart';

class ChatName extends StatelessWidget {
  final Chat chat;

  ChatName({@required this.chat});

  @override
  Widget build(BuildContext context) {
    return Text(
      chat.isJustYou ? l(context).you : chat.name,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
