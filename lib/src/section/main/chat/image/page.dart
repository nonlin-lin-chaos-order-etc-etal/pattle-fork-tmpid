// Copyright (C) 2019  Wilko Manger
// Copyright (C) 2019  Nathan van Beelen (CLA signed)
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../models/chat.dart';
import '../../models/chat_member.dart';
import '../../models/chat_message.dart';

import '../../../../matrix.dart';
import '../../../../util/date_format.dart';
import '../../../../util/url.dart';

import 'bloc.dart';

class ImagePage extends StatefulWidget {
  final ChatMessage message;

  ImagePage._(this.message);

  static Widget withBloc(Chat chat, ChatMessage message) {
    assert(message.event is ImageMessageEvent);

    return BlocProvider<ImageBloc>(
      create: (c) => ImageBloc(Matrix.of(c), chat.room.id),
      child: ImagePage._(message),
    );
  }

  @override
  State<StatefulWidget> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  ChatMember _messageSender;
  String _date;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    BlocProvider.of<ImageBloc>(context).add(FetchImages());

    _messageSender = widget.message.sender;

    _date = '${formatAsDate(context, widget.message.event.time)},'
        ' ${formatAsTime(widget.message.event.time)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildPhotoViewList(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_messageSender.name),
                  SizedBox(height: 2),
                  Text(
                    _date,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Color(0x64000000),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPhotoViewList() {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        if (state is ImagesLoaded) {
          final messages = state.messages;
          return PhotoViewGallery.builder(
            itemCount: messages.length,
            reverse: true,
            builder: (context, index) {
              final event = messages[index].event as ImageMessageEvent;

              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  event.content.url.toDownloadString(context),
                ),
                heroTag: widget.message.event.id,
                minScale: PhotoViewComputedScale.contained,
              );
            },
            onPageChanged: (index) {
              setState(() {
                _messageSender = messages[index].sender;
                _date = '${formatAsDate(context, messages[index].event.time)}, '
                    '${formatAsTime(messages[index].event.time)}';
              });
            },
            pageController: PageController(
              initialPage: messages.indexOf(widget.message),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
