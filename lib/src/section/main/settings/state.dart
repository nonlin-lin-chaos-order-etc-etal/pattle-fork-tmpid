import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsInitialized extends SettingsState {}

class UpdatingDisplayName extends SettingsState {}

class DisplayNameUpdated extends SettingsState {}
