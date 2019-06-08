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
import 'package:pattle/src/di.dart' as di;
import 'package:pattle/src/ui/util/user.dart';

import 'image_subtitle.dart';
import 'member_subtitle.dart';
import 'redacted_subtitle.dart';
import 'text_subtitle.dart';
import 'unsupported_subtitle.dart';
abstract class Subtitle extends StatelessWidget {

  static const iconSize = 20.0;

  final RoomEvent event;
  @protected
  final String senderName;

  Subtitle(this.event)
    : senderName =
      event != null && !event.sender.isIdenticalTo(di.getLocalUser())
      ? '${displayNameOf(event.sender)}: '
      : '';

  factory Subtitle.fromEvent(Event event) {
    if (event == null) {
      return UnsupportedSubtitle(event);
    }

    if (event is TextMessageEvent) {
      return TextSubtitle(event);
    } else if (event is ImageMessageEvent) {
      return ImageSubtitle(event);
    } else if (event is MemberChangeEvent) {
      return MemberSubtitle(event);
    } else if (event is RedactedEvent) {
      return RedactedSubtitle(event);
    }

    return UnsupportedSubtitle(event);
  }

  TextStyle textStyle(BuildContext context) =>
    Theme.of(context).textTheme.body1.copyWith(
      color: Theme.of(context).textTheme.caption.color
    );

  TextSpan senderSpan(BuildContext context, {String sender}) =>
    TextSpan(
      text: sender ?? senderName,
      style: Theme.of(context).textTheme.body1.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.caption.color
      ),
    );
}