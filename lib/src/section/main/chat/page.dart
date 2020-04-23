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
import '../../../app.dart';

import '../../../resources/intl/localizations.dart';
import '../../../resources/theme.dart';
import '../models/chat.dart';
import '../chats/widgets/typing_content.dart';
import '../widgets/chat_name.dart';
import '../widgets/title_with_sub.dart';

import '../../../matrix.dart';
import '../../../util/url.dart';

import 'bloc.dart';
import 'widgets/bubble/message.dart';
import 'widgets/bubble/state.dart';
import 'widgets/date_header.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage._(this.chat);

  static Widget withBloc(Chat chat) {
    return BlocProvider<ChatBloc>(
      create: (c) => ChatBloc(Matrix.of(c), chat.room.id),
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
    final avatarUrl = widget.chat.avatarUrl;
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

    Widget title = _room.isSomeoneElseTyping
        ? TitleWithSub(
            title: ChatName(chat: widget.chat),
            subtitle: TypingContent(
              chat: widget.chat,
              style: TextStyle(
                color:
                    Theme.of(context).appBarTheme.textTheme?.headline6?.color ??
                        Theme.of(context).primaryTextTheme.headline6.color,
              ),
            ),
          )
        : ChatName(chat: widget.chat);

    return Scaffold(
      backgroundColor: context.pattleTheme.chat.backgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            Routes.chatsSettings,
            arguments: widget.chat,
          ),
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
          //ErrorBanner(),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _MessageList(chat: widget.chat),
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
  final Chat chat;

  const _MessageList({Key key, @required this.chat}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  final _scrollController = ScrollController();
  final double _scrollThreshold = 200;

  bool _requestingMore = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = BlocProvider.of<ChatBloc>(context);

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      final state = bloc.state;

      if (maxScroll - currentScroll <= _scrollThreshold &&
          !state.endReached &&
          !_requestingMore) {
        _requestingMore = true;
        bloc.add(FetchChat(refresh: false));
      }
    });
  }

  void _onStateChange(ChatState state) {
    _requestingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) => _onStateChange(state),
      builder: (context, state) {
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
                chat: widget.chat,
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
                date: event.time,
                child: bubble,
              );
            } else {
              return bubble;
            }
          },
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
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChatBloc>(context);

    const elevation = 8.0;

    if (widget.room.myMembership is Joined) {
      return Material(
        elevation: elevation,
        color: context.pattleTheme.chat.backgroundColor,
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
            color: context.pattleTheme.chat.backgroundColor,
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
                fillColor: context.pattleTheme.chat.inputColor,
                hintText: context.intl.chat.typeAMessage,
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
            context.intl.chat.cantSendMessages,
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
