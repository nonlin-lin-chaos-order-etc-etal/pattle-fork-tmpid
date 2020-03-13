import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import '../../../auth/bloc.dart';
import '../../../matrix.dart';
import '../../../sentry/bloc.dart';
import 'event.dart';
import 'state.dart';

export 'event.dart';
export 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authBloc;
  final SentryBloc _sentryBloc;

  LoginBloc(this._authBloc, this._sentryBloc);

  @override
  LoginState get initialState => NotLoggedIn(
        homeserver: Homeserver(Uri.parse('https://matrix.org')),
      );

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is UsernameUpdated) {
      yield NotLoggedIn(username: event.username, homeserver: state.homeserver);
    }

    if (event is HomeserverUpdated) {
      yield NotLoggedIn(username: state.username, homeserver: event.homeserver);
    }

    if (event is Login) {
      yield LoggingIn(state);
      try {
        final user = await state.homeserver.login(
          state.username,
          event.password,
          store: Matrix.store,
          device: Device(
            name: 'Pattle ${Platform.isAndroid ? 'Android' : 'iOS'}',
          ),
        );

        _authBloc.add(LoggedIn(user));
        _sentryBloc.add(Initialize());
        yield LoginSuccessful(user);
      } on ForbiddenException {
        yield LoginFailed(state);
      } on SocketException {
        //yield ConnectionError(state);
      }
    }
  }
}
