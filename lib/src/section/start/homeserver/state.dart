import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class HomeserverState extends Equatable {
  final Homeserver homeserver;
  final bool setViaAdvanced;

  const HomeserverState(this.homeserver, {this.setViaAdvanced = false});

  HomeserverState.copyFrom(HomeserverState state)
      : homeserver = state.homeserver,
        setViaAdvanced = state.setViaAdvanced;

  @override
  List<Object> get props => [homeserver];
}

class DefaultHomeserverState extends HomeserverState {
  DefaultHomeserverState() : super(Homeserver(Uri.parse('https://matrix.org')));
}

class CheckingHomeserver extends HomeserverState {
  CheckingHomeserver(HomeserverState state) : super.copyFrom(state);
}

class HomeserverChanged extends HomeserverState {
  HomeserverChanged(
    Homeserver homeserver, {
    @required bool viaAdvanced,
  }) : super(homeserver, setViaAdvanced: viaAdvanced);
}

class HomeserverIsInvalid extends HomeserverState {
  HomeserverIsInvalid(HomeserverState state)
      : super(
          null,
          setViaAdvanced: state.setViaAdvanced,
        );
}
