import 'dart:io';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateChat extends ChatEvent {
  /// If true, don't request more items, just show what's already in the
  /// timeline (which might've been updated by a sync).
  final bool refresh;

  UpdateChat({@required this.refresh});

  @override
  List<Object> get props => [refresh];
}

class MarkAsRead extends ChatEvent {}

class SendTextMessage extends ChatEvent {
  final String message;

  SendTextMessage(this.message);

  @override
  List<Object> get props => [message];
}

class SendImageMessage extends ChatEvent {
  final File file;

  SendImageMessage(this.file);
}
