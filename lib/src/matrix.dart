// Copyright (C) 2019  wilko
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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as path;

import 'auth/bloc.dart';

class Matrix {
  static final MoorStore store = MoorStore(
    LazyDatabase(() async {
      final dataDir = await getApplicationDocumentsDirectory();
      return VmDatabase(File(path.join(dataDir.path, 'pattle.sqlite')));
    }),
  );

  // Used for listening to auth state changes
  final AuthBloc _authBloc;

  MyUser _user;
  MyUser get user => _user;

  final Completer<void> _firstSyncCompleter = Completer();
  Future<void> get firstSync => _firstSyncCompleter.future;

  final Completer<void> _userAvailable = Completer();
  Future<void> get userAvaible => _userAvailable.future;

  Matrix(this._authBloc) {
    _authBloc.listen(_processAuthState);
  }

  Future<void> _processAuthState(AuthState state) async {
    if (state is Authenticated) {
      _user = state.user;
      _userAvailable.complete();
      _user.startSync();

      _user = await _user.updates.firstSync.then((u) => u.user);
      _firstSyncCompleter.complete();

      _user.updates.listen((update) {
        _user = update.user;
      });
    }

    if (state is NotAuthenticated) {
      _user?.stopSync();
      _user = null;
    }
  }

  static Matrix of(BuildContext context) => Provider.of<Matrix>(
        context,
        listen: false,
      );
}
