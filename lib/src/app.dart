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

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pattle/src/ui/chat/chat_overview_page.dart';
import 'package:pattle/src/ui/initial/initial_page.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/start/advanced_page.dart';
import 'package:pattle/src/ui/start/phase/identity/username_page.dart';
import 'package:pattle/src/ui/start/phase/key/password_page.dart';
import 'package:pattle/src/ui/start/start_page.dart';

class Routes {
  // Routes
  static const root = '/';
  static const chats = '/chats';

  static const start = '/start';
  static const startAdvanced = '/start/advanced';
  static const startUsername = '/start/username';
  static const startPassword = '/start/password';
}


class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context)
      => l(context).appName,
      theme: lightTheme,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
      ],
      initialRoute: Routes.root,
      routes: {
        Routes.root: (context) => InitialPage(),
        Routes.chats: (context) => ChatOverviewPage(),
        Routes.start: (context) => StartPage(),
        Routes.startAdvanced: (context) => AdvancedPage(),
        Routes.startUsername: (context) => UsernamePage(),
        Routes.startPassword: (context) => PasswordPage()
      },
    );
  }
}