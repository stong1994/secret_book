import 'package:flutter/material.dart';
import 'package:secret_book/db/export.dart';
import 'package:secret_book/utils/utils.dart';

VoidCallback export(BuildContext context) {
  return () {
    selectDirectory().then((dir) => exportTablesToJson(dir).then((success) {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(milliseconds: 5000), () {
                  Navigator.of(context).pop();
                });
                return const AlertDialog(
                  title: Text('文件已保存'),
                );
              });
        }));
  };
}
