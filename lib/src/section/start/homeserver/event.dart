import 'package:equatable/equatable.dart';

abstract class HomeserverEvent extends Equatable {
  const HomeserverEvent();
}

class ChangeHomeserver extends HomeserverEvent {
  final String url;

  /// Whether the homeserver was changed explicitly via advanced. We
  /// don't override it then.
  final bool viaAdvanced;

  ChangeHomeserver(this.url, {this.viaAdvanced = false});

  @override
  List<Object> get props => [url, viaAdvanced];
}

class ResetHomeserver extends HomeserverEvent {
  ResetHomeserver();

  @override
  List<Object> get props => [];
}
