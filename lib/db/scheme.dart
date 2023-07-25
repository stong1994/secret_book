import 'package:secret_book/config/config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// WidgetsFlutterBinding.ensureInitialized();
Future<Database> createDatabase() async {
  return await openDatabase(
    join(await getDatabasesPath(), sqliteDBName),
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $accountTableName(id TEXT PRIMARY KEY, title TEXT, account TEXT, password TEXT, comment TEXT);');
      await db.execute(
          'CREATE TABLE $tokenTableName(id TEXT PRIMARY KEY, title TEXT, content TEXT);');
      await db.execute(
          'CREATE TABLE $googleAuthTableName(id TEXT PRIMARY KEY, title TEXT, token TEXT);');
    },
  );
}
