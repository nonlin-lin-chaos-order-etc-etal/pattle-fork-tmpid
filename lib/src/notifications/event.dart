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
