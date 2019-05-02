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

import '../bubble.dart';


abstract class StateBubble extends Bubble {

  static const horizontalMargin = 64;
  static const borderRadius = const BorderRadius.all(Bubble.radiusForBorder);

  StateBubble({
    @required StateEvent event,
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
  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: Bubble.sideMargin,
                right: Bubble.sideMargin,
                bottom: Bubble.betweenMargin
              ),
              child: Material(
                elevation: 1,
                color: LightColors.red[100],
                borderRadius: borderRadius,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: borderRadius
                  ),
                  onTap: () { },
                  child: Padding(
                    padding: Bubble.padding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        buildContent(context),
                        SizedBox(height: 4),
                        Text(formatAsTime(event.time),
                          style: Theme.of(context).textTheme.body1.copyWith(
                            fontSize: 11
                          ),
                        )
                      ],
                    )
                  ),
                )
              ),
            )
          )
        )
      ],
    );
  }
}