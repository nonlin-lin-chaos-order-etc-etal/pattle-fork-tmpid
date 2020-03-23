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

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:matrix_sdk_sqflite/matrix_sdk_sqflite.dart';
import 'package:provider/provider.dart';

import 'auth/bloc.dart';

class Matrix {
  static final SqfliteStore store = SqfliteStore(path: 'pattle.sqlite');

  // Used for listening to auth state changes
  final AuthBloc _authBloc;

  LocalUser _user;
  LocalUser get user => _user;

  Matrix(this._authBloc) {
    _authBloc.listen(_processAuthState);
  }

  void _processAuthState(AuthState state) {
    if (state is Authenticated) {
      _user = state.user;
      _user.startSync();
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
