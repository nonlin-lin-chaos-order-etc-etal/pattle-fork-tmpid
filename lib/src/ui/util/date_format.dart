// Copyright (C) 2019  wilko
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
import 'package:intl/intl.dart';
import 'package:pattle/src/ui/resources/localizations.dart';

int _weekOf(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

bool _isToday(DateTime now, DateTime date)
  => date.year == now.year
  && date.month == now.month
  && date.day == now.day;

bool _isYesterday(DateTime now, DateTime date)
  => date.year == now.year
  && date.month == now.month
  && date.day == now.day - 1;

bool _isThisWeek(DateTime now, DateTime date) {

  var thisWeek = _weekOf(now);
  var week = _weekOf(date);

  return date.year == now.year
      && date.month == now.month
      && week == thisWeek;
}

bool _isThisYear(DateTime now, DateTime date)
  => date.year == now.year;

String formatAsListItem(BuildContext context, DateTime date) {

  if (date == null) {
    // TODO: Handle better
    return 'unknown';
  }

  var now = DateTime.now();

  if (_isToday(now, date)) {
    // TODO: Respect 24 hour option
    return DateFormat.jm().format(date);
  } else if (_isYesterday(now, date)) {
    return l(context).yesterday;
  } else if (_isThisWeek(now, date)) {
    return DateFormat.EEEE().format(date);
  } else if (_isThisYear(now, date)) {
    return DateFormat.MMMd().format(date);
  } else {
    return DateFormat.yMMMd().format(date);
  }
}