// Copyright (C) 2019  Nathan van Beelen (CLA signed)
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

import 'package:bloc/bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import '../../models/chat_message.dart';
import '../../../../matrix.dart';

import 'event.dart';
import 'state.dart';

export 'state.dart';
export 'event.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final Matrix _matrix;
  Room _room;

  StreamSubscription _sub;

  ImageBloc(this._matrix, this._room) {
    _sub = _matrix.user.updates.onlySync.listen((update) {
      _room = update.user.rooms[_room.id];
      add(FetchImages());
    });
  }

  @override
  ImageState get initialState => ImagesUninitialized();

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is FetchImages) {
      yield ImagesLoading();
      final imageMessageEvents = <ImageMessageEvent>[];

      final update = await _room.timeline.load();
      _room = update.user.rooms[_room.id];

      for (final event in _room.timeline) {
        if (event is ImageMessageEvent) {
          imageMessageEvents.add(event);
        }
      }

      yield ImagesLoaded(
        imageMessageEvents.map(
          (i) => ChatMessage(
            _room,
            i,
            isMe: (id) => id == _matrix.user.id,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await super.close();
    await _sub.cancel();
  }
}
