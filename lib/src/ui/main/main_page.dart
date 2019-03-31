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
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/main/main_bloc.dart';
import 'package:pattle/src/ui/resources/localizations.dart';

class MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();

    main.startSync();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l(context).appName)
      ),
      body: Container(
        child: Scrollbar(
          child: StreamBuilder<List<Room>>(
            stream: main.rooms,
            builder: (BuildContext context, AsyncSnapshot<List<Room>> snapshot) {
              print('connectionState: ${snapshot.connectionState}');
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container();
                case ConnectionState.active:
                case ConnectionState.done:
                  var rooms = snapshot.data;
                  print('LENGTH: ${rooms.length}');
                  return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        Room room = rooms[index];
                        return ListTile(
                          title: Text(room.name ?? room.id.toString()),
                        );
                      }
                  );
              }
            }
          )
    ),
      )
    );
  }

}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}