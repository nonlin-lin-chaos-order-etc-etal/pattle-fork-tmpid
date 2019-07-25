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
import 'package:pattle/src/ui/main/chat/widgets/state/creation_bubble.dart';
import 'package:pattle/src/ui/main/chat/widgets/state/topic_bubble.dart';
import 'package:pattle/src/ui/main/chat/widgets/state/upgrade_bubble.dart';
import 'package:pattle/src/ui/main/models/chat_item.dart';

import 'image_bubble.dart';
import 'item.dart';
import 'redacted_bubble.dart';
import 'state/member_bubble.dart';
import 'text_bubble.dart';

abstract class Bubble extends Item {
  @override
  final ChatEvent item;

  final RoomEvent event;

  final bool isMine;

  // Styling
  static const padding = EdgeInsets.all(8);
  static const radiusForBorder = Radius.circular(8);

  Bubble({
    @required this.item,
    ChatItem previousItem,
    ChatItem nextItem,
    @required this.isMine,
  })  : event = item.event,
        super(
          item: item,
          previousItem: previousItem,
          nextItem: nextItem,
        );

  factory Bubble.fromItem({
    @required ChatEvent item,
    ChatItem previousItem,
    ChatItem nextItem,
    @required bool isMine,
  }) {
    if (item.event is TextMessageEvent) {
      return TextBubble(
        item: item,
        previousItem: previousItem,
        nextItem: nextItem,
        isMine: isMine,
      );
    } else if (item.event is ImageMessageEvent) {
      return ImageBubble(
        item: item,
        previousItem: previousItem,
        nextItem: nextItem,
        isMine: isMine,
      );
    } else if (item.event is MemberChangeEvent) {
      return MemberBubble(
        item: item,
        previousItem: previousItem,
        nextItem: nextItem,
        isMine: isMine,
      );
    } else if (item.event is RedactedEvent) {
      return RedactedBubble(
        item: item,
        previousItem: previousItem,
        nextItem: nextItem,
        isMine: isMine,
      );
    } else if (item.event is RoomCreationEvent) {
      return CreationBubble(
        item: item,
        previousItem: previousItem,
        nextItem: nextItem,
        isMine: isMine,
      );
    } else if (item.event is RoomUpgradeEvent) {
      return UpgradeBubble(
        item: item,
        previousItem: previousItem,
        nextItem: nextItem,
        isMine: isMine,
      );
    } else if (item.event is TopicChangeEvent) {
      return TopicBubble(
        item: item,
        previousItem: previousItem,
        nextItem: nextItem,
        isMine: isMine,
      );
    } else {
      return null;
    }
  }

  factory Bubble.asReply({
    @required RoomEvent reply,
    @required RoomEvent replyTo,
    @required bool isMine,
  }) {
    final item = ChatEvent(replyTo);
    if (replyTo is TextMessageEvent) {
      return TextBubble(
        item: item,
        isMine: isMine,
        reply: reply,
      );
    } else if (replyTo is ImageMessageEvent) {
      return ImageBubble(
        item: item,
        isMine: isMine,
        reply: reply,
      );
    } else {
      return null;
    }
  }
}
