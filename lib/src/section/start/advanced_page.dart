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
import 'package:pattle/src/resources/localizations.dart';

import 'homeserver/bloc.dart';
import '../../resources/theme.dart';

class AdvancedPage extends StatefulWidget {
  final HomeserverBloc bloc;

  const AdvancedPage({Key key, @required this.bloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AdvancedPageState();
}

class AdvancedPageState extends State<AdvancedPage> {
  final homeserverTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homeserverTextController.text =
        widget.bloc.state.homeserver?.url?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).withTransparentAppBar(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l(context).advanced,
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
                      builder: (BuildContext context, HomeserverState state) {
                        var errorText;

                        if (state is HomeserverIsInvalid) {
                          errorText = l(context).hostnameInvalidError;
                        } else {
                          errorText = null;
                        }

                        return TextField(
                          controller: homeserverTextController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: l(context).homeserver,
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
                        labelText: l(context).identityServer,
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
                      homeserverTextController.text,
                      viaAdvanced: true,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(l(context).confirm.toUpperCase()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
