import 'package:equatable/equatable.dart';

abstract class UsernameEvent extends Equatable {
  const UsernameEvent();
}

class ChangeUsername extends UsernameEvent {
  final String username;

  ChangeUsername(this.username);

  @override
  List<Object> get props => [username];
}

class NotifyHomeserverIsInvalid extends UsernameEvent {
  NotifyHomeserverIsInvalid();

  @override
  List<Object> get props => [];
}
