import 'package:equatable/equatable.dart';
import 'package:pattle/src/section/main/models/chat_message.dart';

abstract class ImageState extends Equatable {
  @override
  List<Object> get props => [];
}

class ImagesUninitialized extends ImageState {}

class ImagesLoading extends ImageState {}

class ImagesLoaded extends ImageState {
  final List<ChatMessage> messages;

  ImagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}
