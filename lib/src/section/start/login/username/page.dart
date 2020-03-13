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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pattle/src/app.dart';
import 'package:pattle/src/resources/localizations.dart';
import 'package:pattle/src/resources/theme.dart';
import 'package:pattle/src/section/start/homeserver/bloc.dart';

import '../../../../auth/bloc.dart';
import '../../../../sentry/bloc.dart';
import '../bloc.dart';
import 'widgets/input.dart';

class UsernameLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UsernameLoginPageState();

  static Widget withBloc() => MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              context.bloc<AuthBloc>(),
              context.bloc<SentryBloc>(),
            ),
          ),
          BlocProvider<HomeserverBloc>(
            create: (BuildContext context) => HomeserverBloc(
              context.bloc<LoginBloc>(),
            ),
          ),
        ],
        child: UsernameLoginPage(),
      );
}

class UsernameLoginPageState extends State<UsernameLoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  void _login() {
    BlocProvider.of<LoginBloc>(context).add(
      Login(
        password: _passwordController.text,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final toAdvance = () {
      Navigator.pushNamed(
        context,
        Routes.loginAdvanced,
        arguments: BlocProvider.of<HomeserverBloc>(context),
      );
    };

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessful) {
          Navigator.pushReplacementNamed(context, Routes.chats);
        }
      },
      child: Scaffold(
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
                child: Padding(
                  padding: ButtonTheme.of(context).padding.add(
                        EdgeInsets.symmetric(horizontal: 16),
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        l(context).login.toUpperCase(),
                        style: Theme.of(context).textTheme.headline.copyWith(
                              fontWeight: FontWeight.bold,
                              color: redOnBackground(context),
                            ),
                      ),
                      SizedBox(height: 16),
                      UsernameInput(
                        controller: _usernameController,
                      ),
                      SizedBox(height: 8),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (BuildContext context, LoginState state) {
                          String errorText;

                          if (state is LoginFailed) {
                            errorText = l(context).wrongPasswordError;
                          }

                          return TextField(
                            controller: _passwordController,
                            autofocus: true,
                            onChanged: (value) {},
                            onEditingComplete: () {},
                            obscureText: !_showPassword,
                            enableInteractiveSelection: true,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: l(context).password,
                              errorText: errorText,
                              // Needed so that an error does
                              // not make the layout jump
                              helperText: '',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        children: <Widget>[
                          BlocBuilder<SentryBloc, SentryState>(
                            builder: (context, state) {
                              return Checkbox(
                                value: state.mayReportCrashes,
                                onChanged: (value) {
                                  BlocProvider.of<SentryBloc>(context).add(
                                    ChangeMayReportCrashes(value),
                                  );
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
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          // Only enable the button if the username is valid
                          final login = state is NotLoggedIn &&
                                  state is! LoggingIn &&
                                  state.canLogin &&
                                  _passwordController.text.isNotEmpty
                              ? _login
                              : null;

                          return RaisedButton(
                            onPressed: login,
                            child: Text(l(context).login.toUpperCase()),
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
      ),
    );
  }
}
