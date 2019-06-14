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

Future<String> get _environment async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final ai = await deviceInfo.androidInfo;
    return 'Android ${ai.version.release}: ${ai.model}';
  } else {
    final ii = await deviceInfo.iosInfo;
    return 'iOS ${ii.systemName} ${ii.systemVersion}: ${ii.model}';
  }
}

Future<void> init() async {
  await DotEnv().load();

  final packageInfo = await PackageInfo.fromPlatform();
  _sentry = SentryClient(
    dsn: DotEnv().env['SENTRY_DSN'],
    environmentAttributes: Event(
      release: packageInfo.version,
      environment: await _environment
    )
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