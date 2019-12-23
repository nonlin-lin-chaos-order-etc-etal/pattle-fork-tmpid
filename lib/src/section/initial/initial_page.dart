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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pattle/src/app.dart';

import '../../app_bloc.dart';

class InitialPageState extends State<InitialPage> {
  final AppBloc bloc = AppBloc();
  StreamSubscription<bool> subscription;

  @override
  void initState() {
    super.initState();

    subscription = bloc.loggedIn.listen((loggedIn) {
      var route;

      if (loggedIn) {
        route = Routes.chats;
      } else {
        route = Routes.start;
      }

      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    });

    bloc.checkIfLoggedIn();
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InitialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitialPageState();
}
