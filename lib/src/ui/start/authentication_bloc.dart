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

final auth = AuthenticationBloc();

class AuthenticationBloc {

  final isUsernameAvailableSubj = BehaviorSubject<bool>();
  Observable<bool> get isUsernameAvailable => isUsernameAvailableSubj.stream;

  void checkUsernameAvailability(String username) {
    var hs = homeserver(uri: Uri.parse("https://matrix.org"));

    if (!Username.isValid(username)) {
      isUsernameAvailableSubj.addError(InvalidUsernameException());
      return;
    }

    isUsernameAvailableSubj.addStream(
        hs.isUsernameAvailable(Username(username)).asStream()
    );
  }
}