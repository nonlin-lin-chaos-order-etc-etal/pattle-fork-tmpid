import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateDisplayName extends SettingsEvent {
  final String name;

  UpdateDisplayName(this.name);

  @override
  List<Object> get props => [name];
}
