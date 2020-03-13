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

import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:matrix_sdk/matrix_sdk.dart' as matrix;
import 'package:sentry/sentry.dart';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;

import '../app.dart' as pattle;
import '../storage.dart';

import 'event.dart';
import 'state.dart';

export 'event.dart';
export 'state.dart';

class SentryBloc extends Bloc<SentryEvent, SentryState> {
  SentryClient _client;
  Storage _storage;

  Future<void> _reportError(dynamic error, dynamic stackTrace) async {
    if (!state.mayReportCrashes) {
      return;
    }

    print('Caught error: $error');
    if (_isInDebugMode) {
      if (error is Response) {
        print('statusCode: ${error.statusCode}');
        print('headers: ${error.headers}');
        print('body: ${error.body}');
      } else if (error is matrix.MatrixException) {
        print('body: ${error.body}');
      }

      if (stackTrace != null) {
        print(stackTrace);
      }
    } else {
      if (error is Response) {
        var body;
        try {
          body = json.decode(error.body);
        } on FormatException {
          body = error.body?.toString();
        }

        await _client.capture(
          event: Event(
            exception: error,
            stackTrace: stackTrace,
            extra: {
              'status_code': error.statusCode,
              'headers': error.headers,
              'body': body,
            },
          ),
        );
      } else if (error is matrix.MatrixException) {
        await _client.capture(
          event: Event(
            exception: error,
            stackTrace: stackTrace,
            extra: {
              'body': error.body,
            },
          ),
        );
      } else {
        await _client.captureException(
          exception: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  void wrap(Function run) => runZoned<Future<void>>(
        () async => run(),
        onError: (error, stackTrace) => _reportError(error, stackTrace),
      );

  static bool get _isInDebugMode {
    bool inDebugMode = false;

    // Set to true if running debug mode (where asserts are evaluated)
    assert(inDebugMode = true);

    return inDebugMode;
  }

  static Future<Event> get _environment async {
    final deviceInfo = DeviceInfoPlugin();

    User user;
    OperatingSystem os;
    Device device;

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;

      user = User(id: info.androidId);

      os = OperatingSystem(
        name: 'Android',
        version: info.version.release,
        build: info.version.sdkInt.toString(),
      );

      device = Device(
        model: info.model,
        manufacturer: info.manufacturer,
        brand: info.brand,
        simulator: !info.isPhysicalDevice,
      );
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;

      user = User(id: info.identifierForVendor);

      os = OperatingSystem(
        name: 'iOS',
        version: info.systemVersion,
      );

      device = Device(
        family: info.model,
        model: info.utsname.machine,
        simulator: !info.isPhysicalDevice,
      );
    }

    final packageInfo = await PackageInfo.fromPlatform();

    return Event(
      release: packageInfo.version,
      userContext: user,
      environment: 'production',
      contexts: Contexts(
        device: device,
        operatingSystem: os,
        app: App(
          build: packageInfo.buildNumber,
          buildType: pattle.App.buildType,
        ),
      ),
    );
  }

  @override
  SentryState get initialState => NotInitialized();

  @override
  Stream<SentryState> mapEventToState(SentryEvent event) async* {
    if (event is Initialize) {
      if (!state.mayReportCrashes) {
        return;
      }

      _client = SentryClient(
        dsn: DotEnv().env['SENTRY_DSN'],
        environmentAttributes: await _environment,
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        if (_isInDebugMode) {
          FlutterError.dumpErrorToConsole(details);
        } else {
          // Report to zone
          Zone.current.handleUncaughtError(details.exception, details.stack);
        }
      };

      yield Initialized(mayReportCrashes: state.mayReportCrashes);
    }

    if (event is ChangeMayReportCrashes) {
      if (_storage == null) {
        _storage = await Storage.load();
      }

      _storage.mayReportCrashes = event.mayReportCrashes;

      // Initialize if may report crashes was false before but now true,
      // otherwise just reyield the updated current state
      if (!state.mayReportCrashes &&
          event.mayReportCrashes &&
          state is NotInitialized) {
        yield NotInitialized(mayReportCrashes: event.mayReportCrashes);
        add(Initialize());
      } else if (state is NotInitialized) {
        yield NotInitialized(mayReportCrashes: event.mayReportCrashes);
      } else if (state is Initialized) {
        if (state is NotInitialized) {
          yield Initialized(mayReportCrashes: event.mayReportCrashes);
        }
      }
    }
  }
}
