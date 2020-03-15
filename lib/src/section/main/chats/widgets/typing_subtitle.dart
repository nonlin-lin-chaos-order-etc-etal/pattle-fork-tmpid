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
import 'package:pattle/src/resources/theme.dart';
import 'package:pattle/src/section/main/chat/util/typing_span.dart';

import 'subtitle.dart';

class TypingSubtitleContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final room = Subtitle.of(context).chat.room;

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          color: redOnBackground(context),
          fontWeight: FontWeight.bold,
        ),
        children: typingSpan(context, room),
      ),
    );
  }
}
