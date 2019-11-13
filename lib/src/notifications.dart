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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matrix_image/matrix_image.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import 'package:pattle/src/di.dart' as di;
import 'package:pattle/src/ui/util/room.dart';
import 'package:pattle/src/ui/util/user.dart';

FirebaseMessaging _firebase;

FlutterLocalNotificationsPlugin _notifications;
Future<void> _initializeNotifications() async {
  _notifications = FlutterLocalNotificationsPlugin();
  await _notifications.initialize(
    InitializationSettings(
      AndroidInitializationSettings('ic_launcher_foreground'),
      IOSInitializationSettings(),
    ),
  );
}

final channelId = 'pattle';
final channelTitle = 'Pattle';
final channelDescription = 'Receive message from Pattle';

Future<void> initialize() async {
  await _initializeNotifications();

  _firebase = FirebaseMessaging()
    ..configure(
      onMessage: _showNotification,
      onBackgroundMessage: backgroundHandle,
    );
}

Future<String> getFirebaseToken() => _firebase.getToken();

Future<void> _showNotification(Map<String, dynamic> message) async {
  final roomId = RoomId(message['data']['room_id']);
  final eventId = EventId(message['data']['event_id']);

  final user = di.getLocalUser();
  final room = await user.rooms[roomId];
  final event = await room.timeline[eventId];

  final senderName = displayNameOf(event.sender);

  final senderPerson = Person(
    bot: false,
    name: senderName,
    icon: await MatrixCacheManager(di.getHomeserver()).getPathOf(
      event.sender.avatarUrl.toString(),
    ),
    iconSource: IconSource.FilePath,
  );

  if (event is TextMessageEvent) {
    final body = event.content.body;

    await _notifications.show(
      eventId.hashCode,
      nameOf(room),
      body,
      NotificationDetails(
        AndroidNotificationDetails(
          channelId,
          channelTitle,
          channelDescription,
          importance: Importance.Max,
          priority: Priority.Max,
          style: AndroidNotificationStyle.Messaging,
          styleInformation: MessagingStyleInformation(
            senderPerson,
            conversationTitle: !room.isDirect ? await nameOf(room) : null,
            groupConversation: room.isDirect,
            messages: [
              Message(
                body,
                event.time,
                senderPerson,
              ),
            ],
          ),
        ),
        IOSNotificationDetails(),
      ),
    );
  }
}

Future<dynamic> backgroundHandle(Map<String, dynamic> message) async {
  await _initializeNotifications();

  di.registerStore();
  final user = await LocalUser.fromStore(di.getStore());
  di.registerLocalUser(user);

  await user.syncOnce();

  await _showNotification(message);
}