import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 复制字符串到剪贴板
void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

void showOnCopy(
  BuildContext context,
  String code, {
  String tip = '已复制',
  int retentionMillSecond = 500,
}) {
  copyToClipboard(code);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(milliseconds: retentionMillSecond), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        title: Text(tip),
      );
    },
  );
}

// copy
VoidCallback onCopy(
  BuildContext context,
  String code, {
  String tip = '已复制',
  int retentionMillSecond = 500,
}) {
  return () {
    showOnCopy(context, code,
        tip: tip, retentionMillSecond: retentionMillSecond);
  };
}

Future<String?> selectDirectory() async {
  return await FilePicker.platform.getDirectoryPath();
}
