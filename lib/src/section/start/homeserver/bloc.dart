import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import '../login/bloc.dart';

import 'event.dart';
import 'state.dart';

export 'event.dart';
export 'state.dart';

class HomeserverBloc extends Bloc<HomeserverEvent, HomeserverState> {
  final LoginBloc _loginBloc;

  HomeserverBloc(this._loginBloc);

  @override
  HomeserverState get initialState => DefaultHomeserverState();

  @override
  Stream<HomeserverState> mapEventToState(
    HomeserverEvent event,
  ) async* {
    if (event is ChangeHomeserver) {
      if (state.setViaAdvanced && !event.viaAdvanced) {
        return;
      }

      final url = Uri.tryParse(event.url);

      if (url == null ||
          !url.isAbsolute ||
          url.authority == null ||
          url.authority.isEmpty) {
        yield HomeserverIsInvalid(state);
        return;
      }

      if (url == state.homeserver?.url) {
        return;
      }

      Homeserver homeserver;

      try {
        homeserver = await Homeserver.fromWellKnown(url);
      } on Exception {
        homeserver = Homeserver(url);
      }

      yield HomeserverChanged(
        homeserver,
        viaAdvanced: event.viaAdvanced,
      );

      _loginBloc.add(HomeserverUpdated(homeserver));
    }

    if (event is ResetHomeserver && !state.setViaAdvanced) {
      _loginBloc.add(HomeserverUpdated(null));
    }
  }
}
