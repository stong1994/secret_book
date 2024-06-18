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
                return AlertDialog(
                    title: const Text('文件已保存'),
                    content: Row(
                      children: [
                        Text('文件存储在 $dir'),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: onPathCopy(context, dir),
                          tooltip: '复制路径',
                        ),
                      ],
                    ),
                    actions: [
                      OverflowBar(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      )
                    ]);
              });
        }));
  };
}

VoidCallback onPathCopy(context, path) {
  return () {
    copyToClipboard(path);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop();
        });
        return const AlertDialog(
          title: Text('已复制'),
        );
      },
    );
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
                  title: Text('导入成功'),
                );
              });
        }));
  };
}
