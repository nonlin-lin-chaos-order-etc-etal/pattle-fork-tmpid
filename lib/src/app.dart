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

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/redirect.dart';
import 'package:provider/provider.dart';

import 'auth/bloc.dart';
import 'matrix.dart';
import 'notifications/bloc.dart';
import 'resources/localizations.dart';
import 'resources/theme.dart';
import 'section/main/chat/page.dart';
import 'section/main/chat/image/page.dart';
import 'section/main/chat/settings/page.dart';
import 'section/main/chats/page.dart';
import 'section/main/chats/create/group/details_page.dart';
import 'section/main/chats/create/group/members_page.dart';
import 'section/main/settings/appearance_page.dart';
import 'section/main/settings/name_page.dart';
import 'section/main/settings/profile_page.dart';
import 'section/main/settings/page.dart';
import 'section/start/advanced_page.dart';
import 'section/start/start_page.dart';
import 'section/start/login/username/page.dart';
import 'sentry/bloc.dart';

final routes = {
  Routes.root: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.root),
        builder: (context) => Redirect(),
      ),
  Routes.settings: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.settings),
        builder: (context) => SettingsPage.withBloc(),
      ),
  Routes.settingsProfile: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.settingsProfile),
        builder: (context) => ProfilePage.withGivenBloc(params),
      ),
  Routes.settingsProfileName: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.settingsProfileName),
        builder: (context) => NamePage.withGivenBloc(params),
      ),
  Routes.settingsAppearance: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.settingsAppearance),
        builder: (context) => AppearancePage.withGivenBloc(params),
      ),
  Routes.chats: (Object arguments) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.chats),
        builder: (context) => arguments is Room
            ? ChatPage.withBloc(arguments)
            : ChatsPage.withBloc(),
      ),
  Routes.chatsSettings: (Object arguments) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.chatsSettings),
        builder: (context) => ChatSettingsPage.withBloc(arguments),
      ),
  Routes.chatsNew: (Object arguments) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.chatsNew),
        builder: (context) => CreateGroupMembersPage.withBloc(),
      ),
  Routes.chatsNewDetails: (Object arguments) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.chatsNewDetails),
        builder: (context) => CreateGroupDetailsPage.withGivenBloc(arguments),
      ),
  Routes.image: (Object arguments) => MaterialPageRoute(
      settings: RouteSettings(name: Routes.image),
      builder: (context) => ImagePage.withBloc(arguments)),
  Routes.login: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.login),
        builder: (context) => StartPage(),
      ),
  Routes.loginAdvanced: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.loginAdvanced),
        builder: (context) => AdvancedPage(bloc: params),
      ),
  Routes.loginUsername: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.loginUsername),
        builder: (context) => UsernameLoginPage.withBloc(),
      ),
};

class Routes {
  Routes._();

  static const root = '/';
  static const settings = '/settings';
  static const settingsProfile = '/settings/profile';
  static const settingsProfileName = '/settings/profile/name';
  static const settingsAppearance = '/settings/appearance';
  static const chats = '/chats';
  static const chatsSettings = '/chats/settings';
  static const image = '/image';

  static const login = '/login';
  static const loginAdvanced = '/login/advanced';
  static const loginUsername = '/login/username';

  static const chatsNew = '/chats/new';
  static const chatsNewDetails = '/chats/new/details';
}

class App extends StatelessWidget {
  static Future<void> main() async => _sentryBloc.wrap(() => runApp(App()));

  static String get buildType => DotEnv().env['BUILD_TYPE'];

  static final _sentryBloc = SentryBloc();

  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) =>
          brightness == Brightness.dark ? darkTheme : lightTheme,
      themedWidgetBuilder: (context, theme) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(
              value: _authBloc,
            ),
            BlocProvider<SentryBloc>.value(
              value: _sentryBloc,
            ),
          ],
          child: Provider<Matrix>(
            create: (_) => Matrix(_authBloc),
            child: Builder(
              builder: (BuildContext c) {
                return BlocProvider<NotificationsBloc>(
                  create: (context) => NotificationsBloc(
                    matrix: Matrix.of(c),
                    authBloc: _authBloc,
                  ),
                  child: MaterialApp(
                    onGenerateTitle: (BuildContext context) =>
                        l(context).appName,
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
                    theme: theme,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
