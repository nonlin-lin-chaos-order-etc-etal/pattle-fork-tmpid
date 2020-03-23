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

import '../../../resources/intl/localizations.dart';
import '../../../resources/theme.dart';

import 'bloc.dart';

class _NamePageState extends State<NamePage> {
  final _textController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final me = BlocProvider.of<SettingsBloc>(context).state.me;

    _textController.value = TextEditingValue(
      text: me.name,
      selection: TextSelection(baseOffset: 0, extentOffset: me.name.length),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setName() async {
    BlocProvider.of<SettingsBloc>(context).add(
      UpdateDisplayName(_textController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (prevState, currentState) {
        if (currentState is DisplayNameUpdated) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.intl.common.name,
            style: TextStyle(
              color: redOnBackground(context),
            ),
          ),
          brightness: Theme.of(context).brightness,
          iconTheme: IconThemeData(
            color: redOnBackground(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: setName,
            )
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              controller: _textController,
              autocorrect: false,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
              ),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.zero,
                ),
                fillColor: LightColors.red,
                focusColor: Colors.white,
              ),
              onSubmitted: (_) => setName(),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                if (state is UpdatingDisplayName) {
                  return LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(LightColors.red[300]),
                    backgroundColor: LightColors.red[100],
                  );
                } else {
                  return Container(height: 6);
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.info_outline,
                      size: 28,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      context.intl.settings.editNameDescription,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NamePage extends StatefulWidget {
  NamePage._();

  static Widget withGivenBloc(SettingsBloc settingsBloc) {
    return BlocProvider<SettingsBloc>.value(
      value: settingsBloc,
      child: NamePage._(),
    );
  }

  @override
  State<StatefulWidget> createState() => _NamePageState();
}
