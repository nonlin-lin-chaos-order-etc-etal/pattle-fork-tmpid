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
import 'package:pattle/src/resources/theme.dart';
import 'package:pattle/src/section/main/models/chat_message.dart';
import 'package:pattle/src/util/color.dart';
import 'package:pattle/src/util/date_format.dart';
import 'package:provider/provider.dart';

import 'content/image.dart';
import 'content/redacted.dart';
import 'content/text.dart';

import '../../../../../../util/user.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatMessage previousMessage;
  final ChatMessage nextMessage;

  final bool isStartOfGroup;
  final bool isEndOfGroup;

  final bool isReply;

  final BorderRadius borderRadius;

  final Widget child;

  final EdgeInsets contentPadding = EdgeInsets.all(8);

  static const _groupTimeLimit = Duration(minutes: 3);

  static const _oppositePadding = 48.0;

  static const _paddingBetween = 8.0;
  static const _paddingBetweenSameGroup = 2.0;

  MessageBubble._({
    @required this.message,
    @required this.previousMessage,
    @required this.nextMessage,
    @required this.isStartOfGroup,
    @required this.isEndOfGroup,
    this.isReply = false,
    @required this.borderRadius,
    @required this.child,
  });

  factory MessageBubble({
    ChatMessage message,
    ChatMessage previousMessage,
    ChatMessage nextMessage,
    bool isReply = false,
    Widget child,
  }) {
    final isStartOfGroup = _isStartOfGroup(message, previousMessage, isReply);
    final isEndOfGroup = _isEndofGroup(message, nextMessage, isReply);

    return MessageBubble._(
      message: message,
      previousMessage: previousMessage,
      nextMessage: nextMessage,
      isStartOfGroup: isStartOfGroup,
      isEndOfGroup: isEndOfGroup,
      isReply: isReply,
      borderRadius: _borderRadius(message, isEndOfGroup, isStartOfGroup),
      child: child,
    );
  }

  /// Create a [MessageBubble] with the correct [child] for the given [message].
  factory MessageBubble.withContent({
    @required ChatMessage message,
    @required ChatMessage previousMessage,
    @required ChatMessage nextMessage,
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
      message: message,
      previousMessage: previousMessage,
      nextMessage: nextMessage,
      child: content,
    );
  }

  static bool _isStartOfGroup(
    ChatMessage message,
    ChatMessage previousMessage,
    bool isReply,
  ) {
    if (isReply == true) {
      return false;
    }

    final event = message.event;
    final previousEvent = previousMessage?.event;

    if (previousEvent is StateEvent) {
      return true;
    }

    final previousHasSameSender = previousEvent != null &&
        previousEvent.sender.displayName == event.sender.displayName &&
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
    bool isReply,
  ) {
    if (isReply == true) {
      return false;
    }

    final event = message.event;
    final nextEvent = nextMessage?.event;

    if (nextEvent is StateEvent) {
      return true;
    }

    final nextHasSameSender = nextEvent != null &&
        nextEvent.sender.displayName == event.sender.displayName &&
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
    final color = message.isMine
        ? themed(
            context,
            light: LightColors.red[450],
            dark: LightColors.red[700],
          )
        : themed(
            context,
            light: Colors.white,
            dark: Colors.grey[800],
          );

    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                left: message.isMine ? _oppositePadding : 0,
                right: !message.isMine ? _oppositePadding : 0,
                top: previousMessage == null ? _paddingBetween : 0,
                bottom:
                    isEndOfGroup ? _paddingBetween : _paddingBetweenSameGroup,
              ),
              child: Material(
                color: color,
                elevation: 1,
                shape: border,
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.body1.apply(
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
    );
  }

  static MessageBubble of(BuildContext context) =>
      Provider.of<MessageBubble>(context);
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
    final info = MessageBubble.of(context);

    final inkWell = InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: info.borderRadius),
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

  @override
  Widget build(BuildContext context) {
    final info = MessageBubble.of(context);

    if (!info.isEndOfGroup) {
      return Container(width: 0, height: 0);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (info.message.isMine)
          Icon(
            info.message.event.sentState != SentState.sent
                ? Icons.access_time
                : Icons.check,
            color: Colors.white,
            size: 14,
          ),
        SizedBox(width: 4),
        if (info.isEndOfGroup)
          Text(
            formatAsTime(info.message.event.time),
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

  final EdgeInsets padding;

  const Sender({
    Key key,
    this.personalizedColor = true,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final info = MessageBubble.of(context);

    final showSender = (info.isStartOfGroup ||
            (info.isReply != null && !info.message.isMine)) &&
        !info.message.room.isDirect;

    if (!showSender) {
      return Container(width: 0, height: 0);
    }

    return Padding(
      padding: padding,
      child: Text(
        info.message.event.sender.displayName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: personalizedColor
              ? info.message.event.sender.getColor(context)
              : null,
        ),
      ),
    );
  }
}
