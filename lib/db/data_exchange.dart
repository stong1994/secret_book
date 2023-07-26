import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart'; // 导入用于处理文件路径的库
import 'scheme.dart';

Future<bool> exportTablesToJson(String? dirPath) async {
  if (dirPath == null) {
    return false;
  }
  var database = await createDatabase();
  // var dir = await getDatabasesPath();

  try {
    createTableList.forEach((table, stmt) async {
      List<Map<String, dynamic>> tableData =
          await database.rawQuery('SELECT * FROM $table'); // 获取表数据

      var filePath = join(dirPath, '$table.json');
      File file = File(filePath); // 删除-创建文件
      if (await file.exists()) {
        file.delete();
      }
      file = await file.create(recursive: true);

      await file.writeAsString(jsonEncode(tableData), flush: true); // 写入数据到文件
    });
  } catch (e) {
    throw ("export failed,$e");
  }
  return true;
}

Future<bool> importDataFromJson(List<String?>? filePaths) async {
  if (filePaths == null) {
    return false;
  }

  var database = await createDatabase();

  await database.transaction((txn) async {
    for (var filePath in filePaths) {
      if (filePath == null) {
        continue;
      }
      // 读取数据
      File file = File(filePath);
      String fileData = await file.readAsString();
      var tableName = getTableName(getFileName(filePath));
      if (tableName == null) {
        throw ("table name is empty");
      }
      // 删除旧表
      await txn.execute('DROP TABLE IF EXISTS $tableName');
      // 创建表
      var stmt = createTableList[tableName];
      if (stmt == null) {
        throw ("not get create table statement");
      }
      await txn.execute(stmt);
      List<dynamic> jsonArray = jsonDecode(fileData);

      // 插入数据
      for (var data in jsonArray) {
        await txn.insert(tableName, data);
      }
    }
  });

  return true;
}

String? getTableName(String? fileName) {
  var s = fileName?.split('.');
  return s?[0];
}

String? getFileName(String filePath) {
  RegExp regex = RegExp(r'[^\/\\]*$'); // 匹配最后一个斜杠或反斜杠后面的字符
  final match = regex.firstMatch(filePath);
  return match?.group(0);
}
