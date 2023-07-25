import 'package:secret_book/config/config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

var createTableList = {
  accountTableName:
      'CREATE TABLE $accountTableName(id TEXT PRIMARY KEY, title TEXT, account TEXT, password TEXT, comment TEXT);',
  tokenTableName:
      'CREATE TABLE $tokenTableName(id TEXT PRIMARY KEY, title TEXT, content TEXT);',
  googleAuthTableName:
      'CREATE TABLE $googleAuthTableName(id TEXT PRIMARY KEY, title TEXT, token TEXT);',
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
