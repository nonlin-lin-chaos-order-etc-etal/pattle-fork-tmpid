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
import 'package:pattle/src/app_bloc.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/start/start_bloc.dart';
import 'package:pattle/src/ui/util/future_or_builder.dart';

class PasswordPageState extends State<PasswordPage> {
  final StartBloc bloc = StartBloc();

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    password = null;

    subscription = bloc.loginStream.listen((state) {
      if (state == RequestState.success) {
        bloc.dispose();
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.chats,
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  String password;

  void _next() {
    bloc.login(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              l(context).enterPassword,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            StreamBuilder<RequestState>(
              initialData: RequestState.none,
              stream: bloc.loginStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<RequestState> snapshot,
              ) {
                String errorText;

                if (snapshot.hasError) {
                  if (snapshot.error is ForbiddenException) {
                    errorText = l(context).wrongPasswordError;
                  } else if (snapshot.error is SocketException) {
                    errorText = l(context).connectionFailed;
                  } else {
                    errorText = l(context).unknownError;
                  }
                } else {
                  errorText = null;
                }

                return TextField(
                  autofocus: true,
                  onChanged: (value) {
                    password = value;
                  },
                  onEditingComplete: () {
                    _next();
                  },
                  obscureText: true,
                  enableInteractiveSelection: true,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: l(context).password,
                    helperText: l(context).loggingInAs(
                      bloc.username.toString(),
                    ),
                    errorText: errorText,
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                FutureOrBuilder<bool>(
                  futureOr: AppBloc().getMayReportCrashes(lookInStorage: false),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<bool> snapshot,
                  ) {
                    final mayReportCrashes = snapshot.data;
                    return Checkbox(
                      value: mayReportCrashes,
                      onChanged: (value) {
                        setState(() {
                          AppBloc().setMayReportCrashes(value);
                        });
                      },
                    );
                  },
                ),
                Flexible(
                  child: Text(
                    'Allow Pattle to send crash reports to help development',
                  ),
                ),
              ],
            ),
            StreamBuilder<RequestState>(
              stream: bloc.loginStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<RequestState> snapshot,
              ) {
                final state = snapshot.data;
                final isTrying = state == RequestState.active ||
                    state == RequestState.stillActive;
                var onPressed;

                Widget child = Text(l(context).login.toUpperCase());

                if (!isTrying) {
                  onPressed = () {
                    _next();
                  };
                } else {
                  onPressed = null;
                }

                if (state == RequestState.stillActive) {
                  child = SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.grey),
                    ),
                  );
                }

                return RaisedButton(
                  onPressed: onPressed,
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PasswordPageState();
}
