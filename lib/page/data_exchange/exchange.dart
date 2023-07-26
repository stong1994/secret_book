import 'package:flutter/material.dart';
import 'package:secret_book/db/data_exchange.dart';
import 'package:secret_book/utils/utils.dart';

VoidCallback export(BuildContext context) {
  return () {
    selectDirectory().then((dir) => exportTablesToJson(dir).then((success) {
          if (!success) {
            return;
          }
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  Navigator.of(context).pop();
                });
                return const AlertDialog(
                  title: Text('文件已保存'),
                );
              });
        }));
  };
}

VoidCallback import(BuildContext context) {
  return () {
    selectFile().then((paths) => importDataFromJson(paths).then((success) {
          if (!success) {
            return;
          }
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  Navigator.of(context).pop();
                });
                return const AlertDialog(
                  title: Text('成功'),
                );
              });
        }));
  };
}
