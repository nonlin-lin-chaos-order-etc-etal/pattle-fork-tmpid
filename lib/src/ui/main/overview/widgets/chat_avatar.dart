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
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:mdi/mdi.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/room.dart';
import 'package:pattle/src/ui/util/user.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../util/url.dart';

class ChatAvatar extends StatelessWidget {
  final Room room;

  const ChatAvatar({Key key, this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarUrl = avatarUrlOf(room);
    if (avatarUrl != null) {
      return Hero(
        tag: room.id,
        child: Container(
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
        ),
      );
    } else {
      return CircleAvatar(
        foregroundColor: Colors.white,
        backgroundColor: room.isDirect
            ? room.directUser.getColor(context)
            : LightColors.red[500],
        radius: 24,
        child: _icon(),
      );
    }
  }

  Icon _icon() {
    if (room.isDirect) {
      return Icon(Icons.person);
    } else if (room.aliases != null && room.aliases.isNotEmpty) {
      return Icon(Mdi.bullhorn);
    } else {
      return Icon(Icons.group);
    }
  }
}
