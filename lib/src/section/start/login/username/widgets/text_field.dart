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
import 'package:matrix_sdk/matrix_sdk.dart';

import '../../../../../resources/intl/localizations.dart';
import '../../../../../util/lower_case_text_formatter.dart';

import '../../bloc.dart';

class UsernameController extends ValueNotifier<Username> {
  UsernameController() : super(null);
}

class UsernameTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool enabled;
  final FocusNode focusNode;

  const UsernameTextField({
    Key key,
    this.textEditingController,
    this.enabled = true,
    this.focusNode,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UsernameTextFieldState();
}

class _UsernameTextFieldState extends State<UsernameTextField> {
  void _notifyChange(String username) {
    BlocProvider.of<LoginBloc>(context).add(
      ChangeUsername(username),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      condition: (previousState, currentState) {
        final previousUsernameState = previousState.usernameState;
        final currentUsernameState = currentState.usernameState;

        return previousUsernameState.value != currentUsernameState.value ||
            previousUsernameState.invalidReason !=
                currentUsernameState.invalidReason ||
            (previousState.homeserverState.isValid !=
                currentState.homeserverState.isValid);
      },
      builder: (context, state) {
        String errorText;

        final usernameState = state.usernameState;

        if (!usernameState.isValid) {
          switch (usernameState.invalidReason) {
            case InvalidReason.username:
              errorText = context.intl.start.username.usernameInvalidError;
              break;
            case InvalidReason.userId:
              errorText = context.intl.start.username.userIdInvalidError;
              break;
            default:
              errorText = context.intl.start.username.unknownError;
          }
        }

        if (!state.homeserverState.isValid &&
            !state.homeserverState.isSetExplicitly) {
          errorText = context.intl.start.username.hostnameInvalidError;
        }

        return TextField(
          controller: widget.textEditingController,
          enabled: widget.enabled,
          focusNode: widget.focusNode,
          autofocus: true,
          inputFormatters: [LowerCaseTextFormatter()],
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
          textInputAction: TextInputAction.next,
          onChanged: _notifyChange,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            prefixText: '@',
            // Needed so that an error does
            // not make the layout jump
            helperText: '',
            labelText: context.intl.common.username,
            errorText: errorText,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
