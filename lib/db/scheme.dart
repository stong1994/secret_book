import 'dart:io';

import 'package:secret_book/config/config.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/material.dart';

var createTableList = {
  accountTableName:
      'CREATE TABLE $accountTableName(id TEXT PRIMARY KEY, title TEXT, account TEXT, password TEXT, comment TEXT, date TEXT);',
  tokenTableName:
      'CREATE TABLE $tokenTableName(id TEXT PRIMARY KEY, title TEXT, content TEXT, comment TEXT, date TEXT);',
  googleAuthTableName:
      'CREATE TABLE $googleAuthTableName(id TEXT PRIMARY KEY, title TEXT, token TEXT, comment TEXT, date TEXT);',
  userInfoTableName: '''
CREATE TABLE $userInfoTableName(id INT, last_sync_date TEXT, server_addr, name TEXT, auto_push_event INT);
''' // INSERT INTO info(id, last_sync_date, server_addr, name,auto_push_event) Values(0, 0, '127.0.0.1:12345', '1', 1);
};

// WidgetsFlutterBinding.ensureInitialized();
Future<Database> createDatabase() async {
  return await openDatabase(
    join(await getDatabasesPath(), sqliteDBName),
    version: 1,
    onCreate: (db, version) async {
      for (var stmt in createTableList.entries) {
        debugPrint(stmt.value);
        try {
          await db.execute(stmt.value);
        } catch (e) {
          debugPrint('Error creating table ${stmt.key}: $e');
        }
      }
    },
  );
}

Future<String> getDataDir() async {
  return await getDatabasesPath();
}

initializeDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
    // this step, it will use the sqlite version available on the system.
    databaseFactory = databaseFactoryFfi;
  }
  var dbPath = await getDatabasesPath();
  debugPrint("db path is $dbPath");
  var db = await createDatabase();
  await db.rawInsert(
      "INSERT INTO $userInfoTableName(id, last_sync_date, server_addr, name, auto_push_event) Values(0, '0', 'localhost:12345', '${const Uuid().v4()}', 1);");
}
