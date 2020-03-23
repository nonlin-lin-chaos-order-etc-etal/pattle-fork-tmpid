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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/theme.dart';
import '../../resources/intl/localizations.dart';

import 'homeserver/bloc.dart';

class AdvancedPage extends StatefulWidget {
  final HomeserverBloc bloc;

  const AdvancedPage({Key key, @required this.bloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AdvancedPageState();
}

class AdvancedPageState extends State<AdvancedPage> {
  final _homeserverTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _homeserverTextController.text =
        widget.bloc.state.homeserver?.url?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).withTransparentAppBar(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.intl.start.advanced,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: Theme.of(context).hintColor,
                    size: 32,
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: BlocBuilder<HomeserverBloc, HomeserverState>(
                      bloc: widget.bloc,
                      builder: (context, state) {
                        var errorText;

                        if (state is HomeserverIsInvalid) {
                          errorText =
                              context.intl.start.username.hostnameInvalidError;
                        } else {
                          errorText = null;
                        }

                        return TextField(
                          controller: _homeserverTextController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: context.intl.start.homeserver,
                            hintText:
                                widget.bloc.state.homeserver?.url?.toString(),
                            errorText: errorText,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Theme.of(context).hintColor,
                    size: 32,
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: context.intl.start.identityServer,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 32),
              RaisedButton(
                onPressed: () {
                  widget.bloc.add(
                    ChangeHomeserver(
                      _homeserverTextController.text,
                      viaAdvanced: true,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(context.intl.common.confirm.toUpperCase()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
