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
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/util/display_name.dart';

import '../bubble.dart';
import 'state_bubble.dart';


class MemberBubble extends StateBubble {

  final MemberChangeEvent event;

  MemberBubble({
    @required this.event,
    @required RoomEvent previousEvent,
    @required RoomEvent nextEvent,
    @required bool isMine
  }) : super(
    event: event,
    previousEvent: previousEvent,
    nextEvent: nextEvent,
    isMine: isMine
  );

  @protected
  @override
  Widget buildContent(BuildContext context) {
    final subjectName =
      displayNameOrId(event.content.subjectId, event.content.displayName);

    final senderName = displayNameOf(event.sender);

    var text;

    if (event is JoinEvent) {
      text = l(context).hasJoined(subjectName);
    } else if (event is LeaveEvent) {
      text = l(context).hasLeft(subjectName);
    } else if (event is InviteEvent) {
      text = l(context).hasBeenInvited(subjectName, senderName);
    } else if (event is BanEvent) {
      text = l(context).hasBeenBanned(subjectName, senderName);
    }

    return Text(text);
  }
}