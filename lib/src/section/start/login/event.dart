import 'package:equatable/equatable.dart';
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

class ChangeUsername extends LoginEvent {
  final String username;

  ChangeUsername(this.username);

  @override
  List<Object> get props => [username];
}

class ChangeHomeserver extends LoginEvent {
  final String url;

  /// Whether the homeserver was changed explicitly. We
  /// don't override it then.
  final bool setExplicitly;

  ChangeHomeserver(this.url, {this.setExplicitly = false});

  @override
  List<Object> get props => [url, setExplicitly];
}

class PasswordChanged extends LoginEvent {}
