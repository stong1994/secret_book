import 'package:secret_book/config/config.dart';
import 'package:secret_book/db/scheme.dart';

import '../model/info.dart';

class InfoData {
  Future<void> saveLastSyncDate(String date) async {
    final db = await createDatabase();
    await db.rawUpdate(
      "UPDATE $userInfoTableName SET last_sync_date = ? WHERE id=0",
      [date],
    );
  }

  Future<String> getLastSyncDate() async {
    final db = await createDatabase();
    final info = await db.query(
      userInfoTableName,
      where: 'id = 0',
    );
    return Info.fromJson(info[0]).lastSyncDate;
  }

  Future<void> saveServerAddr(String server) async {
    final db = await createDatabase();
    await db.rawUpdate(
      "UPDATE $userInfoTableName SET server_addr = ? WHERE id=0",
      [server],
    );
  }

  Future<void> saveAppName(String appName) async {
    final db = await createDatabase();
    await db.rawUpdate(
      "UPDATE $userInfoTableName SET name= ? WHERE id=0",
      [appName],
    );
  }

  Future<void> saveAutoPushEvent(bool value) async {
    final db = await createDatabase();
    await db.rawUpdate(
      "UPDATE $userInfoTableName SET auto_push_event= ? WHERE id=0",
      [value ? 1 : 0],
    );
  }

  Future<String> getServerAddr() async {
    final db = await createDatabase();
    final info = await db.query(
      userInfoTableName,
      where: 'id = 0',
    );
    return Info.fromJson(info[0]).serverAddr;
  }

  Future<Info> getInfo() async {
    final db = await createDatabase();
    final info = await db.query(
      userInfoTableName,
      where: 'id = 0',
    );
    // if (info.isNotEmpty) {
    return Info.fromJson(info[0]);
    // }
    // final defaultInfo = Info().defaultInfo();
    // await db.insert(userInfoTableName, defaultInfo.toJson());
    // return defaultInfo;
  }
}
