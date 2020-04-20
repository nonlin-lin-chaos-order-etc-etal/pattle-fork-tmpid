import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  final UsernameState usernameState;
  final HomeserverState homeserverState;

  LoginState({@required this.usernameState, @required this.homeserverState});

  LoginState.from(LoginState state)
      : this(
          usernameState: state.usernameState,
          homeserverState: state.homeserverState,
        );

  @override
  List<Object> get props => [usernameState, homeserverState];
}

class NotLoggedIn extends LoginState {
  NotLoggedIn({
    UsernameState usernameState,
    HomeserverState homeserverState,
  }) : super(usernameState: usernameState, homeserverState: homeserverState);

  NotLoggedIn.from(LoginState state) : super.from(state);

  NotLoggedIn copyWith({
    UsernameState usernameState,
    HomeserverState homeserverState,
  }) {
    return NotLoggedIn(
      usernameState: usernameState ?? this.usernameState,
      homeserverState: homeserverState ?? this.homeserverState,
    );
  }

  bool get canLogin => usernameState.isValid && homeserverState.isValid;
}

class LoggingIn extends LoginState {
  LoggingIn(LoginState state) : super.from(state);
}

class LoginFailed extends LoginState {
  LoginFailed.from(LoginState state) : super.from(state);
}

class LoginSuccessful extends LoginState {
  final MyUser user;

  LoginSuccessful.from(LoginState state, {this.user}) : super.from(state);

  @override
  List<Object> get props => super.props..add(user);
}

class HomeserverState extends Equatable {
  final Homeserver value;
  final bool isSetExplicitly;
  final bool isValid;

  const HomeserverState({
    this.value,
    this.isSetExplicitly = false,
    this.isValid = true,
  });

  HomeserverState.initial()
      : this(
          value: Homeserver(Uri.parse('https://matrix.org')),
        );

  HomeserverState copyWith({
    Homeserver value,
    bool isSetExplicitly,
    bool isValid,
  }) {
    return HomeserverState(
      value: value ?? this.value,
      isSetExplicitly: isSetExplicitly ?? this.isSetExplicitly,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [value?.url, isSetExplicitly, isValid];
}

class UsernameState extends Equatable {
  final Username value;
  final InvalidReason invalidReason;

  bool get isValid => invalidReason == null;

  const UsernameState({this.value, this.invalidReason});

  /// If [isValid] is true, will clear [invalidReason].
  UsernameState copyWith({
    Username value,
    InvalidReason invalidReason,
    bool isValid = false,
  }) {
    return UsernameState(
      value: value ?? this.value,
      invalidReason: isValid ? null : invalidReason ?? this.invalidReason,
    );
  }

  @override
  List<Object> get props => [value, invalidReason];
}

enum InvalidReason {
  empty,
  username,
  userId,
  host,
}
