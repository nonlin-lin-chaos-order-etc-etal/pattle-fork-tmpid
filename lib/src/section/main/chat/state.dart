import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/chat.dart';
import '../models/chat_message.dart';

class ChatState extends Equatable {
  final Chat chat;
  final List<ChatMessage> messages;
  final bool endReached;

  ChatState({
    @required this.chat,
    @required this.messages,
    this.endReached = true,
  });

  ChatState copyWith({
    Chat chat,
    List<ChatMessage> messages,
    bool endReached,
  }) {
    return ChatState(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      endReached: endReached ?? this.endReached ?? true,
    );
  }

  @override
  List<Object> get props => [chat, messages, endReached];
}
