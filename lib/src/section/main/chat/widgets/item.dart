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
import 'package:pattle/src/section/main/models/chat_item.dart';

abstract class Item extends StatefulWidget {
  final ChatItem item;

  final ChatItem previousItem;
  final ChatItem nextItem;

  // Styling;
  static const betweenMargin = 8.0;
  static const sideMargin = 16.0;

  Item({
    @required this.item,
    @required this.previousItem,
    @required this.nextItem,
  });
}

abstract class ItemState<T extends Item> extends State<T>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;

  @protected
  double marginBottom() => Item.betweenMargin;

  @protected
  double marginTop() => widget.previousItem == null ? Item.betweenMargin : 0;
}
