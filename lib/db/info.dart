import 'package:secret_book/config/config.dart';
import 'package:secret_book/db/scheme.dart';

import '../model/info.dart';

class InfoData {
  Future<void> saveLastSyncDate(int date) async {
    final db = await createDatabase();
    await db.rawUpdate(
      "UPDATE $userInfoTableName SET last_sync_date = ? WHERE id=0"
          [date],
    );
  }

  Future<int> getLastSyncDate() async {
    final db = await createDatabase();
    final info= await db.query(
      userInfoTableName,
      where: 'id = 0',
    );
    return Info.fromJson(info[0]).lastSyncDate;
  }
