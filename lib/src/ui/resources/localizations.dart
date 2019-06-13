// Copyright (C) 2019  Wilko Manger
//
// This file is part of Pattle.
//
// Pattle is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Pattle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Pattle.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Strings l(BuildContext context) => AppLocalizations.of(context).strings;

class Strings {

  const Strings();

  // Common //
  final appName = 'Pattle';
  final advanced = 'Advanced';
  final username = 'Username';
  final password = 'Password';
  final confirm = 'Confirm';
  final login = 'Login';
  final next = 'Next';
  final homeserver = 'Homeserver';
  final identityServer = 'Identity server';
  final today = 'Today';
  final yesterday = 'Yesterday';
  final photo = 'Photo';
  final typeAMessage = 'Type a message';
  final you = 'You';
  final andOthers = 'and others';
  final newGroup = 'New group';
  final groupName = 'Group name';
  final participants = 'Participants';

  final connectionLost =
    'Connection has been lost.\n'
    'Make sure your phone has an active internet connection.';

  final connectionFailed =
    'Connection failed. '
    'Check your internet connection';

  final youDeletedThisMessage = 'You deleted this message';
  List<TextSpan> hasDeletedThisMessage(TextSpan name)
    => [name, TextSpan(text: ' deleted this message')];

  // StartPage //
  final loginWithPhone = 'Login with phone number';
  final loginWithEmail = 'Login with email';
  final loginWithUsername = 'Login with username';

  // StartPage: UsernamePage //
  final enterUsername = 'Enter username';
  final ifYouDontHaveAnAccount = "If you don't have an account, we'll create one";
  final usernameInvalidError = "Invalid username. May only contain letters, numbers, -, ., =, _ and /";
  final userIdInvalidError = "Invalid user ID. Must be in the format of '@name:server.tld'";
  final hostnameInvalidError = 'Invalid hostname';
  final unknownError = 'An unknown error occured';

  // StartPage: PasswordPage //
  final enterPassword = 'Enter password';
  final wrongPasswordError = 'Wrong password. Please try again';

  // Room creation event
  List<TextSpan> createdThisGroup(TextSpan name)
    => [name, TextSpan(text: ' created this group')];

  // Member change events
  List<TextSpan> changedTheirNameTo(TextSpan oldName, TextSpan newName)
    => [oldName, TextSpan(text: ' changed their name to '), newName];

  List<TextSpan> joined(TextSpan name)
    => [name, TextSpan(text: ' joined')];

  List<TextSpan> left(TextSpan name)
    => [name, TextSpan(text: ' left')];

  List<TextSpan> wasBannedBy(TextSpan banee, TextSpan banner)
    => [
      banee,
      TextSpan(text: ' was banned by '),
      banner
    ];

  List<TextSpan> wasInvitedBy(TextSpan invitee, TextSpan inviter)
    => [
      invitee,
      TextSpan(text: ' was invited by '),
      inviter
    ];
}

class AppLocalizations {
  AppLocalizations(this.locale) {
    switch(locale.languageCode) {
      case 'en': _strings = const Strings(); break;
      default: _strings = const Strings();
    }
  }

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Strings _strings;
  Strings get strings => _strings;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}