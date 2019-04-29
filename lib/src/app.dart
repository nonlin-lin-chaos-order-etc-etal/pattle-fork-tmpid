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
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/ui/initial/initial_page.dart';
import 'package:pattle/src/ui/main/chat/chat_page.dart';
import 'package:pattle/src/ui/main/chat/image/image_page.dart';
import 'package:pattle/src/ui/main/overview/chat_overview_page.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/resources/theme.dart';
import 'package:pattle/src/ui/start/advanced_page.dart';
import 'package:pattle/src/ui/start/phase/identity/username_page.dart';
import 'package:pattle/src/ui/start/phase/key/password_page.dart';
import 'package:pattle/src/ui/start/start_page.dart';



final routes = {
  Routes.root: (Object params) => MaterialPageRoute(
    builder: (context) => InitialPage()
  ),
  Routes.chats: (Object arguments) => MaterialPageRoute(
    builder: (context) {
      if (arguments is Room) {
        return ChatPage(arguments);
      } else {
        return ChatOverviewPage();
      }
    }
  ),
  Routes.image: (Object arguments) => MaterialPageRoute(
      builder: (context) => ImagePage(arguments)
  ),
  Routes.start: (Object params) => MaterialPageRoute(
    builder: (context) => StartPage()
  ),
  Routes.startAdvanced: (Object params) => MaterialPageRoute(
    builder: (context) => AdvancedPage()
  ),
  Routes.startUsername: (Object params) => MaterialPageRoute(
    builder: (context) => UsernamePage()
  ),
  Routes.startPassword: (Object params) => MaterialPageRoute(
    builder: (context) => PasswordPage()
  ),
};

class Routes {

  Routes._();

  static const root = '/';
  static const chats = '/chats';
  static const image = '/image';

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
      onGenerateRoute: (settings) {
        return routes[settings.name](settings.arguments);
      },
    );
  }
}