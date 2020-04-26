import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateDisplayName extends ProfileEvent {
  final String name;

  UpdateDisplayName(this.name);

  @override
  List<Object> get props => [name];
}
