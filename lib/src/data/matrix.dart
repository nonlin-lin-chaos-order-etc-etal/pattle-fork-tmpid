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

Homeserver _homeserver;

/// Homeserver the app uses. If [uri] is given, replace the instance
/// with a new homeserver.
Homeserver homeserver({Uri uri}) {
  if (_homeserver == null && uri == null) {
    throw ArgumentError("Homeserver is not initialized and no uri was given");
  }

  if (uri != null) {
    _homeserver = Homeserver(uri);
  }

  return _homeserver;
}

/// The user this app manages.
LocalUser localUser;