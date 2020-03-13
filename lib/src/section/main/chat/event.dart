import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchChat extends ChatEvent {}

class MarkAsRead extends ChatEvent {}

class SendTextMessage extends ChatEvent {
  final String message;

  SendTextMessage(this.message);
}

class SendImageMessage extends ChatEvent {
  final File file;

  SendImageMessage(this.file);
}
