import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Check extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final MyUser user;

  LoggedIn(this.user);

  @override
  List<Object> get props => [user];
}
