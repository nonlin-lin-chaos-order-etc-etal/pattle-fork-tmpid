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
import 'package:matrix/matrix.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/start/advanced_page.dart';
import 'package:pattle/src/ui/start/start_bloc.dart';

class UsernamePage extends StatelessWidget {

  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: 32, right: 16),
                child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/start/advanced');
                    },
                    child: Text(
                      AppLocalizations.of(context).advanced.toUpperCase()
                    )
                )
              )
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).enterUsername,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<bool>(
                      stream: start.isUsernameAvailable,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        String errorText;

                        if (snapshot.hasError) {
                          if (snapshot.error is InvalidUsernameException) {
                            errorText = l(context).usernameInvalidError;
                          } else if(snapshot.error is InvalidHostnameException) {
                            errorText = l(context).hostnameInvalidError;
                          } else if(snapshot.error is InvalidUserIdException) {
                            errorText = l(context).userIdInvalidError;
                          } else {
                            debugPrint(snapshot.error.toString());
                            debugPrintStack();
                            errorText = l(context).unknownErrorOccured;
                          }
                        } else {
                          errorText = null;
                        }

                        return TextField(
                          autofocus: true,
                          onChanged: (value) {
                            username = value;
                          },
                          decoration: InputDecoration(
                            helperText: AppLocalizations.of(context).ifYouDontHaveAnAccount,
                            labelText: AppLocalizations.of(context).username,
                            errorText: errorText
                          )
                        );
                        }
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<bool>(
                      stream: start.isCheckingForUsername,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        final isChecking = snapshot.data == true;
                        var onPressed;

                        if (!isChecking) {
                          onPressed = () {
                            start.checkUsernameAvailability(username);
                          };
                        } else {
                          onPressed = null;
                        }

                        return RaisedButton(
                            onPressed: onPressed,
                            child: Text(AppLocalizations.of(context).nextButton)
                        );
                      }
                    )
                  ],
                )
              )
            )
          ],
        )
      ),
    );
  }
}