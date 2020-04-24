import 'package:equatable/equatable.dart';

import '../../models/chat_message.dart';

class ImageState extends Equatable {
  final List<ChatMessage> messages;

  ImageState(this.messages);

  @override
  List<Object> get props => [messages];
}
