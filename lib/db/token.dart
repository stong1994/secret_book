import 'package:secret_book/config/config.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/utils/time.dart';
import 'package:uuid/uuid.dart';

import 'scheme.dart';

class TokenBookData {
  Future<void> clean() async {
    final db = await createDatabase();
    await db.delete(tokenTableName);
    return;
  }

  Future<Token> addToken(Token token) async {
    final db = await createDatabase();
    token.id = const Uuid().v4();
    await db.insert(tokenTableName, token.toJson());
    return token;
  }

  Future<Token> deleteToken(Token token) async {
    final db = await createDatabase();
    await db.delete(
      tokenTableName,
      where: 'id = ?',
      whereArgs: [token.id],
    );
    token.date = nowStr();
    return token;
  }

  Future<List<Token>> fetchTokens() async {
    final db = await createDatabase();
    final tokens = await db.query(tokenTableName);
    return List.generate(
        tokens.length, (index) => Token.fromJson(tokens[index]));
  }

  Future<Token> updateToken(Token token) async {
    final db = await createDatabase();
    await db.update(
      tokenTableName,
      token.toJson(),
      where: 'id = ?',
      whereArgs: [token.id],
    );
    return token;
  }

  Future<Token> saveToken(Token token) async {
    final db = await createDatabase();
    final oldToken =
        await db.query(tokenTableName, where: "id=?", whereArgs: [token.id]);
    if (oldToken.isNotEmpty) {
      return await updateToken(token);
    } else {
      return await addToken(token);
    }
  }
}
