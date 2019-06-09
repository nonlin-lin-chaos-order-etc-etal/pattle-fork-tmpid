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
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/util/date_format.dart';
import 'package:pattle/src/ui/util/user.dart';

import 'image_bubble.dart';
import 'state/member_bubble.dart';
import 'text_bubble.dart';


abstract class Item extends StatelessWidget {

  final ChatItem item;

  final ChatItem previousItem;
  final ChatItem nextItem;

  // Styling;
  static const betweenMargin = 16.0;
  static const sideMargin = 16.0;

  Item({
    @required this.item,
    @required this.previousItem,
    @required this.nextItem,
  });

  @override
  Widget build(BuildContext context);

  @protected
  double marginBottom() => betweenMargin;

  @protected
  double marginTop() => previousItem == null ? betweenMargin : 0;
}