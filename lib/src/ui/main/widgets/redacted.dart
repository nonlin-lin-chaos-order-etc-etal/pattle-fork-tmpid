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

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/di.dart' as di;
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/util/user.dart';

class Redacted extends StatelessWidget {
  
  final RedactedEvent event;

  final Color color;
  final double iconSize;

  const Redacted(
    {@required this.event, this.color = Colors.grey, this.iconSize}) : super();

  @override
  Widget build(BuildContext context) {
    List<TextSpan> text;
    if (event.redaction.sender == di.getLocalUser()) {
      text = [TextSpan(text: ' ${l(context).youDeletedThisMessage}')];
    } else {
      text = l(context).hasDeletedThisMessage(
          TextSpan(text: ' ${displayNameOf(event.redaction.sender)}')
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.delete,
          color: color,
          size: iconSize,
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: color
            ),
            children: text
          ),
        )
      ],
    );
  }
  
}