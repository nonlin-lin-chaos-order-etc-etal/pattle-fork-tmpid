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
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:matrix_sdk/matrix_sdk.dart' as matrix;
import 'package:sentry/sentry.dart';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;

SentryClient _sentry;

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  if (_isInDebugMode) {
    print(stackTrace);
  } else {
    if (error is Response) {
      var body;
      try {
        body = json.decode(error.body);
      } on FormatException {
        body = error.body?.toString();
      }

      _sentry.capture(
        event: Event(
          exception: error,
          stackTrace: stackTrace,
          extra: {
            'status_code': error.statusCode,
            'body': body,
            'headers': error.headers
          }
        )
      );
    } else if (error is matrix.MatrixException) {
      _sentry.capture(
        event: Event(
          exception: error,
          stackTrace: stackTrace,
          extra: {
            'body': error.body,
          }
        )
      );
    } else {
      _sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}

bool get _isInDebugMode {
  bool inDebugMode = false;

  // Set to true if running debug mode (where asserts are evaluated)
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<Event> get _environment async {
  final deviceInfo = DeviceInfoPlugin();

  User user;
  Os os;
  Device device;

  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;

    user = User(
      id: info.androidId
    );

    os = Os(
      name: 'Android',
      version: info.version.release,
      build: info.version.sdkInt.toString(),
    );

    device = Device(
      model: info.model,
      manufacturer: info.manufacturer,
      brand: info.brand,
      simulator: !info.isPhysicalDevice
    );

  } else {
    final info = await deviceInfo.iosInfo;

    user = User(
      id: info.identifierForVendor
    );

    os = Os(
      name: 'iOS',
      version: '${info.systemName} ${info.systemVersion}',
    );

    device = Device(
      name: info.name,
      family: info.model,
      simulator: !info.isPhysicalDevice
    );
  }

  final packageInfo = await PackageInfo.fromPlatform();

  return Event(
    release: packageInfo.version,
    userContext: user,
    contexts: Contexts(
      device: device,
      os: os,
      app: App(
        build: packageInfo.buildNumber,
        buildType: DotEnv().env['BUILD_TYPE'],
      )
    )
  );
}

Future<void> init() async {
  await DotEnv().load();

  _sentry = SentryClient(
    dsn: DotEnv().env['SENTRY_DSN'],
    environmentAttributes: await _environment
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    if (_isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      // Report to zone
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
}

void wrap(Function run) {
  runZoned<Future<void>>(() async {
    run();
  }, onError: (error, stackTrace) {
    _reportError(error, stackTrace);
  });
}