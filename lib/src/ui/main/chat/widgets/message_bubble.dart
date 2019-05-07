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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/date_format.dart';
import 'package:pattle/src/ui/util/user.dart';

import 'bubble.dart';
import 'image_bubble.dart';
import 'text_bubble.dart';


abstract class MessageBubble extends Bubble {

  static const _groupTimeLimit = const Duration(minutes: 3);

  // Styling
  static const _betweenGroupMargin = 4.0;
  static const _oppositeMargin = 64.0;

  MessageBubble({
    @required RoomEvent event,
    @required RoomEvent previousEvent,
    @required RoomEvent nextEvent,
    @required bool isMine
  }) :super(
    event: event,
    previousEvent: previousEvent,
    nextEvent: nextEvent,
    isMine: isMine
  );

  @override
  Widget build(BuildContext context) {
    if (isMine) {
      return _buildMine(context);
    } else {
      return _buildTheirs(context);
    }
  }

  @protected
  TextStyle textStyle(BuildContext context, {Color color}) {
    var style = Theme.of(context).textTheme.body1;

    if (color != null) {
      style = style.copyWith(
          color: color
      );
    } else if (isMine) {
      style = style.copyWith(
          color: Colors.white
      );
    }

    return style;
  }

  @protected
  Widget buildTime(BuildContext context, {Color color}) {
    if (isEndOfGroup) {
      return Text(formatAsTime(event.time),
        style: textStyle(context, color: color).copyWith(
          fontSize: 11,
        )
      );
    } else {
      return Container(width: 0, height: 0);
    }
  }

  @protected
  Widget buildContent(BuildContext context);

  @protected
  Widget buildSender(BuildContext context, {Color color}) {
    if (isStartOfGroup) {
      return Text(displayNameOf(event.sender),
        style: textStyle(context, color: color).copyWith(
          fontWeight: FontWeight.bold,
          color: colorOf(event.sender)
        ),
      );
    } else {
      return Container(height: 0, width: 0);
    }
  }

  bool _isStartOfGroup;
  @protected
  bool get isStartOfGroup {
    if (_isStartOfGroup == null) {
      if (previousEvent is StateEvent) {
        _isStartOfGroup = true;
        return _isStartOfGroup;
      }

      var previousHasSameSender = previousEvent?.sender == event.sender;

      if (!previousHasSameSender) {
        _isStartOfGroup = true;
        return _isStartOfGroup;
      }

      // Difference between time is greater than 3 min
      var limit = event.time
          .subtract(_groupTimeLimit)
          .millisecondsSinceEpoch;

      if (previousEvent.time.millisecondsSinceEpoch <= limit) {
        _isStartOfGroup = true;
        return _isStartOfGroup;
      }

      _isStartOfGroup = false;
      return _isStartOfGroup;
    }

    return _isStartOfGroup;
  }

  bool _isEndOfGroup;
  @protected
  bool get isEndOfGroup {
    if (_isEndOfGroup == null) {
      if (nextEvent is StateEvent) {
        _isEndOfGroup = true;
        return _isEndOfGroup;
      }

      var nextHasSameSender = nextEvent?.sender == event.sender;

      if (!nextHasSameSender) {
        _isEndOfGroup = true;
        return _isEndOfGroup;
      }

      // Difference between time is greater than 3 min
      var limit = event.time
          .add(_groupTimeLimit)
          .millisecondsSinceEpoch;

      if (nextEvent.time.millisecondsSinceEpoch >= limit) {
        _isEndOfGroup = true;
        return _isEndOfGroup;
      }

      _isEndOfGroup = false;
      return _isEndOfGroup;
    }

    return _isEndOfGroup;
  }

  @protected
  @override
  double marginBottom() {
    if (isEndOfGroup) {
      return Bubble.betweenMargin;
    } else {
      return _betweenGroupMargin;
    }
  }

  @protected
  @override
  double marginTop() {
    if (previousEvent == null) {
      return Bubble.betweenMargin;
    } else {
      return 0;
    }
  }

  @protected
  BorderRadius borderRadius() {
    var radius = const BorderRadius.all(Bubble.radiusForBorder);

    if (isMine) {
      if (isEndOfGroup) {
        radius = BorderRadius.only(
          topLeft: Bubble.radiusForBorder,
          topRight: Bubble.radiusForBorder,
          bottomLeft: Bubble.radiusForBorder,
        );
      }
    } else {
      if (isStartOfGroup) {
        radius =  BorderRadius.only(
          topRight: Bubble.radiusForBorder,
          bottomLeft: Bubble.radiusForBorder,
          bottomRight: Bubble.radiusForBorder,
        );
      }
    }

    return radius;
  }

  @protected
  ShapeBorder border() {
    return RoundedRectangleBorder(
      borderRadius: borderRadius(),
    );
  }

  @protected
  Widget buildSentState(BuildContext context) =>
    Icon(event.sentState != SentState.sent
          ? Icons.access_time
          : Icons.check,
      color: Colors.white,
      size: 14
    );

  Widget _buildMine(BuildContext context) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  left: _oppositeMargin,
                  right: Bubble.sideMargin,
                  bottom: marginBottom(),
                  top: marginTop(),
                ),
                child: Material(
                  color: LightColors.red[450],
                  elevation: 1,
                  shape: border(),
                  child: buildMine(context)
                )
              )
            ),
          ]
        ),
      ]
    );

  @protected
  Widget buildMine(BuildContext context);

  Widget _buildTheirs(BuildContext context) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  left: Bubble.sideMargin,
                  right: _oppositeMargin,
                  bottom: marginBottom(),
                  top: marginTop()
                ),
                child: Material(
                  color: Colors.white,
                  elevation: 1,
                  shape: border(),
                  child: buildTheirs(context)
                )
              )
            ),
          ]
        ),
      ],
    );

  @protected
  Widget buildTheirs(BuildContext context);
}