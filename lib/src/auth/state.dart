import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:meta/meta.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class Unchecked extends AuthState {}

class Authenticated extends AuthState {
  final LocalUser user;
  final bool fromStore;

  Authenticated(this.user, {@required this.fromStore});
}

class NotAuthenticated extends AuthState {}
