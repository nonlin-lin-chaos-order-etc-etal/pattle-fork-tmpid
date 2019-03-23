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

import 'package:matrix/matrix.dart';
import 'package:pattle/src/data/homeserver.dart';
import 'package:rxdart/rxdart.dart';

final start = StartBloc();

class StartBloc {

  Homeserver _homeserver = homeserver(uri: Uri.parse("https://matrix.org"));

  final _isUsernameAvailableSubj = BehaviorSubject<bool>();
  Observable<bool> get isUsernameAvailable => _isUsernameAvailableSubj.stream;

  final _isCheckingForUsernameSubj = BehaviorSubject<bool>();
  Observable<bool> get isCheckingForUsername =>
      _isCheckingForUsernameSubj.stream.distinct();

  void checkUsernameAvailability(String username) {
    _isCheckingForUsernameSubj.add(true);

    var user;

    // Check if there is a ':' in the username,
    // if so, treat it as a full Matrix ID (without or without '@').
    // Otherwise use the local part (with or without '@').
    // So, accept all of these formats:
    // @joe:matrix.org
    // joe:matrix.org
    // joe
    // @joe
    if (username.contains(':')) {
      var split = username.split(':');
      String server = split[1];

      try {
        var serverUri = Uri.parse("https://$server");
        _homeserver = homeserver(uri: serverUri);

        // Add an '@' if the username does not have one, to allow
        // for this input: 'pit:pattle.im'
        if (!username.startsWith('@')) {
          username = "@$username";
        }

        if (!UserId.isValidFullyQualified(username)) {
          _isUsernameAvailableSubj.addError(InvalidUserIdException());
          return;
        }

        user = UserId(username).username;
      } on FormatException {
        _isUsernameAvailableSubj.addError(InvalidHostnameException());
        return;
      }
    } else {
      if (username.startsWith('@')) {
        username = username.substring(1).toLowerCase();
      }

      if (!Username.isValid(username)) {
        _isUsernameAvailableSubj.addError(InvalidUsernameException());
        return;
      }

      user = Username(username);
    }

    _isUsernameAvailableSubj.addStream(
        _homeserver.isUsernameAvailable(user)
          .whenComplete(() {
            _isCheckingForUsernameSubj.add(false);
          })
        .asStream()
    );
  }
}

class InvalidUserIdException implements Exception { }

class InvalidHostnameException implements Exception { }