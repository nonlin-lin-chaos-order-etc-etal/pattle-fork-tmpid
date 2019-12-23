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
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  final StartBloc bloc = StartBloc();

  final usernameController = TextEditingController();

  void onUsernameChanged(String username) {
    final split = username.split(':');
    if (split.length == 2) {
      String server = split[1];
      bloc.setHomeserverUrl(server, allowMistake: true);
    }

    bloc.checkUsernameValidity(username);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _next(BuildContext context) {
    Navigator.pushNamed(context, Routes.startPassword);
  }

  @override
  Widget build(BuildContext context) {
    final toAdvance = () {
      Navigator.pushNamed(context, Routes.startAdvanced);
    };

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
                  onPressed: toAdvance,
                  child: Text(
                    l(context).advanced.toUpperCase(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      l(context).enterUsername,
                      style: Theme.of(context).textTheme.headline,
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<bool>(
                      stream: bloc.isUsernameValid,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<bool> snapshot,
                      ) {
                        String errorText;

                        if (snapshot.hasError) {
                          final error = snapshot.error;
                          if (error is InvalidUsernameException) {
                            errorText = l(context).usernameInvalidError;
                          } else if (error is InvalidHostnameException) {
                            errorText = l(context).hostnameInvalidError;
                          } else if (error is InvalidUserIdException) {
                            errorText = l(context).userIdInvalidError;
                          } else if (error is SocketException) {
                            errorText = l(context).connectionFailed;
                          } else {
                            errorText = l(context).unknownError;
                          }
                        }

                        return TextField(
                          autofocus: true,
                          controller: usernameController,
                          inputFormatters: [LowerCaseTextFormatter()],
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          onSubmitted: (_) => _next(context),
                          onChanged: onUsernameChanged,
                          decoration: InputDecoration(
                            filled: true,
                            prefixText: '@',
                            helperText: l(context).ifYouDontHaveAnAccount,
                            labelText: l(context).username,
                            errorText: errorText,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<bool>(
                      stream: bloc.isUsernameValid,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<bool> snapshot,
                      ) {
                        return RaisedButton(
                          // Only enable the button if the username is valid
                          onPressed:
                              (snapshot.data ?? false) && !snapshot.hasError
                                  ? () => _next(context)
                                  : null,
                          child: Text(l(context).next.toUpperCase()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
