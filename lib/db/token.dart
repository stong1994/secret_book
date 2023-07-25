import 'package:secret_book/config/config.dart';
import 'package:secret_book/db/scheme.dart';
import 'package:secret_book/model/token.dart';

import 'package:uuid/uuid.dart';

class SecretBookData {
  Future<void> clean() async {
    final db = await createDatabase();
    await db.delete(tokenTableName);
    return;
  }

  Future<Secret> addSecret(Secret secret) async {
    final db = await createDatabase();
    secret.id = Uuid().v4();
    await db.insert(tokenTableName, secret.toJson());
    return secret;
  }

  Future deleteSecret(Secret secret) async {
    final db = await createDatabase();
    await db.delete(
      tokenTableName,
      where: 'id = ?',
      whereArgs: [secret.id],
    );
  }

  Future<List<Secret>> fetchSecrets() async {
    final db = await createDatabase();
    final secrets = await db.query(tokenTableName);
    return List.generate(
        secrets.length, (index) => Secret.fromJson(secrets[index]));
  }

  Future<Secret> updateSecret(Secret secret) async {
    final db = await createDatabase();
    await db.update(
      tokenTableName,
      secret.toJson(),
      where: 'id = ?',
      whereArgs: [secret.id],
    );
    return secret;
  }
}
