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
import 'package:pattle/src/app.dart';
import 'package:pattle/src/resources/localizations.dart';

class StartPage extends StatelessWidget {
  void _loginWithUsername(BuildContext context) {
    Navigator.pushNamed(context, Routes.startUsername);
  }

  @override
  Widget build(BuildContext context) {
    final loginWithPhone = l(context).loginWithPhone.toUpperCase();
    final loginWithEmail = l(context).loginWithEmail.toUpperCase();
    final loginWithUsername = l(context).loginWithUsername.toUpperCase();

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                l(context).appName,
                style: TextStyle(fontSize: 96),
              ),
              ButtonTheme.fromButtonThemeData(
                data: ButtonTheme.of(context).copyWith(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(96),
                  ),
                  padding: EdgeInsets.all(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: null,
                      child: Text(loginWithPhone),
                    ),
                    SizedBox(height: 16),
                    OutlineButton(
                      onPressed: null,
                      child: Text(loginWithEmail),
                    ),
                    SizedBox(height: 16),
                    FlatButton(
                      onPressed: () => _loginWithUsername(context),
                      child: Text(loginWithUsername),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
