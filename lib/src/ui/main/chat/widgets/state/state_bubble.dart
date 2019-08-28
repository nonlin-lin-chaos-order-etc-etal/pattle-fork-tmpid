// Copyright (C) 2019  Wilko Manger
// Copyright (C) 2019  Mathieu Velten (FLA signed)
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
import 'package:pattle/src/ui/main/models/chat_item.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/color.dart';
import 'package:pattle/src/ui/util/date_format.dart';

import '../bubble.dart';
import '../item.dart';

abstract class StateBubble extends Bubble {
  static const horizontalMargin = 64;
  static const borderRadius = BorderRadius.all(Bubble.radiusForBorder);

  StateBubble({
    @required ChatEvent item,
    @required ChatItem previousItem,
    @required ChatItem nextItem,
    @required bool isMine,
  }) : super(
            item: item,
            previousItem: previousItem,
            nextItem: nextItem,
            isMine: isMine);

  final void Function(BuildContext) onTap = (context) {};
}

abstract class StateBubbleState<T extends StateBubble> extends ItemState<T> {
  TextStyle defaultTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.body1;

  TextStyle get defaultEmphasisTextStyle =>
      TextStyle(fontWeight: FontWeight.w600);

  @protected
  List<TextSpan> buildContentSpans(BuildContext context);

  @protected
  Widget buildContent(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultTextStyle(context),
        children: buildContentSpans(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // size 12 14-2
    var timeTextStyle = Theme.of(context).textTheme.body1;
    timeTextStyle = timeTextStyle.copyWith(
      fontSize: timeTextStyle.fontSize - 2,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: Item.sideMargin,
                right: Item.sideMargin,
                bottom: marginBottom(),
                top: marginTop(),
              ),
              child: Material(
                elevation: 1,
                color: themed(
                  context,
                  light: LightColors.red[100],
                  dark: LightColors.red[900],
                ),
                borderRadius: StateBubble.borderRadius,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: StateBubble.borderRadius,
                  ),
                  onTap: () => widget.onTap(context),
                  child: Padding(
                    padding: Bubble.padding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        buildContent(context),
                        SizedBox(height: 4),
                        Text(
                          formatAsTime(widget.event.time),
                          style: timeTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
