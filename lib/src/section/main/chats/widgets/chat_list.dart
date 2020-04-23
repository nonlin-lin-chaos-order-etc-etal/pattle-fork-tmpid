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

import '../../../../app.dart';
import '../../models/chat.dart';
import '../../widgets/chat_name.dart';
import '../../../../util/date_format.dart';

import 'chat_avatar.dart';
import 'subtitle/subtitle.dart';

class ChatList extends StatefulWidget {
  final List<Chat> chats;

  const ChatList({Key key, this.chats}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 64,
        ),
        itemCount: widget.chats.length,
        itemBuilder: (context, index) {
          return _buildChat(widget.chats[index]);
        },
      ),
    );
  }

  Widget _buildChat(Chat chat) {
    final time = formatAsListItem(context, chat.latestMessage?.event?.time);

    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Expanded(
            child: ChatName(
              chat: chat,
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.caption.color,
                ),
          ),
        ],
      ),
      dense: false,
      onTap: () {
        Navigator.pushNamed(context, Routes.chats, arguments: chat.room.id);
      },
      leading: ChatAvatar(chat: chat),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      subtitle: Subtitle.withContent(chat),
    );
  }
}
