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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import 'package:pattle/src/resources/localizations.dart';
import 'package:pattle/src/resources/theme.dart';
import 'package:pattle/src/section/main/chats/models/chat.dart';
import 'package:pattle/src/section/main/widgets/chat_name.dart';
import 'package:pattle/src/section/main/widgets/user_item.dart';

import '../../../../matrix.dart';
import '../../../../util/url.dart';
import '../../../../util/color.dart';
import '../../../../util/room.dart';
import 'bloc.dart';

class ChatSettingsPage extends StatefulWidget {
  final Chat chat;

  ChatSettingsPage._(this.chat);

  static Widget withBloc(Chat chat) {
    return BlocProvider<ChatSettingsBloc>(
      create: (c) => ChatSettingsBloc(Matrix.of(c), chat.room),
      child: ChatSettingsPage._(chat),
    );
  }

  @override
  State<StatefulWidget> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  Room get room => widget.chat.room;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<ChatSettingsBloc>(context).add(FetchMembers(all: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themed(
        context,
        light: LightColors.red[50],
        dark: Theme.of(context).backgroundColor,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          final url =
              widget.chat.room.displayAvatarUrl?.toDownloadString(context);
          return <Widget>[
            SliverAppBar(
              expandedHeight: 128.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: DefaultTextStyle(
                  style: TextStyle(
                    shadows: [
                      Shadow(
                        offset: Offset(0.25, 0.25),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: ChatName(
                    chat: widget.chat,
                  ),
                ),
                background: url != null
                    ? CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                if (!room.isDirect) _Description(),
                SizedBox(height: 16),
                if (!room.isDirect) _MemberList(room: room)
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String description;

  const _Description({Key key, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l(context).description,
                    style: TextStyle(
                      color: redOnBackground(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description ?? l(context).noDescriptionSet,
                    style: TextStyle(
                      fontStyle: description == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MemberList extends StatefulWidget {
  final Room room;

  const _MemberList({Key key, @required this.room}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemberListState();
}

class _MemberListState extends State<_MemberList> {
  bool _previewMembers;
  @override
  void initState() {
    super.initState();
    _previewMembers = true;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    l(context).xParticipants(widget.room.members.count),
                    style: TextStyle(
                      color: redOnBackground(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                BlocBuilder<ChatSettingsBloc, ChatSettingsState>(
                  builder: (context, state) {
                    var members = List<User>();
                    if (state is MembersLoaded) {
                      members = state.members;
                    }

                    final isLoading = state is MembersLoading;
                    final allShown =
                        members.length == widget.room.members.count;

                    return MediaQuery.removePadding(
                      context: context,
                      removeLeft: true,
                      removeRight: true,
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: (_previewMembers && !allShown) || isLoading
                            ? members.length + 1
                            : members.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Item after all members
                          if (index == members.length) {
                            return _ShowMoreItem(
                              room: widget.room,
                              shownMembersCount: members.length,
                              isLoading: isLoading,
                              onTap: () => setState(() {
                                BlocProvider.of<ChatSettingsBloc>(context)
                                    .add(FetchMembers(all: true));
                                _previewMembers = false;
                              }),
                            );
                          }

                          return UserItem(
                            user: members[index],
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 12)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ShowMoreItem extends StatelessWidget {
  final Room room;
  final int shownMembersCount;
  final bool isLoading;
  final VoidCallback onTap;

  const _ShowMoreItem({
    Key key,
    @required this.room,
    @required this.shownMembersCount,
    @required this.isLoading,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.keyboard_arrow_down, size: 32),
      title: Text(l(context).xMore(room.members.count - shownMembersCount)),
      subtitle: isLoading ? LinearProgressIndicator() : null,
      onTap: onTap,
    );
  }
}
