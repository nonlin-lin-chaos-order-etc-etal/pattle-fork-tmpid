import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/section/start/login/bloc.dart';

import '../../../../homeserver/bloc.dart';
import 'event.dart';
import 'state.dart';

export 'event.dart';
export 'state.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  final LoginBloc _loginBloc;
  final HomeserverBloc _homeserverBloc;

  StreamSubscription _subscription;

  UsernameBloc(this._loginBloc, this._homeserverBloc) {
    _subscription = _homeserverBloc.listen((state) {
      if (state is HomeserverIsInvalid && !state.setViaAdvanced) {
        add(NotifyHomeserverIsInvalid());
      }
    });
  }

  @override
  UsernameState get initialState => UsernameIsEmpty();

  @override
  Stream<UsernameState> mapEventToState(
    UsernameEvent event,
  ) async* {
    if (event is NotifyHomeserverIsInvalid) {
      yield HostIsInvalid();
    }

    if (event is ChangeUsername) {
      var input = event.username;
      if (input == null || input.isEmpty) {
        yield UsernameIsEmpty();
        _resetUsername();
        _resetHomeserver();
        return;
      }

      // Check if there is a ':' in the username,
      // if so, treat it as a full Matrix ID (with or without '@').
      // Otherwise use the local part (with or without '@').
      // So, accept all of these formats:
      // @joe:matrix.org
      // joe:matrix.org
      // joe
      // @joe
      if (input.contains(':')) {
        final split = input.split(':');
        String server = split[1];

        _homeserverBloc.add(
          ChangeHomeserver(
            "https://$server",
            viaAdvanced: false,
          ),
        );

        // Add an '@' if the username does not have one, to allow
        // for this input: 'pit:pattle.im'
        if (!input.startsWith('@')) {
          input = "@$input";
        }

        if (!UserId.isValidFullyQualified(input)) {
          yield UserIdIsInvalid();
          _resetUsername();
          _resetHomeserver();
          return;
        }

        yield* _update(UserId(input).username);
      } else {
        _resetHomeserver();

        if (input.startsWith('@')) {
          input = input.substring(1).toLowerCase();
        }

        if (!Username.isValid(input)) {
          yield UsernameIsInvalid();
          _resetUsername();
          return;
        }

        yield* _update(Username(input));
      }
    }
  }

  Stream<UsernameState> _update(Username username) async* {
    _loginBloc.add(UsernameUpdated(username));
    yield UsernameChanged(username);
  }

  void _resetUsername() {
    _loginBloc.add(UsernameUpdated(null));
  }

  void _resetHomeserver() {
    _homeserverBloc.add(ResetHomeserver());
  }

  @override
  Future<void> close() async {
    await super.close();
    await _subscription.cancel();
  }
}
