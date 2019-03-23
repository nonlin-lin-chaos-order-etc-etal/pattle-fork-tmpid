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

AppLocalizations l(BuildContext context) => AppLocalizations.of(context);

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String _get(String id) {
    var languageCode = locale.languageCode;
    // Default to English if we have no translation available
    if (!_localizedValues.containsKey(languageCode)) {
      languageCode = 'en';
    }

    return _localizedValues[languageCode][id];
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'Pattle',

      'advanced': 'Advanced',

      'loginWithPhoneButton': 'Login with phone number',
      'loginWithEmailButton': 'Login with email',
      'loginWithUsernameButton': 'Login with username',

      'nextButton': 'NEXT',
      'username': 'Username',
      'enterUsername': 'Enter username',
      'ifYouDontHaveAnAccount': 'If you don\'t have an account, we\'ll create one',
      'usernameInvalidError': 'Invalid username. May only contain letters, numbers, -, ., =, _ and /',
      'userIdInvalidError': 'Invalid user ID. Must be in the format of \'@name:server.tld\'.',
      'hostnameInvalidError': 'Invalid hostname',
      'unknownErrorOccured': 'An unknown error occured',
      'confirmButton': 'CONFIRM'
    },
  };

  String get appName {
    return _get('appName');
  }

  String get loginWithPhoneButton {
    return _get('loginWithPhoneButton');
  }

  String get loginWithEmailButton {
    return _get('loginWithEmailButton');
  }

  String get loginWithUsernameButton {
    return _get('loginWithUsernameButton');
  }

  String get nextButton {
    return _get('nextButton');
  }

  String get username {
    return _get('username');
  }

  String get enterUsername {
    return _get('enterUsername');
  }

  String get ifYouDontHaveAnAccount {
    return _get('ifYouDontHaveAnAccount');
  }

  String get advanced {
    return _get('advanced');
  }

  String get usernameInvalidError {
    return _get('usernameInvalidError');
  }

  String get hostnameInvalidError {
    return _get('hostnameInvalidError');
  }

  String get userIdInvalidError {
    return _get('userIdInvalidError');
  }

  String get unknownErrorOccured {
    return _get('unknownErrorOccured');
  }

  String get confirmButton {
    return _get('confirmButton');
  }
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