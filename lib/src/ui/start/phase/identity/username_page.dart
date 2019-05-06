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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix_sdk/matrix_sdk.dart';
import 'package:pattle/src/app.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/start/start_bloc.dart';
import 'package:pattle/src/ui/util/lower_case_text_formatter.dart';

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

    subscription = bloc.isUsernameAvailable.listen((state) {
      if (state == UsernameAvailableState.available
          || state == UsernameAvailableState.unavailable) {
        Navigator.pushNamed(context, Routes.startPassword);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  void _next(BuildContext context) {
    bloc.checkUsernameAvailability(usernameController.text);
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
                    Navigator.pushNamed(context, Routes.startAdvanced);
                  },
                  child: Text(
                      l(context).advanced.toUpperCase()
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
                      l(context).enterUsername,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<UsernameAvailableState>(
                      stream: bloc.isUsernameAvailable,
                      builder: (BuildContext context, AsyncSnapshot<UsernameAvailableState> snapshot) {
                        String errorText;

                        if (snapshot.hasError) {
                          if (snapshot.error is InvalidUsernameException) {
                            errorText = l(context).usernameInvalidError;
                          } else if(snapshot.error is InvalidHostnameException) {
                            errorText = l(context).hostnameInvalidError;
                          } else if(snapshot.error is InvalidUserIdException) {
                            errorText = l(context).userIdInvalidError;
                          } else if(snapshot.error is SocketException) {
                            errorText = l(context).connectionFailed;
                          } else {
                            debugPrint(snapshot.error.toString());
                            debugPrintStack();
                            errorText = l(context).unknownError;
                          }
                        }

                        return TextField(
                          autofocus: true,
                          controller: usernameController,
                          inputFormatters: [LowerCaseTextFormatter()],
                          textCapitalization: TextCapitalization.none,
                          onEditingComplete: () {
                            _next(context);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            prefixText: '@',
                            helperText: l(context).ifYouDontHaveAnAccount,
                            labelText: l(context).username,
                            errorText: errorText
                          )
                        );
                      }
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<UsernameAvailableState>(
                      stream: bloc.isUsernameAvailable,
                      builder: (BuildContext context, AsyncSnapshot<UsernameAvailableState> snapshot) {
                        final state = snapshot.data;
                        final enabled =
                           state != UsernameAvailableState.checking
                        && state != UsernameAvailableState.stillChecking;
                        var onPressed;
                        Widget child = Text(l(context).next.toUpperCase());

                        if (enabled) {
                          onPressed = () {
                            _next(context);
                          };
                        } else {
                          onPressed = null;
                        }

                        if (state == UsernameAvailableState.stillChecking) {
                          child = SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.grey),
                            )
                          );
                        }

                        return RaisedButton(
                          onPressed: onPressed,
                          child: child
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