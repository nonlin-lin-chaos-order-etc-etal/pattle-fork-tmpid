import 'package:pattle/src/section/main/models/chat_member.dart';

abstract class SettingsState {
  final ChatMember me;

  SettingsState(this.me);

  @override
  bool operator ==(other) {
    return runtimeType == other.runtimeType &&
        me.user.state == other.me.user.state;
  }

  @override
  int get hashCode => runtimeType.hashCode + me.user.state.hashCode;
}

class SettingsInitialized extends SettingsState {
  @override
  SettingsInitialized(ChatMember me) : super(me);
}

class UpdatingDisplayName extends SettingsState {
  @override
  UpdatingDisplayName(ChatMember me) : super(me);
}

class DisplayNameUpdated extends SettingsState {
  @override
  DisplayNameUpdated(ChatMember me) : super(me);
}
