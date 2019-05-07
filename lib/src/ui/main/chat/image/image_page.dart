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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/util/date_format.dart';
import 'package:pattle/src/ui/util/user.dart';
import 'package:pattle/src/ui/util/matrix_image.dart';
import 'package:photo_view/photo_view.dart';

import 'package:pattle/src/di.dart' as di;

class ImagePageState extends State<ImagePage> {

  final me = di.getLocalUser();
  final ImageMessageEvent message;

  ImagePageState(this.message);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date =
      '${formatAsDate(context, message.time)}, ${formatAsTime(message.time)}';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PhotoView(
            imageProvider: MatrixImage(message.content.url),
            heroTag: message.id,
            minScale: PhotoViewComputedScale.contained,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayNameOf(message.sender)),
                  SizedBox(height: 2),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.body1.copyWith(
                      color: Colors.white,
                    )
                  ),
                ],
              ),
              backgroundColor: Color(0x64000000),
            ),
          )
        ]
      )
    );
  }
}

class ImagePage extends StatefulWidget {

  final ImageMessageEvent message;

  ImagePage(this.message);

  @override
  State<StatefulWidget> createState() => ImagePageState(message);
}