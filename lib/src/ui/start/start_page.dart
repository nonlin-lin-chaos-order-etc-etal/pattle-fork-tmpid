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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pattle/src/app.dart';
import 'package:pattle/src/ui/resources/localizations.dart';

class StartPage extends StatelessWidget {

  // TODO: PR: Make BorderRadius.circular const
  static const buttonBorderRadius = BorderRadius.all(Radius.circular(96));

  static const buttonShape = RoundedRectangleBorder(
    borderRadius: buttonBorderRadius
  );

  static const buttonPadding = EdgeInsets.all(16);

  void _loginWithUsername(BuildContext context) {
    Navigator.pushNamed(context, Routes.startUsername);
  }

  @override
  Widget build(BuildContext context) {
    final loginWithPhone = l(context).loginWithPhone.toUpperCase();
    final loginWithEmail = l(context).loginWithEmail.toUpperCase();
    final loginWithUsername = l(context).loginWithUsername.toUpperCase();

    return PlatformScaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(l(context).appName,
                style: TextStyle(fontSize: 96),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PlatformWidget(
                    android: (_) =>
                      RaisedButton(
                        onPressed: null,
                        child: Text(loginWithPhone),
                        shape: buttonShape,
                        padding: buttonPadding,
                      ),
                    ios: (_) =>
                      CupertinoButton.filled(
                        onPressed: null,
                        child: Text(loginWithPhone),
                        borderRadius: buttonBorderRadius,
                        padding: buttonPadding,
                      )
                  ),
                  SizedBox(height: 16),
                  PlatformWidget(
                    android: (_) =>
                      OutlineButton(
                        onPressed: null,
                        child: Text(loginWithEmail),
                        shape: buttonShape,
                        padding: buttonPadding,
                      ),
                    ios: (_) =>
                      CupertinoButton(
                        onPressed: null,
                        child: Text(loginWithEmail),
                        borderRadius: buttonBorderRadius,
                        padding: buttonPadding,
                      )
                  ),
                  SizedBox(height: 16),
                  PlatformWidget(
                    android: (_) =>
                        FlatButton(
                        onPressed: () => _loginWithUsername(context),
                        child: Text(loginWithUsername),
                        shape: buttonShape,
                        padding: buttonPadding,
                      ),
                    ios: (_) =>
                      CupertinoButton(
                        onPressed: () => _loginWithUsername(context),
                        child: Text(loginWithUsername),
                        borderRadius: buttonBorderRadius,
                        padding: buttonPadding,
                      )
                  )
                ],
              )
            ],
          )
        ),
      )
    );
  }
}