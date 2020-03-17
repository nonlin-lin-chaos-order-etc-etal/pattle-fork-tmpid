// Copyright (C) 2020  Wilko Manger
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
import 'package:pattle/src/section/main/chat/widgets/bubble/message.dart';
import 'package:shimmer/shimmer.dart';

class LoadingContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadingContentState();
}

class _LoadingContentState extends State<LoadingContent> {
  static const _minWidth = 164;
  static const _maxWidth = 256;

  static const _minHeight = 56;
  static const _maxHeight = 95;

  double _width, _height;

  @override
  void initState() {
    super.initState();

    final random = Random();

    _width = _minWidth + random.nextInt(_maxWidth - _minWidth).toDouble();

    _height = _minHeight + random.nextInt(_maxHeight - _minHeight).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final bubble = MessageBubble.of(context);

    return Shimmer.fromColors(
      baseColor: bubble.color,
      highlightColor: Colors.grey[200],
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          borderRadius: bubble.borderRadius,
          color: bubble.color,
        ),
      ),
    );
  }
}
