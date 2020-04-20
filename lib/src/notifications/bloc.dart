// Copyright (C) 2019  wilko
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

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import '../section/main/models/chat.dart';
import '../section/main/models/chat_member.dart';

import '../auth/bloc.dart';
import '../matrix.dart';

import '../util/url.dart';

import 'event.dart';
import 'state.dart';

export 'event.dart';
export 'state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final Matrix matrix;
  final AuthBloc authBloc;

  StreamSubscription _authSubscription;

  FlutterLocalNotificationsPlugin plugin;

  static const channelId = 'pattle';
  static const channelTitle = 'Pattle';
  static const channelDescription = 'Receive message from Pattle';

  NotificationsBloc({@required this.matrix, @required this.authBloc}) {
    _authSubscription = authBloc.listen((authState) async {
      if (authState is Authenticated) {
        plugin = await _getPlugin();

        FirebaseMessaging()
          ..configure(
            onMessage: (message) => _showNotification(
              plugin,
              matrix.user,
              DataMessage.fromJson(message),
            ),
            onBackgroundMessage: _handleBackgroundMessage,
          );

        if (authState.fromStore) {
          await _setPusher(authState.user);
        }
      }
    });
  }

  @override
  NotificationsState get initialState => Uninitalized();

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {}

  Future<void> _setPusher(MyUser user) async {
    await DotEnv().load();

    await user.pushers.set(
      HttpPusher(
        appId: 'im.pattle.app',
        appName: 'Pattle',
        deviceName: user.currentDevice.name,
        key: await FirebaseMessaging().getToken(),
        url: Uri.parse(
          DotEnv().env['PUSH_URL'],
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    return super.close();
  }

  static Future<FlutterLocalNotificationsPlugin> _getPlugin() async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      InitializationSettings(
        AndroidInitializationSettings('ic_launcher_foreground'),
        IOSInitializationSettings(),
      ),
    );

    return plugin;
  }

  static Message _eventToMessage(RoomEvent event, Person person) {
    if (event is EmoteMessageEvent) {
      return Message(
        '${person.name} ${event.content.body}',
        event.time,
        person,
      );
    }

    if (event is TextMessageEvent) {
      return Message(
        event.content.body,
        event.time,
        person,
      );
    }

    if (event is ImageMessageEvent) {
      // TODO: Show image
      return Message(
        // TODO: Change
        '📷',
        event.time,
        person,
      );
    }

    return null;
  }

  static Future<void> _showNotification(
    FlutterLocalNotificationsPlugin plugin,
    MyUser user,
    DataMessage message,
  ) async {
    final room = await user.rooms[message.roomId];
    final event = await room.timeline[message.eventId];

    final sender = await ChatMember.fromRoomAndUserId(
      room,
      event.senderId,
      isMe: false,
    );

    final icon = await DefaultCacheManager().getSingleFile(
      sender.avatarUrl.toThumbnailStringWith(user.context.homeserver),
    );

    final senderPerson = Person(
      bot: false,
      name: sender.name,
      icon: icon.path,
      iconSource: IconSource.FilePath,
    );

    if (event is MessageEvent) {
      final message = await _eventToMessage(event, senderPerson);

      if (message == null) {
        return;
      }

      final chat = Chat(room: room);

      await plugin.show(
        event.id.hashCode,
        chat.name,
        message.text,
        NotificationDetails(
          AndroidNotificationDetails(
            channelId,
            channelTitle,
            channelDescription,
            importance: Importance.Max,
            priority: Priority.Max,
            enableVibration: true,
            playSound: true,
            style: AndroidNotificationStyle.Messaging,
            styleInformation: MessagingStyleInformation(
              senderPerson,
              conversationTitle: !chat.isDirect ? await chat.name : null,
              groupConversation: chat.isDirect,
              messages: [message],
            ),
          ),
          IOSNotificationDetails(),
        ),
      );
    }
  }
}

Future<dynamic> _handleBackgroundMessage(Map<String, dynamic> message) async {
  final plugin = await NotificationsBloc._getPlugin();

  final user = await MyUser.fromStore(Matrix.store);
  // TODO: Add sync once?
  await user.startSync();
  await user.updates.firstSync;
  await user.stopSync();

  await NotificationsBloc._showNotification(
    plugin,
    user,
    DataMessage.fromJson(message),
  );
}

class DataMessage {
  final RoomId roomId;
  final EventId eventId;

  DataMessage({@required this.roomId, @required this.eventId});

  factory DataMessage.fromJson(Map<String, dynamic> message) {
    return DataMessage(
      roomId: RoomId(message['data']['room_id']),
      eventId: EventId(message['data']['event_id']),
    );
  }
}
