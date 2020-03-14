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
import 'package:pattle/src/section/main/widgets/redacted.dart';

import '../../../../../../../util/color.dart';

import '../../message.dart';

/// Redacted content for a [MessageBubble].
///
/// Must have a [MessageBubble] as ancestor.
class RedactedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = MessageBubble.of(context);

    return Clickable(
      child: Padding(
        padding: info.contentPadding,
        child: Column(
          crossAxisAlignment: info.message.isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Sender(),
            DefaultTextStyle(
              style: TextStyle(
                color: themed(
                  context,
                  light:
                      info.message.isMine ? Colors.grey[300] : Colors.grey[700],
                  dark: info.message.isMine ? Colors.white30 : Colors.white70,
                ),
              ),
              child: Redacted(event: info.message.event),
            ),
            SizedBox(height: 4),
            MessageInfo()
          ],
        ),
      ),
    );
  }
}
