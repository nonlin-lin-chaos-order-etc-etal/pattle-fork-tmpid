import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class ImageState extends Equatable {
  @override
  List<Object> get props => [];
}

class ImagesUninitialized extends ImageState {}

class ImagesLoading extends ImageState {}

class ImagesLoaded extends ImageState {
  final List<ImageMessageEvent> events;

  ImagesLoaded(this.events);

  @override
  List<Object> get props => [events];
}
