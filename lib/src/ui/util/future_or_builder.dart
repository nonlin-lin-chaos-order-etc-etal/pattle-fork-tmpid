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

import 'package:flutter/widgets.dart';

/// Builds immediately if the `FutureOr` is the `T`,
/// other wise build a `FutureBuilder`.
class FutureOrBuilder<T> extends StatelessWidget {
  final FutureOr<T> futureOr;
  final AsyncWidgetBuilder<T> builder;

  const FutureOrBuilder({
    Key key,
    @required this.futureOr,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (futureOr is T) {
      return builder(
        context,
        AsyncSnapshot.withData(
          ConnectionState.done,
          futureOr,
        ),
      );
    } else {
      return FutureBuilder<T>(
        future: futureOr,
        builder: builder,
      );
    }
  }
}
