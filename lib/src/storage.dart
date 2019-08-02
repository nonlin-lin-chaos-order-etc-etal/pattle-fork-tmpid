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

import 'package:sqflite/sqflite.dart';

class Storage {
  static const _preferencesTable = 'preferences';
  static const _keyColumn = 'key';
  static const _valueColumn = 'value';

  final Database db;

  Storage(this.db);

  static Future<Storage> open() async {
    final db = await openDatabase(
      'pattle.sqlite',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS $_preferencesTable (
            $_keyColumn TEXT PRIMARY KEY,
            $_valueColumn TEXT
          );
        ''',
        );
      },
    );

    return Storage(db);
  }

  Future<dynamic> operator [](String key) async {
    final results = await db.query(
      _preferencesTable,
      where: '$_keyColumn = ?',
      whereArgs: [key],
    );

    if (results.isNotEmpty) {
      return results.first[_valueColumn];
    } else {
      return null;
    }
  }

  void operator []=(String key, dynamic value) {
    db.insert(
      _preferencesTable,
      {_keyColumn: key, _valueColumn: value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
