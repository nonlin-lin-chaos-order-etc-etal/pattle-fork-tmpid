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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/app.dart';

import '../../../../../../../util/url.dart';

import '../../message.dart';

/// Creates an [ImageContent] widget for a [MessageBubble].
///
/// Must have a [MessageBubble] ancestor.
class ImageContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageContentState();
}

class _ImageContentState extends State<ImageContent> {
  static const double _width = 256;
  static const double _minHeight = 72;
  static const double _maxHeight = 292;

  void _onTap() {
    Navigator.pushNamed(
      context,
      Routes.image,
      arguments: MessageBubble.of(context).message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = MessageBubble.of(context);
    assert(info.message.event is ImageMessageEvent);

    final event = info.message.event as ImageMessageEvent;

    final height = (event.content.info?.height ??
            0 / (event.content.info?.width ?? 0 / _width))
        .clamp(_minHeight, _maxHeight);

    return Container(
      width: _width,
      height: height,
      decoration: BoxDecoration(borderRadius: info.borderRadius),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: info.borderRadius,
              child: Hero(
                tag: event.id,
                child: CachedNetworkImage(
                  imageUrl: event.content.url.toThumbnailString(context),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (info.isEndOfGroup) _MessageInfo(),
          if (info.message.isMine && info.isStartOfGroup) _Sender(),
          Positioned.fill(
            child: Clickable(
              extraMaterial: true,
              onTap: _onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = MessageBubble.of(context);

    var alignment, borderRadius;
    if (info.message.isMine) {
      alignment = Alignment.bottomRight;
      borderRadius = info.borderRadius;
    } else {
      alignment = Alignment.bottomLeft;
      borderRadius = BorderRadius.all(info.borderRadius.bottomLeft);
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: info.contentPadding,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Color(0x64000000),
          ),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: !info.message.isMine ? Colors.white : null,
                  ),
              child: MessageInfo(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Sender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = MessageBubble.of(context);

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: info.contentPadding,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: info.borderRadius,
            color: Color(0x64000000),
          ),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
              ),
              child: Sender(),
            ),
          ),
        ),
      ),
    );
  }
}
