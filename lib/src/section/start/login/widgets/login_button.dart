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

class LoginButton extends StatefulWidget {
  final bool loading;
  final VoidCallback onPressed;
  final Widget child;

  const LoginButton({
    Key key,
    this.loading = false,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: widget.loading ? CircleBorder() : null,
      color: Theme.of(context).primaryColor,
      onPressed: widget.loading ? () {} : widget.onPressed,
      child: widget.loading
          ? Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            )
          : widget.child,
    );
  }
}
