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

import 'dart:ui';

import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:meta/meta.dart';
import 'package:pattle/src/ui/resources/theme.dart';

const _limit = 28;
String _limited(String name) {
  if (name != null && name.length >= _limit) {
    return name.substring(0, _limit) + ' ...';
  } else {
    return name;
  }
}

String displayNameOf(User user)
  => _limited(user.name) ?? user.id.toString().split(':')[0];

String displayNameOrId(UserId id, String name)
  => _limited(name) ?? id.toString().split(':')[0];

Color colorOf(User user) => LightColors.userColors[
    user.id.hashCode % LightColors.userColors.length
  ];