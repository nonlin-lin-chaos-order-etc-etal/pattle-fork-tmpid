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
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/util/user.dart';

import 'subtitle.dart';

class TextSubtitle extends Subtitle {

  @override
  final TextMessageEvent event;

  TextSubtitle(this.event) : super(event);

  @override
  Widget build(BuildContext context) {
    final sender = senderSpan(context,
      sender: event is EmoteMessageEvent
              ? displayNameOf(event.sender) + ' ' : null
    );
    if (event.content.inReplyToId == null) {
      return Row(
        children: <Widget>[
          buildSentStateIcon(context),
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                style: textStyle(context),
                children: [
                  sender,
                  TextSpan(
                      text: event.content.body ?? 'null'
                  )
                ]
              )
            ),
          )
        ],
      );
    } else {
      // Strip replied-to content
      final text = event.content.formattedBody
        .split(RegExp('(<\\/*mx-reply>)'))[2];

      return Row(
        children: <Widget>[
          buildSentStateIcon(context),
          RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            text: sender
          ),
          Icon(
            Icons.reply,
            color: Theme.of(context).textTheme.caption.color,
            size: Subtitle.iconSize
          ),
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                style: textStyle(context),
                text: ' ' + text ?? 'null'
              )
            ),
          )
        ],
      );
    }
  }
}