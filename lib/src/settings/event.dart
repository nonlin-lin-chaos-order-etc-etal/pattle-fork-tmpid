import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class UpdateSetting<T> extends SettingsEvent {
  final T value;

  UpdateSetting(this.value);

  @override
  List<Object> get props => [value];
}

class UpdateThemeBrightness extends UpdateSetting<Brightness> {
  UpdateThemeBrightness(Brightness setting) : super(setting);
}
