import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SettingsState extends Equatable {
  final Brightness themeBrightness;

  SettingsState({
    @required this.themeBrightness,
  });

  @override
  List<Object> get props => [themeBrightness];

  SettingsState copyWith({
    Brightness themeBrightness,
  }) {
    return SettingsState(
      themeBrightness: themeBrightness ?? this.themeBrightness,
    );
  }
}
