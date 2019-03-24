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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/start/start_bloc.dart';

class UsernamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UsernamePageState();
}

class UsernamePageState extends State<UsernamePage> {
  var usernameController = TextEditingController();

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription = start.isUsernameAvailable.listen((state) {
      if (state == UsernameAvailableState.available
          || state == UsernameAvailableState.unavailable) {
        Navigator.pushNamed(context, "/start/password");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  void _next(BuildContext context) {
    start.checkUsernameAvailability(usernameController.text);
  }

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
                    StreamBuilder<UsernameAvailableState>(
                        stream: start.isUsernameAvailable,
                        builder: (BuildContext context, AsyncSnapshot<UsernameAvailableState> snapshot) {
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
                              controller: usernameController,
                              onEditingComplete: () {
                                _next(context);
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  helperText: AppLocalizations.of(context).ifYouDontHaveAnAccount,
                                  labelText: AppLocalizations.of(context).username,
                                  errorText: errorText
                              )
                          );
                        }
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<UsernameAvailableState>(
                        stream: start.isUsernameAvailable,
                        builder: (BuildContext context, AsyncSnapshot<UsernameAvailableState> snapshot) {
                          final enabled = snapshot.data != UsernameAvailableState.checking;
                          var onPressed;

                          if (enabled) {
                            onPressed = () {
                              _next(context);
                            };
                          } else {
                            onPressed = null;
                          }

                          return RaisedButton(
                              onPressed: onPressed,
                              child: Text(AppLocalizations.of(context).nextButton)
                          );
                        }
                    ),
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