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
import 'package:pattle/src/ui/resources/localizations.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).appName,
                  style: TextStyle(fontSize: 100),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () { },
                      child: Text(AppLocalizations.of(context).loginWithPhoneButton),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(96)),
                      padding: EdgeInsets.all(16),
                    ),
                    SizedBox(height: 16),
                    OutlineButton(
                      onPressed: () { },
                      child: Text(AppLocalizations.of(context).loginWithEmailButton),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(96)),
                      padding: EdgeInsets.all(16),
                    ),
                    SizedBox(height: 16),
                    FlatButton(
                      onPressed: () { },
                      child: Text(AppLocalizations.of(context).loginWithUsernameButton),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(96)),
                      padding: EdgeInsets.all(16),
                    ),
                  ],
                )
              ],
            )
        ),
      ),
    );
  }
}