// Copyright (C) 2020  wilko
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pattle/src/resources/intl/localizations.dart';
import 'package:pattle/src/util/lower_case_text_formatter.dart';

import '../../../../homeserver/bloc.dart';
import '../../../bloc.dart';
import 'bloc.dart';

class UsernameInput extends StatefulWidget {
  final TextEditingController controller;

  const UsernameInput({Key key, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UsernameInputState();
}

class UsernameInputState extends State<UsernameInput> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsernameBloc>(
      create: (context) => UsernameBloc(
        context.bloc<LoginBloc>(),
        context.bloc<HomeserverBloc>(),
      ),
      child: Builder(builder: (context) {
        return BlocBuilder<UsernameBloc, UsernameState>(
          builder: (BuildContext context, UsernameState state) {
            String errorText;

            if (state is! UsernameChanged && state is! UsernameIsEmpty) {
              if (state is UsernameIsInvalid) {
                errorText = context.intl.start.username.usernameInvalidError;
              } else if (state is UserIdIsInvalid) {
                errorText = context.intl.start.username.userIdInvalidError;
              } else if (state is HostIsInvalid) {
                errorText = context.intl.start.username.hostnameInvalidError;
              } else {
                print('STATE ON ERROR: $state');
                errorText = context.intl.start.username.unknownError;
              }
            }

            return TextField(
              controller: widget.controller,
              autofocus: true,
              inputFormatters: [LowerCaseTextFormatter()],
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              textInputAction: TextInputAction.next,
              onChanged: (username) =>
                  BlocProvider.of<UsernameBloc>(context).add(
                ChangeUsername(username),
              ),
              decoration: InputDecoration(
                filled: true,
                prefixText: '@',
                // Needed so that an error does
                // not make the layout jump
                helperText: '',
                labelText: context.intl.common.username,
                errorText: errorText,
              ),
            );
          },
        );
      }),
    );
  }
}
