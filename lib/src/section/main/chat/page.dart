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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/app.dart';

import 'package:pattle/src/resources/localizations.dart';
import 'package:pattle/src/resources/theme.dart';
import 'package:pattle/src/section/main/chats/models/chat_overview.dart';
import 'package:pattle/src/section/main/widgets/chat_name.dart';
import 'package:pattle/src/section/main/widgets/error.dart';
import 'package:pattle/src/section/main/widgets/title_with_sub.dart';

import '../../../matrix.dart';
import '../../../util/color.dart';
import '../../../util/room.dart';
import '../../../util/url.dart';

import 'bloc.dart';
import 'util/typing_span.dart';
import 'widgets/bubble/message.dart';
import 'widgets/bubble/state.dart';
import 'widgets/date_header.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage._(this.chat);

  static Widget withBloc(Chat chat) {
    return BlocProvider<ChatBloc>(
      create: (c) => ChatBloc(Matrix.of(c), chat.room),
      child: ChatPage._(chat),
    );
  }

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Timer _readTimer;

  Room get _room => widget.chat.room;

  @override
  void dispose() {
    super.dispose();
    _readTimer.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_readTimer != null) {
      _readTimer.cancel();
    }

    final bloc = BlocProvider.of<ChatBloc>(context);

    _readTimer = Timer(
      Duration(seconds: 2),
      () => bloc.add(MarkAsRead()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container();
    final avatarUrl = widget.chat.room.displayAvatarUrl;
    if (avatarUrl != null) {
      avatar = Hero(
        tag: _room.id,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider(
            avatarUrl.toThumbnailString(context),
          ),
        ),
      );
    }

    final settingsGestureDetector = ({Widget child}) {
      return GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(Routes.chatsSettings, arguments: widget.chat),
        child: child,
      );
    };

    // TODO: typingUsers should not contain nulls
    Widget title =
        _room.isSomeoneElseTyping && !_room.typingUsers.any((u) => u == null)
            ? TitleWithSub(
                title: ChatName(chat: widget.chat),
                subtitle: RichText(
                  text: TextSpan(
                    children: typingSpan(context, _room),
                  ),
                ),
              )
            : ChatName(chat: widget.chat);

    return Scaffold(
      backgroundColor: chatBackgroundColor(context),
      appBar: AppBar(
        titleSpacing: 0,
        title: settingsGestureDetector(
          child: Row(
            children: <Widget>[
              avatar,
              SizedBox(width: 16),
              Expanded(
                child: title,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          ErrorBanner(),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _MessageList(room: _room),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.loose(
                    Size.fromHeight(
                      MediaQuery.of(context).size.height / 3,
                    ),
                  ),
                  child: _Input(room: _room),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatefulWidget {
  final Room room;

  const _MessageList({Key key, @required this.room}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = BlocProvider.of<ChatBloc>(context);

    bloc.add(FetchChat());

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        bloc.add(FetchChat());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded) {
          return ListView.builder(
            controller: _scrollController,
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.endReached
                ? state.messages.length
                : state.messages.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.messages.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final message = state.messages[index];

              final event = message.event;

              var previousMessage, nextMessage;
              // Note: Because the items are reversed in the
              // ListView.builder, the 'previous' event is actually the next
              // one in the list.
              if (index != state.messages.length - 1) {
                previousMessage = state.messages[index + 1];
              }

              if (index != 0) {
                nextMessage = state.messages[index - 1];
              }

              Widget bubble;
              if (event is StateEvent) {
                bubble = StateBubble.withContent(message: message);
              } else {
                bubble = MessageBubble.withContent(
                  message: message,
                  previousMessage: previousMessage,
                  nextMessage: nextMessage,
                );
              }

              // Insert DateHeader if there's a day difference
              if (previousMessage != null &&
                  event != null &&
                  previousMessage.event.time.day != event.time.day) {
                return DateHeader(
                  date: previousMessage.event.time,
                  child: bubble,
                );
              } else {
                return bubble;
              }
            },
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          reverse: true,
          children: List.generate(10, (i) {
            return MessageBubble.loading(
              room: widget.room,
              isMine: i % 2 == 0,
            );
          }),
        );
      },
    );
  }
}

class _Input extends StatefulWidget {
  final Room room;

  const _Input({Key key, @required this.room}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputState();
}

class _InputState extends State<_Input> {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChatBloc>(context);

    const elevation = 8.0;

    if (widget.room is JoinedRoom) {
      return Material(
        elevation: elevation,
        color: chatBackgroundColor(context),
        // On dark theme, draw a divider line because the shadow is gone
        shape: Theme.of(context).brightness == Brightness.dark
            ? Border(top: BorderSide(color: Colors.grey[800]))
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Material(
            elevation: elevation,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            color: themed(context, light: Colors.white, dark: Colors.grey[800]),
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                filled: true,
                hintText: l(context).typeAMessage,
                prefixIcon: IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () async {
                    await bloc.add(
                      SendImageMessage(
                        await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                        ),
                      ),
                    );
                  },
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    bloc.add(SendTextMessage(_textController.value.text));
                    _textController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Material(
        elevation: elevation,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            l(context).cantSendMessages,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
