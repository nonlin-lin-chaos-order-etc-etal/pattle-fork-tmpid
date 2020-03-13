import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pattle/src/section/main/models/chat_item.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final int pageCount;
  final List<ChatItem> items;
  final endReached;

  ChatLoaded({
    @required this.items,
    @required this.pageCount,
    this.endReached = true,
  });

  ChatLoaded copyWith({
    @required List<ChatItem> items,
    @required int pageCount,
    bool endReached = true,
  }) {
    return ChatLoaded(
      items: items ?? this.items,
      pageCount: pageCount ?? this.pageCount,
      endReached: endReached ?? this.endReached,
    );
  }

  @override
  List<Object> get props => [items];
}
