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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pattle/src/ui/resources/localizations.dart';
import 'package:pattle/src/ui/start/start_bloc.dart';

class AdvancedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdvancedPageState();
}

class AdvancedPageState extends State<AdvancedPage> {
  final homeserverTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homeserverTextController.text = bloc.userIdDomain.toString();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: PlatformWidget(
          android: (_) => Text(
            l(context).advanced,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ios: (_) => Text(l(context).advanced),
        ),
        android: (_) => MaterialAppBarData(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          elevation: 0,
          backgroundColor: const Color(0x00000000),
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
                PlatformWidget(
                  android: (_) => Icon(Icons.home,
                      color: Theme.of(context).hintColor, size: 32),
                  ios: (_) => Icon(CupertinoIcons.home,
                      color: Theme.of(context).hintColor, size: 32),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: StreamBuilder<bool>(
                    stream: bloc.homeserverChanged,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      var errorText;

                      if (snapshot.hasError) {
                        errorText = l(context).hostnameInvalidError;
                      } else {
                        errorText = null;
                      }

                      return PlatformTextField(
                        controller: homeserverTextController,
                        android: (_) => MaterialTextFieldData(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: l(context).homeserver,
                            hintText: bloc.userIdDomain.toString(),
                            errorText: errorText,
                          ),
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
                PlatformWidget(
                  android: (_) => Icon(
                    Icons.person,
                    color: Theme.of(context).hintColor,
                    size: 32,
                  ),
                  ios: (_) => Icon(
                    CupertinoIcons.person,
                    color: Theme.of(context).hintColor,
                    size: 32,
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: PlatformTextField(
                    android: (context) => MaterialTextFieldData(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: l(context).identityServer,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 32),
            PlatformButton(
              onPressed: () {
                bloc.setHomeserverUrl(homeserverTextController.text);
                Navigator.pop(context);
              },
              child: PlatformText(l(context).confirm),
            )
          ],
        ),
      ),
    );
  }
}
