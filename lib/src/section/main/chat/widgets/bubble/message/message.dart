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

import 'package:provider/provider.dart';

import '../../../../models/chat.dart';
import '../../../../models/chat_member.dart';
import '../../../../models/chat_message.dart';

import '../../../../../../resources/theme.dart';

import '../../../../widgets/message_state.dart';

import 'content/image.dart';
import 'content/redacted.dart';
import 'content/text.dart';
import 'content/loading.dart';

import '../../../../../../util/date_format.dart';
import '../../../../../../util/chat_member.dart';

class MessageBubble extends StatelessWidget {
  final Chat chat;

  final ChatMessage message;
  final ChatMessage previousMessage;
  final ChatMessage nextMessage;

  final bool isStartOfGroup;
  final bool isEndOfGroup;

  /// If this is not null, this bubble is rendered inside another
  /// bubble, because it's replied to by [reply].
  final ChatMessage reply;

  final BorderRadius borderRadius;

  final Color color;

  final Widget child;

  final EdgeInsets contentPadding = EdgeInsets.all(8);

  static const _groupTimeLimit = Duration(minutes: 3);

  static const _oppositePadding = 48.0;

  static const _paddingBetween = 8.0;
  static const _paddingBetweenSameGroup = 2.0;

  MessageBubble._({
    @required this.chat,
    @required this.message,
    this.previousMessage,
    this.nextMessage,
    @required this.isStartOfGroup,
    @required this.isEndOfGroup,
    this.reply,
    @required this.borderRadius,
    @required this.child,
    this.color,
  });

  factory MessageBubble({
    @required Chat chat,
    @required ChatMessage message,
    ChatMessage previousMessage,
    ChatMessage nextMessage,
    ChatMessage reply,
    Color color,
    @required Widget child,
  }) {
    final isStartOfGroup = _isStartOfGroup(message, previousMessage, reply);
    final isEndOfGroup = _isEndofGroup(message, nextMessage, reply);

    return MessageBubble._(
      chat: chat,
      message: message,
      previousMessage: previousMessage,
      nextMessage: nextMessage,
      isStartOfGroup: isStartOfGroup,
      isEndOfGroup: isEndOfGroup,
      reply: reply,
      borderRadius: _borderRadius(message, isEndOfGroup, isStartOfGroup),
      color: color,
      child: child,
    );
  }

  /// Create a [MessageBubble] with the correct [child] for the given [message].
  factory MessageBubble.withContent({
    @required Chat chat,
    @required ChatMessage message,
    ChatMessage previousMessage,
    ChatMessage nextMessage,
    ChatMessage reply,
  }) {
    final event = message.event;

    Widget content =
        Container(); // TODO: Create default unsupported event content
    if (event is TextMessageEvent) {
      content = TextContent();
    } else if (event is ImageMessageEvent) {
      content = ImageContent();
    } else if (event is RedactedEvent) {
      content = RedactedContent();
    }

    return MessageBubble(
      chat: chat,
      message: message,
      previousMessage: previousMessage,
      nextMessage: nextMessage,
      reply: reply,
      child: content,
    );
  }

  factory MessageBubble.loading({@required Chat chat, bool isMine = false}) {
    return MessageBubble(
      chat: chat,
      color: Colors.grey[300],
      message: ChatMessage(
        TextMessageEvent(
          RoomEventArgs(
            id: EventId('1234'),
            sender: User(
              id: UserId('@wilko:pattle.im'),
              state: UserState(
                roomId: RoomId('!343432:pattle.im'),
                displayName: 'Wilko',
                since: DateTime.now(),
              ),
            ),
            time: DateTime.now(),
          ),
          content: TextMessage(
            body: 'Blabla',
          ),
        ),
        sender: ChatMember(
          User(
            id: UserId('@wilko:pattle.im'),
            state: UserState(
              roomId: RoomId('!343432:pattle.im'),
              displayName: 'Wilko',
              since: DateTime.now(),
            ),
          ),
          isYou: isMine,
          name: 'Wilko',
        ),
      ),
      child: LoadingContent(),
    );
  }

  static bool _isStartOfGroup(
    ChatMessage message,
    ChatMessage previousMessage,
    ChatMessage reply,
  ) {
    if (reply != null) {
      return false;
    }

    final event = message.event;
    final previousEvent = previousMessage?.event;

    if (previousEvent is StateEvent) {
      return true;
    }

    final previousHasSameSender = previousEvent != null &&
        previousMessage.sender.name == previousMessage.sender.name &&
        previousEvent.sender == event.sender;

    if (!previousHasSameSender) {
      return true;
    }

    // Difference between time is greater than 3 min
    final limit = event.time.subtract(_groupTimeLimit).millisecondsSinceEpoch;

    if (previousEvent.time.millisecondsSinceEpoch <= limit) {
      return true;
    }

    return false;
  }

  static bool _isEndofGroup(
    ChatMessage message,
    ChatMessage nextMessage,
    ChatMessage reply,
  ) {
    if (reply != null) {
      return false;
    }

    final event = message.event;
    final nextEvent = nextMessage?.event;

    if (nextEvent is StateEvent) {
      return true;
    }

    final nextHasSameSender = nextEvent != null &&
        nextMessage.sender.name == nextMessage.sender.name &&
        nextEvent.sender == event.sender;

    if (!nextHasSameSender) {
      return true;
    }

    // Difference between time is greater than 3 min
    final limit = event.time.add(_groupTimeLimit).millisecondsSinceEpoch;

    if (nextEvent.time.millisecondsSinceEpoch >= limit) {
      return true;
    }

    return false;
  }

  static BorderRadius _borderRadius(
    ChatMessage message,
    bool isEndOfGroup,
    bool isStartOfGroup,
  ) {
    const radius = Radius.circular(8);
    var borderRadius = BorderRadius.all(radius);

    if (message.isMine) {
      if (isEndOfGroup) {
        borderRadius = BorderRadius.only(
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
        );
      }
    } else {
      if (isStartOfGroup) {
        borderRadius = BorderRadius.only(
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        );
      }
    }

    return borderRadius;
  }

  @override
  Widget build(BuildContext context) {
    final color = this.color ??
        (message.isMine
            ? context.pattleTheme.chat.myMessageColor
            : context.pattleTheme.chat.theirMessageColor);

    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return Column(
      crossAxisAlignment:
          message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: reply == null
                    ? EdgeInsets.only(
                        left: message.isMine ? _oppositePadding : 0,
                        right: !message.isMine ? _oppositePadding : 0,
                        top: previousMessage == null ? _paddingBetween : 0,
                        bottom: isEndOfGroup
                            ? _paddingBetween
                            : _paddingBetweenSameGroup,
                      )
                    : EdgeInsets.zero,
                child: Material(
                  color: color,
                  elevation: 1,
                  shape: border,
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyText2.apply(
                          fontSizeFactor: 1.1,
                          color: message.isMine ? Colors.white : null,
                        ),
                    child: Provider<MessageBubble>.value(
                      value: this,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static MessageBubble of(BuildContext context) =>
      Provider.of<MessageBubble>(context, listen: false);
}

/// Helper widget to make a [MessageBubble] clickable with a ripple. Defaults
/// to showing a context menu on tap, and being selected on long press.
///
/// Must have a [MessageBubble] ancestor.
class Clickable extends StatelessWidget {
  /// In some cases an extra [Material] widget is necessary to render the
  /// ripple correctly.
  final bool extraMaterial;
  final VoidCallback onTap;
  final Widget child;

  const Clickable({
    Key key,
    this.extraMaterial = false,
    this.onTap,
    this.child,
  }) : super(key: key);

  void _showContextMenu() {}

  @override
  Widget build(BuildContext context) {
    final bubble = MessageBubble.of(context);

    final inkWell = InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: bubble.borderRadius),
      onTap: onTap ?? _showContextMenu,
      child: child,
    );

    if (!extraMaterial) {
      return inkWell;
    } else {
      return Material(
        color: Colors.transparent,
        child: inkWell,
      );
    }
  }
}

/// Conditionally shows sent state and message time.
///
/// Must have a [MessageBubble] ancestor.
class MessageInfo extends StatelessWidget {
  const MessageInfo({Key key}) : super(key: key);

  static bool necessary(BuildContext context) {
    final bubble = MessageBubble.of(context);

    return bubble.isEndOfGroup;
  }

  @override
  Widget build(BuildContext context) {
    final bubble = MessageBubble.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (MessageState.necessary(bubble.message)) ...[
          MessageState(
            message: bubble.message,
            color: Colors.white,
            size: 14,
          ),
          SizedBox(width: 4),
        ],
        if (bubble.isEndOfGroup)
          Text(
            formatAsTime(bubble.message.event.time),
            style: DefaultTextStyle.of(context).style.apply(
                  fontSizeFactor: 0.8,
                ),
          ),
      ],
    );
  }
}

/// Conditionally shows sender.
///
/// Must have a [MessageBubble] ancestor.
class Sender extends StatelessWidget {
  /// If true, the color of the sender will be based on their Matrix ID.
  final bool personalizedColor;

  const Sender({
    Key key,
    this.personalizedColor = true,
  }) : super(key: key);

  static bool necessary(BuildContext context) {
    final bubble = MessageBubble.of(context);

    return !bubble.message.isMine &&
        !bubble.chat.isDirect &&
        (bubble.isStartOfGroup || bubble.reply != null);
  }

  @override
  Widget build(BuildContext context) {
    final bubble = MessageBubble.of(context);

    return Text(
      bubble.message.sender.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: personalizedColor ? bubble.message.sender.color(context) : null,
      ),
    );
  }
}
