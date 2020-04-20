import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class NotificationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoggedIn extends NotificationsEvent {
  final MyUser user;

  LoggedIn(this.user);

  @override
  List<Object> get props => [user];
}
