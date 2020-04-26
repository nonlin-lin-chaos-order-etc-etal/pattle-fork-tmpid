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

import '../../../../matrix.dart';
import '../../widgets/chat_member_avatar.dart';

import '../../../../app.dart';

import 'bloc.dart';

/// Requires a [ProfileBloc].
class ProfileSettingTile extends StatelessWidget {
  ProfileSettingTile._();

  static Widget withBloc() {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(Matrix.of(context)),
      child: ProfileSettingTile._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.settingsProfile,
            arguments: context.bloc<ProfileBloc>(),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              // TODO: Use bloc?
              final me = state.me;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Hero(
                    tag: me.userId,
                    child: ChatMemberAvatar(
                      member: me,
                      radius: 36,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          me.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(me.userId.toString())
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
