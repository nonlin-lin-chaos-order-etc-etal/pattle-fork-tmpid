import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class Uninitalized extends NotificationsState {}

class NotAuthenticated extends NotificationsState {}
