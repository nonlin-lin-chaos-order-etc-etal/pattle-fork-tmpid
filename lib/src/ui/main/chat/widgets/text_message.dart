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


class TextMessage extends StatelessWidget {

  final TextMessageEvent message;

  final RoomEvent previousEvent;
  final RoomEvent nextEvent;

  final bool isMine;

  static const _groupTimeLimit = const Duration(minutes: 3);

  // Styling
  static const _radiusForBorder = const Radius.circular(8);
  static const _padding = const EdgeInsets.all(8);
  static const _sideMargin = 16.0;
  static const _betweenMargin = 24.0;
  static const _betweenGroupMargin = 4.0;
  static const _oppositeMargin = 64.0;

  TextMessage({
    @required this.message,
    @required this.previousEvent,
    @required this.nextEvent,
    @required this.isMine
  });

  @override
  Widget build(BuildContext context) {
    if (isMine) {
      return _buildMine(context);
    } else {
      return _buildTheirs(context);
    }
  }

  TextStyle _textStyle(BuildContext context) {
    var style = Theme.of(context).textTheme.body1;

    if (isMine) {
      style = style.copyWith(
          color: Colors.white
      );
    }

    return style;
  }

  Widget _buildTime(BuildContext context) {
    if (_isEndOfGroup()) {
      return Text(formatAsTime(message.time),
          style: _textStyle(context).copyWith(
            fontSize: 11,
          )
      );
    } else {
      return Container(width: 0, height: 0);
    }
  }


  Widget _buildContent(BuildContext context) =>
    Text(message.body ?? '',
      style: _textStyle(context)
    );

  Widget _buildSender(BuildContext context) {
    if (_isStartOfGroup()) {
      return Text(displayNameOf(message.sender),
        style: _textStyle(context).copyWith(
            fontWeight: FontWeight.bold
        ),
      );
    } else {
      return Container(height: 0, width: 0);
    }
  }

  bool _isStartOfGroup() {
    var previousHasSameSender = previousEvent?.sender == message.sender;

    if (!previousHasSameSender) {
      return true;
    }

    // Difference between time is greater than 3 min
    var limit = message.time
        .subtract(_groupTimeLimit)
        .millisecondsSinceEpoch;

    if (previousEvent.time.millisecondsSinceEpoch <= limit) {
      return true;
    }

    return false;
  }

  bool _isEndOfGroup() {
    var nextHasSameSender = nextEvent?.sender == message.sender;

    if (!nextHasSameSender) {
      return true;
    }

    // Difference between time is greater than 3 min
    var limit = message.time
      .add(_groupTimeLimit)
      .millisecondsSinceEpoch;

    if (nextEvent.time.millisecondsSinceEpoch >= limit) {
      return true;
    }

    return false;
  }

  double _marginBottom() {
    if (_isEndOfGroup()) {
      return _betweenMargin;
    } else {
      return _betweenGroupMargin;
    }
  }

  double _marginTop() {
    if (previousEvent == null) {
      return _betweenMargin;
    } else {
      return 0;
    }
  }

  BorderRadius _borderRadius() {
    const defaultRadius = const BorderRadius.all(_radiusForBorder);

    if (isMine) {
      if (_isEndOfGroup()) {
        return BorderRadius.only(
          topLeft: _radiusForBorder,
          topRight: _radiusForBorder,
          bottomLeft: _radiusForBorder,
        );
      } else {
        return defaultRadius;
      }
    } else {
      if (_isStartOfGroup()) {
        return BorderRadius.only(
          topRight: _radiusForBorder,
          bottomLeft: _radiusForBorder,
          bottomRight: _radiusForBorder,
        );
      } else {
        return defaultRadius;
      }
    }
  }

  Widget _buildMine(BuildContext context) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(
                  left: _oppositeMargin,
                  right: _sideMargin,
                  bottom: _marginBottom(),
                  top: _marginTop(),
                ),
                padding: _padding,
                decoration: BoxDecoration(
                  color: LightColors.red[450],
                  borderRadius: _borderRadius()
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _buildContent(context),
                    SizedBox(height: 4),
                    _buildTime(context)
                  ],
                )
              ),
            ),
          ]
        ),
      ]
    );

  Widget _buildTheirs(BuildContext context) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(
                  left: _sideMargin,
                  right: _oppositeMargin,
                  bottom: _marginBottom(),
                  top: _marginTop()
                ),
                padding: _padding,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _borderRadius()
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildSender(context),
                    SizedBox(height: 4),
                    _buildContent(context),
                    SizedBox(height: 4),
                    _buildTime(context)
                  ],
                )
              ),
            ),
          ]
        ),
      ],
    );

}