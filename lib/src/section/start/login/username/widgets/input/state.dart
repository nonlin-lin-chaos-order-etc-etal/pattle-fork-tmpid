import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class UsernameState extends Equatable {
  final Username username;

  const UsernameState([this.username]);

  @override
  List<Object> get props => [username];
}

class UsernameIsEmpty extends UsernameState {
  const UsernameIsEmpty() : super();
}

class UsernameChanged extends UsernameState {
  const UsernameChanged([Username username]) : super(username);
}

class UsernameIsInvalid extends UsernameState {
  const UsernameIsInvalid() : super();
}

class UserIdIsInvalid extends UsernameState {
  const UserIdIsInvalid() : super();
}

class HostIsInvalid extends UsernameState {
  const HostIsInvalid() : super();
}
