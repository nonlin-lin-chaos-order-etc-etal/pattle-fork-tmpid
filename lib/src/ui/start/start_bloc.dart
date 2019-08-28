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

import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:meta/meta.dart';
import 'package:pattle/src/di.dart' as di;
import 'package:rxdart/rxdart.dart';
import 'package:url/url.dart';
import 'dart:io';
import 'package:pedantic/pedantic.dart';

import '../../app_bloc.dart';
import '../bloc.dart';

typedef Request = void Function(Function addError);
typedef Check = bool Function(Function addError);

class StartBloc extends Bloc {
  static StartBloc _instance;

  StartBloc._() {
    setHomeserverUrl("https://matrix.org");
  }

  factory StartBloc({bool replace = false}) {
    if (_instance == null || replace) {
      _instance = StartBloc._();
    }

    return _instance;
  }
  final _homeserverChangedSubj = BehaviorSubject<bool>();
  Observable<bool> get homeserverChanged => _homeserverChangedSubj.stream;

  bool homeserverSetViaAdvanced = false;
  Homeserver get homeserver => di.getHomeserver();

  Url _userIdDomain;
  Url get userIdDomain => _userIdDomain;

  Username _username;
  Username get username => _username;

  /// Duration after which a progress indicator should be shown.
  static const loadingTime = Duration(seconds: 3);

  Future<void> _setHomeserver(Url url) async {
    await di.registerHomeserverWith(url);
    _homeserverChangedSubj.add(true);
  }

  Future<void> setHomeserverUrl(String url, {bool allowMistake = false}) async {
    try {
      if (!url.startsWith('https://')) {
        url = 'https://$url';
      }
      final parsedUrl = Url.parse(url);

      await _setHomeserver(parsedUrl);
      _userIdDomain = parsedUrl;
    } on FormatException {
      if (!allowMistake) {
        _homeserverChangedSubj.addError(InvalidHostnameException());
      }
    } on SocketException {
      if (!allowMistake) {
        rethrow;
      }
    }
  }

  final _isUsernameAvailableSubj = BehaviorSubject<RequestState>();
  Observable<RequestState> get isUsernameAvailable =>
      _isUsernameAvailableSubj.stream;

  static bool _defaultValidate(Function addError) => true;
  Future<void> _do({
    @required BehaviorSubject<RequestState> subject,
    Function validate = _defaultValidate,
    @required Request request,
  }) async {
    subject.add(RequestState.active);

    // If after three seconds it's still active, change state to
    // 'stillActive'.
    unawaited(Future.delayed(loadingTime).then((_) async {
      if (subject.value == RequestState.active) {
        subject.add(RequestState.stillActive);
      }
    }));

    final addError = (error) {
      subject.addError(error);
    };

    final validated = validate(addError);

    if (!validated) {
      return;
    }

    request(addError);
  }

  Future<void> checkUsernameAvailability(String username) async {
    await _do(
      subject: _isUsernameAvailableSubj,
      validate: (addError) {
        if (username == null) {
          return false;
        }

        // Check if there is a ':' in the username,
        // if so, treat it as a full Matrix ID (with or without '@').
        // Otherwise use the local part (with or without '@').
        // So, accept all of these formats:
        // @joe:matrix.org
        // joe:matrix.org
        // joe
        // @joe
        if (username.contains(':')) {
          final split = username.split(':');
          String server = split[1];

          try {
            if (!homeserverSetViaAdvanced) {
              final serverUrl = Url.parse("https://$server");
              _setHomeserver(serverUrl);
            }

            // Add an '@' if the username does not have one, to allow
            // for this input: 'pit:pattle.im'
            if (!username.startsWith('@')) {
              username = "@$username";
            }

            if (!UserId.isValidFullyQualified(username)) {
              addError(InvalidUserIdException());
              return false;
            }

            _username = UserId(username).username;
          } on FormatException {
            addError(InvalidHostnameException());
            return false;
          }

          return true;
        } else {
          if (username.startsWith('@')) {
            username = username.substring(1).toLowerCase();
          }

          if (!Username.isValid(username)) {
            addError(InvalidUsernameException());
            return false;
          }

          _username = Username(username);

          return true;
        }
      },
      request: (addError) {
        homeserver.isUsernameAvailable(_username).then((available) {
          _isUsernameAvailableSubj.add(RequestSuccessState(data: available));
        }).catchError((error) => _isUsernameAvailableSubj.addError(error));
      },
    );
  }

  final _loginSubj = BehaviorSubject<RequestState>();
  Observable<RequestState> get loginStream => _loginSubj.stream;

  void login(String password) {
    _do(
      subject: _loginSubj,
      request: (addError) {
        homeserver
            .login(_username, password,
                store: di.getStore(),
                device: Device(
                  name: 'Pattle ${Platform.isAndroid ? 'Android' : 'iOS'}',
                ))
            .then((user) {
          di.registerLocalUser(user);
          AppBloc().notifyLogin();
          _loginSubj.add(RequestState.success);
        }).catchError((error) => _loginSubj.addError(error));
      },
    );
  }

  @override
  void dispose() {
    _homeserverChangedSubj.close();
    _loginSubj.close();
    _isUsernameAvailableSubj.close();
  }
}

class RequestState {
  final int _value;

  const RequestState(int value) : _value = value;

  static const none = RequestState(0);
  static const active = RequestState(1);
  static const stillActive = RequestState(2);
  static const success = RequestSuccessState();

  @override
  bool operator ==(other) {
    if (other is RequestState) {
      return other._value == this._value;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _value.hashCode;
}

class RequestSuccessState<T> extends RequestState {
  final T data;

  const RequestSuccessState({this.data}) : super(3);
}

class InvalidUserIdException implements Exception {}

class InvalidHostnameException implements Exception {}
