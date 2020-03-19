// Copyright (C) 2019  wilko
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:pattle/src/resources/theme.dart';
import 'package:pattle/src/section/main/chats/models/chat.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../util/room.dart';
import '../../../../util/chat_member.dart';
import '../../../../util/url.dart';

class ChatAvatar extends StatelessWidget {
  final Chat chat;

  const ChatAvatar({Key key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarUrl = chat.room.displayAvatarUrl;
    if (avatarUrl != null) {
      return Container(
        width: 48,
        height: 48,
        child: ClipOval(
          child: FadeInImage(
            fit: BoxFit.cover,
            placeholder: MemoryImage(kTransparentImage),
            image: CachedNetworkImageProvider(
              avatarUrl.toThumbnailString(context),
            ),
          ),
        ),
      );
    } else {
      return CircleAvatar(
        foregroundColor: Colors.white,
        backgroundColor: chat.room.isDirect
            ? chat.directMember.color(context)
            : LightColors.red[500],
        radius: 24,
        child: _icon(),
      );
    }
  }

  Icon _icon() {
    if (chat.room.isDirect) {
      return Icon(Icons.person);
    } else if (chat.room.aliases != null && chat.room.aliases.isNotEmpty) {
      return Icon(Mdi.bullhorn);
    } else {
      return Icon(Icons.group);
    }
  }
}
