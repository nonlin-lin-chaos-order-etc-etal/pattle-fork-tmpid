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

import 'package:pattle/src/di.dart' as di;
import 'package:rxdart/rxdart.dart';

import '../../../bloc.dart';
import '../../../request_state.dart';

class SettingsBloc extends Bloc {
  final me = di.getLocalUser();

  static SettingsBloc _instance = SettingsBloc._();

  SettingsBloc._();

  factory SettingsBloc() => _instance;

  PublishSubject<RequestState> _displayNameSubj =
      PublishSubject<RequestState>();
  Stream<RequestState> get displayNameStream => _displayNameSubj.stream;

  Future<void> setDisplayName(String name) async {
    _displayNameSubj.add(RequestState.active);

    await me.setName(name).catchError(_displayNameSubj.addError);

    _displayNameSubj.add(RequestState.success);
  }
}
