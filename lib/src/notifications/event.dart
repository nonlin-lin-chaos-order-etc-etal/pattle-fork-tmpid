// Copyright (C) 2020  Wilko Manger
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

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class NotificationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RemoveNotifications extends NotificationsEvent {
  final RoomId roomId;
  final EventId until;

  RemoveNotifications({@required this.roomId, @required this.until});

  @override
  List<Object> get props => [roomId, until];
}

/// Hide incoming notifications for the given [roomId].
class HideNotifications extends NotificationsEvent {
  final RoomId roomId;

  HideNotifications(this.roomId);

  @override
  List<Object> get props => [roomId];
}

/// Unhide incoming notifications which were previously hidden
/// (using [HideNotifications]) for the given [roomId].
class UnhideNotifications extends NotificationsEvent {
  final RoomId roomId;

  UnhideNotifications(this.roomId);

  @override
  List<Object> get props => [roomId];
}
