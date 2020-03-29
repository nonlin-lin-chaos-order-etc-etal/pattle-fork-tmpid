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

import '../../../../resources/intl/localizations.dart';

import '../../../../util/lower_case_text_formatter.dart';

import '../bloc.dart';

/// Requires a [LoginBloc] as an ancestor.
class HomeserverTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final VoidCallback onEditingComplete;

  const HomeserverTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onEditingComplete,
  }) : super(key: key);

  void _notifyChange(BuildContext context) {
    context.bloc<LoginBloc>().add(
          ChangeHomeserver(
            'https://${controller.text}',
            setExplicitly: true,
          ),
        );
  }

  String _displayValue(HomeserverState state) {
    return state.value.url.toString().replaceAll('https://', '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      /*condition: (previousState, currentState) {
        final previousHsState = previousState.homeserverState;
        final currentHsState = currentState.homeserverState;

        return previousHsState.value.url != currentHsState.value.url ||
            previousHsState.isValid != currentHsState.isValid;
      },*/
      builder: (context, state) {
        var errorText;

        final homeserverState = state.homeserverState;

        if (!homeserverState.isValid) {
          errorText = context.intl.start.username.hostnameInvalidError;
        } else {
          errorText = null;
        }

        return TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          onEditingComplete: onEditingComplete,
          onChanged: (_) => _notifyChange(context),
          inputFormatters: [LowerCaseTextFormatter()],
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).primaryColorLight,
            focusColor: Colors.white,
            prefixIcon: Icon(Icons.home),
            prefixText: 'https://',
            // Needed so that an error does
            // not make the layout jump
            helperText: '',
            hintText: _displayValue(homeserverState),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
            ),
            labelText: context.intl.start.homeserver,
            errorText: errorText,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            errorStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
