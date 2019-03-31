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
import 'package:rxdart/rxdart.dart';
import 'package:pattle/src/di.dart' as di;

final main = MainBloc();

class MainBloc {
  
  PublishSubject<List<Room>> _roomsSubj = PublishSubject<List<Room>>();
  Observable<List<Room>> get rooms => _roomsSubj.stream;

  Observable<bool> syncStream;
  
  void startSync() {
    Observable(di.getLocalUser().sync())
        .listen((success) async {
          print('sync: $success');
          // Get all rooms and push them as a single list
          var rooms = List<Room>();
          if (success) {
            await for(Room room in di.getLocalUser().rooms.all()) {
              rooms.add(room);
            }
          }
          print('adding these rooms: ${rooms.length}');
          _roomsSubj.add(rooms);
        });
  }
}