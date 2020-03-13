import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  final Username username;
  final Homeserver homeserver;

  LoginState({@required this.username, @required this.homeserver});

  @override
  List<Object> get props => [username, homeserver];
}

class NotLoggedIn extends LoginState {
  NotLoggedIn({
    Username username,
    Homeserver homeserver,
  }) : super(username: username, homeserver: homeserver);

  bool get canLogin => username != null && homeserver != null;
}

class LoggingIn extends LoginState {
  LoggingIn(LoginState state)
      : super(
          username: state.username,
          homeserver: state.homeserver,
        );
}

class LoginFailed extends LoginState {
  LoginFailed(LoginState state)
      : super(
          username: state.username,
          homeserver: state.homeserver,
        );
}

class LoginSuccessful extends LoginState {
  final LocalUser user;

  LoginSuccessful(this.user);

  @override
  List<Object> get props => super.props..add(user);
}
