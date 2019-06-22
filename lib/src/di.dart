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

import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:matrix_sdk_sqflite/matrix_sdk_sqflite.dart';
import 'package:injector/injector.dart';
import 'package:url/url.dart';

final inj = Injector();

Homeserver getHomeserver() => inj.getDependency<Homeserver>();

void registerHomeserver(Homeserver homeserver) {
  inj.registerSingleton<Homeserver>((_)
    => homeserver, override: true);
}

Future<void> registerHomeserverWith(Url url) async {
  Homeserver hs;
  try {
    hs = await Homeserver.fromWellKnown(url);
  } on WellKnownFailPromptException {
    hs = Homeserver(url);
  }

  inj.registerSingleton<Homeserver>((_) => hs, override: true);
}

Store getStore() => inj.getDependency<Store>();
void registerStore() {
  final store = SqfliteStore(path: 'pattle.sqlite');

  inj.registerSingleton<Store>((_)
    => store, override: true);
}


LocalUser getLocalUser() => inj.getDependency<LocalUser>();

void registerLocalUser(LocalUser user) {
  inj.registerSingleton<LocalUser>((_) => user, override: true);
  registerHomeserver(user.homeserver);
}

const use24HourDependencyName = 'use24HourFormat';
bool getUse24HourFormat() => inj.getDependency<bool>(
  dependencyName: use24HourDependencyName
) ?? false;

void registerUse24HourFormat(bool use24HourFormat) {
  inj.registerSingleton((_) => use24HourFormat,
    override: true,
    dependencyName: use24HourDependencyName
  );
}