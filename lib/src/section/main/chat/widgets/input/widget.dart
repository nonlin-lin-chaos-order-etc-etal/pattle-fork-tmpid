// Copyright (C) 2020  Wilko Manger
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
import 'package:image_picker/image_picker.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

import '../../../../../matrix.dart';

import '../../../../../resources/theme.dart';
import '../../../../../resources/intl/localizations.dart';

import '../../bloc.dart';
import 'bloc.dart';

class Input extends StatefulWidget {
  final RoomId roomId;

  final bool canSendMessages;

  const Input._({
    Key key,
    @required this.roomId,
    @required this.canSendMessages,
  }) : super(key: key);

  static Widget withBloc({
    @required RoomId roomId,
    @required bool canSendMessages,
  }) {
    return BlocProvider<InputBloc>(
      create: (c) => InputBloc(Matrix.of(c), c.bloc<ChatBloc>(), roomId),
      child: Input._(roomId: roomId, canSendMessages: canSendMessages),
    );
  }

  @override
  State<StatefulWidget> createState() => _InputState();
}

class _InputState extends State<Input> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<InputBloc>(context);

    const elevation = 8.0;

    if (widget.canSendMessages) {
      return Material(
        elevation: elevation,
        color: context.pattleTheme.chat.backgroundColor,
        // On dark theme, draw a divider line because the shadow is gone
        shape: Theme.of(context).brightness == Brightness.dark
            ? Border(top: BorderSide(color: Colors.grey[800]))
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Material(
            elevation: elevation,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            color: context.pattleTheme.chat.backgroundColor,
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (input) => bloc.add(NotifyInputChanged(input)),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                filled: true,
                fillColor: context.pattleTheme.chat.inputColor,
                hintText: context.intl.chat.typeAMessage,
                prefixIcon: IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () async {
                    await bloc.add(
                      SendImageMessage(
                        await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                        ),
                      ),
                    );
                  },
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    bloc.add(SendTextMessage(_textController.value.text));
                    _textController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Material(
        elevation: elevation,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            context.intl.chat.cantSendMessages,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
