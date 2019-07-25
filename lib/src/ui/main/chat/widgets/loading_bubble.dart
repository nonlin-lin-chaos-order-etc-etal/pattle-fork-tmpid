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
import 'package:pattle/src/ui/main/models/chat_item.dart';

import 'message_bubble.dart';

class LoadingBubble extends MessageBubble {
  @override
  TextMessageEvent event;

  LoadingBubble({
    @required bool isMine,
  }) : super(
          item: ChatEvent(
            TextMessageEvent(
              TextMessage(
                body: 'Blabla',
              ),
              RoomEventArgs(
                id: EventId('1234'),
                sender: User(
                    id: UserId('@wilko:pattle.im'),
                    state: UserState(
                        roomId: RoomId('!343432:pattle.im'),
                        displayName: 'Wilko',
                        since: DateTime.now())),
                time: DateTime.now(),
              ),
            ),
          ),
          isMine: isMine,
        ) {
    event = item.event;
  }

  @override
  State<StatefulWidget> createState() => LoadingBubbleState();
}

class LoadingBubbleState extends MessageBubbleState<LoadingBubble> {
  @override
  Color mineColor() => Colors.grey[350];

  @protected
  Widget buildMine(BuildContext context) => buildContent(context);

  @override
  Color theirsColor() => Colors.grey[350];

  @protected
  Widget buildTheirs(BuildContext context) => buildContent(context);

  @override
  Widget buildContent(BuildContext context) => Container(
        height: 64,
        width: 256,
      );
}
