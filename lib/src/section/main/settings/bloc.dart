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

import 'package:bloc/bloc.dart';
import 'package:pattle/src/section/main/models/chat_member.dart';

import '../../../matrix.dart';

import 'event.dart';
export 'event.dart';

import 'state.dart';
export 'state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Matrix _matrix;

  SettingsBloc(this._matrix);

  @override
  SettingsState get initialState => SettingsInitialized(
        ChatMember(
          _matrix.user,
          name: _matrix.user.name,
          isYou: true,
        ),
      );

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is UpdateDisplayName) {
      yield UpdatingDisplayName(state.me);

      await _matrix.user.setName(event.name);

      yield DisplayNameUpdated(state.me);
    }
  }
}
