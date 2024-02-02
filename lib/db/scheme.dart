import 'package:secret_book/config/config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

var createTableList = {
  accountTableName:
      'CREATE TABLE $accountTableName(id TEXT PRIMARY KEY, title TEXT, account TEXT, password TEXT, comment TEXT);',
  tokenTableName:
      'CREATE TABLE $tokenTableName(id TEXT PRIMARY KEY, title TEXT, content TEXT);',
  googleAuthTableName:
      'CREATE TABLE $googleAuthTableName(id TEXT PRIMARY KEY, title TEXT, token TEXT);',
  userInfoTableName: '''
CREATE TABLE $userInfoTableName(id INT, last_sync_date TEXT, server_addr, name TEXT, auto_push_event INT);
INSERT INTO $userInfoTableName(id, last_sync_date, server_addr, name) Values(0, 0, '127.0.0.1:12345', ${const Uuid().v4()}, 1);
'''
};

// WidgetsFlutterBinding.ensureInitialized();
Future<Database> createDatabase() async {
  return await openDatabase(
    join(await getDatabasesPath(), sqliteDBName),
    version: 1,
    onCreate: (db, version) async {
      createTableList.forEach((_, stmt) async {
        await db.execute(stmt);
      });
    },
  );
}

Future<String> getDataDir() async {
  return await getDatabasesPath();
}
