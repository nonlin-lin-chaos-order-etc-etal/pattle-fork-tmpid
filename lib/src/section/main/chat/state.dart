import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool endReached;

  ChatState({
    @required this.messages,
    this.endReached = true,
  });

  ChatState copyWith({
    List<ChatMessage> messages,
    int pageCount,
    bool endReached,
    bool loadingMore,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      endReached: endReached ?? this.endReached ?? true,
    );
  }

  @override
  List<Object> get props => [messages, endReached];
}
