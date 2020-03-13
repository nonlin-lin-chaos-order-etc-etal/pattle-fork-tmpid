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

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  final SharedPreferences prefs;

  Storage(this.prefs);

  static Future<Storage> load() async {
    return Storage(await SharedPreferences.getInstance());
  }

  static const String _mayReportCrashesStorageKey = 'may_report_crashes';

  bool get mayReportCrashes =>
      prefs.getBool(_mayReportCrashesStorageKey) ?? false;

  set mayReportCrashes(bool value) =>
      prefs.setBool(_mayReportCrashesStorageKey, value);
}
