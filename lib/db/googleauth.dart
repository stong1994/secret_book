import 'package:secret_book/config/config.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/utils/time.dart';
import 'package:uuid/uuid.dart';

import 'scheme.dart';

class GoogleAuthBookData {
  Future<void> clean() async {
    final db = await createDatabase();
    await db.delete(googleAuthTableName);
    return;
  }

  Future<GoogleAuth> addGoogleAuth(GoogleAuth googleauth) async {
    final db = await createDatabase();
    googleauth.id = const Uuid().v4();
    await db.insert(googleAuthTableName, googleauth.toJson());
    return googleauth;
  }

  Future<GoogleAuth> deleteGoogleAuth(GoogleAuth googleauth) async {
    final db = await createDatabase();
    await db.delete(
      googleAuthTableName,
      where: 'id = ?',
      whereArgs: [googleauth.id],
    );
    googleauth.date = nowStr();
    return googleauth;
  }

  Future<List<GoogleAuth>> fetchGoogleAuths() async {
    final db = await createDatabase();
    final googleauths = await db.query(googleAuthTableName);
    return List.generate(
        googleauths.length, (index) => GoogleAuth.fromJson(googleauths[index]));
  }

  Future<GoogleAuth> updateGoogleAuth(GoogleAuth googleauth) async {
    final db = await createDatabase();
    await db.update(
      googleAuthTableName,
      googleauth.toJson(),
      where: 'id = ?',
      whereArgs: [googleauth.id],
    );
    return googleauth;
  }

  Future<GoogleAuth> getGoogleAuthByID(String googleAuthID) async {
    final db = await createDatabase();
    final googleauths = await db.query(
      googleAuthTableName,
      where: 'id = ?',
      whereArgs: [googleAuthID],
    );
    return GoogleAuth.fromJson(googleauths.first);
  }

  Future<GoogleAuth> saveGoogleAuth(GoogleAuth googleauth) async {
    final db = await createDatabase();
    final oldGoogleAuth = await db
        .query(googleAuthTableName, where: "id=?", whereArgs: [googleauth.id]);
    if (oldGoogleAuth.isNotEmpty) {
      return await updateGoogleAuth(googleauth);
    } else {
      return await addGoogleAuth(googleauth);
    }
  }
}
