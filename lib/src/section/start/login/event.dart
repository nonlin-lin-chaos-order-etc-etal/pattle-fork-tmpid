import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {
  final String password;

  Login({
    @required this.password,
  });

  @override
  List<Object> get props => [password];
}

class UsernameUpdated extends LoginEvent {
  final Username username;

  UsernameUpdated(this.username);

  @override
  List<Object> get props => [username];
}

class HomeserverUpdated extends LoginEvent {
  final Homeserver homeserver;

  HomeserverUpdated(this.homeserver);

  @override
  List<Object> get props => [homeserver];
}
