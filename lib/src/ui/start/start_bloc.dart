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

final auth = StartBloc();

class StartBloc {

  Homeserver _homeserver = homeserver(uri: Uri.parse("https://matrix.org"));

  final isUsernameAvailableSubj = BehaviorSubject<bool>();
  Observable<bool> get isUsernameAvailable => isUsernameAvailableSubj.stream;

  void checkUsernameAvailability(String username) {
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
          isUsernameAvailableSubj.addError(InvalidUserIdException());
          return;
        }

        user = UserId(username).username;
      } on FormatException {
        isUsernameAvailableSubj.addError(InvalidHostnameException());
        return;
      }
    } else {
      if (username.startsWith('@')) {
        username = username.substring(1).toLowerCase();
      }

      if (!Username.isValid(username)) {
        isUsernameAvailableSubj.addError(InvalidUsernameException());
        return;
      }

      user = Username(username);
    }

    isUsernameAvailableSubj.addStream(
        _homeserver.isUsernameAvailable(user).asStream()
    );
  }
}

class InvalidUserIdException implements Exception { }

class InvalidHostnameException implements Exception { }