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
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/date_format.dart';
import 'package:pattle/src/ui/util/display_name.dart';

import 'image_bubble.dart';
import 'state/member_bubble.dart';
import 'text_bubble.dart';


abstract class Bubble extends StatelessWidget {

  final RoomEvent event;

  final RoomEvent previousEvent;
  final RoomEvent nextEvent;

  final bool isMine;

  // Styling
  static const padding = const EdgeInsets.all(8);
  static const radiusForBorder = const Radius.circular(8);
  static const betweenMargin = 16.0;
  static const sideMargin = 16.0;

  Bubble({
    @required this.event,
    @required this.previousEvent,
    @required this.nextEvent,
    @required this.isMine
  });

  factory Bubble.fromEvent({
    @required RoomEvent event,
    @required RoomEvent previousEvent,
    @required RoomEvent nextEvent,
    @required bool isMine
  }) {
    if (event is TextMessageEvent) {
      return TextBubble(
        event: event,
        previousEvent: previousEvent,
        nextEvent: nextEvent,
        isMine: isMine
      );
    } else if (event is ImageMessageEvent) {
      return ImageBubble(
        event: event,
        previousEvent: previousEvent,
        nextEvent: nextEvent,
        isMine: isMine
      );
    } else if (event is MemberChangeEvent) {
      return MemberBubble(
        event: event,
        previousEvent: previousEvent,
        nextEvent: nextEvent,
        isMine: isMine
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context);

  @protected
  double marginBottom() => betweenMargin;

  @protected
  double marginTop() {
    if (previousEvent == null) {
      return betweenMargin;
    } else {
      return 0;
    }
  }
}