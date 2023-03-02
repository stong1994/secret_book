import '../model/secret.dart';
import 'secret_data.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../config/config.dart';

class SqliteData implements SecretData {
  // WidgetsFlutterBinding.ensureInitialized();
  Future<Database> createDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), sqliteDBName),
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE secrets(id TEXT PRIMARY KEY, title TEXT, content TEXT)');
      },
    );
  }

  @override
  Future<void> clean() async {
    final db = await createDatabase();
    await db.delete(sqliteTableName);
    return;
  }

  @override
  Future<Secret> addSecret(Secret secret) async {
    final db = await createDatabase();
    secret.id = Uuid().v4();
    await db.insert(sqliteTableName, secret.toJson());
    return secret;
  }

  @override
  Future deleteSecret(Secret secret) async {
    final db = await createDatabase();
    await db.delete(
      sqliteTableName,
      where: 'id = ?',
      whereArgs: [secret.id],
    );
  }

  @override
  Future<List<Secret>> fetchSecrets() async {
    final db = await createDatabase();
    final secrets = await db.query(sqliteTableName);
    return List.generate(
        secrets.length, (index) => Secret.fromJson(secrets[index]));
  }

  @override
  Future<Secret> updateSecret(Secret secret) async {
    final db = await createDatabase();
    await db.update(
      sqliteTableName,
      secret.toJson(),
      where: 'id = ?',
      whereArgs: [secret.id],
    );
    return secret;
  }
}
