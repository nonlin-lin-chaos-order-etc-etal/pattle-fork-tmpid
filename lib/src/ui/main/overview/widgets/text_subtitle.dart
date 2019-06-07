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

import 'subtitle.dart';

class TextSubtitle extends Subtitle {

  @override
  final TextMessageEvent event;

  TextSubtitle(this.event) : super(event);

  @override
  Widget build(BuildContext context) {
    if (event.content.inReplyToId == null) {
      return RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        text: TextSpan(
          style: textStyle(context),
          children: [
            senderSpan(context),
            TextSpan(
              text: event.content.body ?? 'null'
            )
          ]
        )
      );
    } else {
      // Strip replied-to content
      final text = event.content.formattedBody
        .split(RegExp('(<\\/*mx-reply>)'))[2];

      return Row(
        children: <Widget>[
          RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            text: senderSpan(context)
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