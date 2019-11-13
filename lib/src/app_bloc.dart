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

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matrix_image/matrix_image.dart';
import 'package:meta/meta.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/sentry.dart';
import 'package:pattle/src/ui/main/sync_bloc.dart';
import 'package:pattle/src/ui/util/room.dart';
import 'package:pattle/src/ui/util/user.dart';
import 'package:respect_24_hour/respect_24_hour.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pattle/src/di.dart' as di;
import 'package:url/url.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'storage.dart';

class AppBloc {
  Sentry sentry;
  final Storage storage;
  final String _mayReportCrashesStorageKey = 'may_report_crashes';

  static AppBloc _instance;

  FirebaseMessaging _firebase;

  AppBloc._(
      {@required this.storage,
      @required FirebaseMessaging firebase,
      @required FlutterLocalNotificationsPlugin notifications})
      : _firebase = firebase;

  factory AppBloc() => _instance;

  static Future<AppBloc> create() async {
    await DotEnv().load();

    final use24Hour = await Respect24Hour.get24HourFormat;
    di.registerUse24HourFormat(use24Hour);

    final notifications = FlutterLocalNotificationsPlugin();

    await notifications.initialize(
      InitializationSettings(
        AndroidInitializationSettings('ic_launcher_foreground'),
        IOSInitializationSettings(),
      ),
    );

    final channelId = 'pattle';
    final channelTitle = 'Pattle';
    final channelDescription = 'Receive message from Pattle';

    _instance = AppBloc._(
      storage: await Storage.open(),
      firebase: FirebaseMessaging()
        ..configure(
          onMessage: (Map<String, dynamic> message) async {
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

              await notifications.show(
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
                      conversationTitle: nameOf(room),
                      groupConversation: false,
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
          },
        ),
      notifications: notifications,
    );

    return _instance;
  }

  Future<void> setPusher() async {
    final user = di.getLocalUser();

    await user.pushers.set(
      HttpPusher(
        appId: 'im.pattle.app',
        appName: 'Pattle',
        deviceName: user.currentDevice.name,
        key: await _firebase.getToken(),
        url: Url.parse(DotEnv().env['PUSH_URL']),
      ),
    );
  }

  final _loggedInSubj = BehaviorSubject<bool>();
  Observable<bool> get loggedIn => _loggedInSubj.stream;

  Future<void> checkIfLoggedIn() async {
    di.registerStore();
    final localUser = await LocalUser.fromStore(di.getStore());

    if (localUser != null) {
      di.registerLocalUser(localUser);
    } else {
      // Delete db if user could not be retrieved from store
      await di.getStore().delete();
      di.registerStore();
    }

    final loggedIn = localUser != null;
    _loggedInSubj.add(loggedIn);

    if (loggedIn) {
      await notifyLogin();
    }
  }

  Future<void> notifyLogin() async {
    if (getMayReportCrashes() && sentry == null) {
      sentry = await Sentry.create();
    }

    await syncBloc.start();
  }

  void wrap(Function run) => runZoned<Future<void>>(
        () async => run(),
        onError: (error, stackTrace) => sentry?.reportError(error, stackTrace),
      );

  String get build => DotEnv().env['BUILD_TYPE'];

  bool _mayReportCrashes;
  bool getMayReportCrashes({bool lookInStorage = true}) {
    if (_mayReportCrashes == null && !lookInStorage) {
      setMayReportCrashes(build != 'fdroid');
      return _mayReportCrashes;
    } else if (_mayReportCrashes != null) {
      return _mayReportCrashes;
    } else {
      return storage[_mayReportCrashesStorageKey] as bool;
    }
  }

  void setMayReportCrashes(value) {
    _mayReportCrashes = value;
    storage[_mayReportCrashesStorageKey] = value;
  }
}
