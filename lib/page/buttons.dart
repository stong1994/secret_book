import 'package:flutter/material.dart';

IconButton infoButton(VoidCallback? oncCallback) {
  return IconButton(
    icon: const Icon(Icons.info),
    onPressed: oncCallback,
    tooltip: '详情',
    color: const Color(0xFF00224D),
  );
}

IconButton deleteButton(BuildContext context, VoidCallback? onCallback) {
  return IconButton(
    icon: const Icon(Icons.delete),
    color: const Color(0xFFA0153E),
    onPressed: delete(context, onCallback),
    tooltip: '删除',
  );
}

IconButton copyButton(String? tooltip, Icon? icon, VoidCallback? onCallback) {
  return IconButton(
    icon: icon ?? const Icon(Icons.copy),
    onPressed: onCallback,
    tooltip: tooltip ?? '复制账号',
    color: const Color(0xFF8C6A5D),
  );
}

IconButton uploadButton(VoidCallback? onCallback) {
  return IconButton(
    icon: const Icon(Icons.upload),
    onPressed: onCallback,
    tooltip: '上传',
    color: const Color(0xFF430A5D),
  );
}

IconButton copyPasswordButton(VoidCallback? onCallback) {
  return IconButton(
    icon: const Icon(Icons.password_outlined),
    onPressed: onCallback,
    tooltip: '复制密码',
    color: const Color(0xFF8C6A5D),
  );
}

VoidCallback delete(BuildContext context, VoidCallback? onCallback) {
  return () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xA07FBCD2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: const Text(
            '确定要删除吗？',
            style: TextStyle(
              color: Color(0xFF06283D),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '删除后无法恢复',
            style: TextStyle(
              color: Color(0xFF06283D),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '取消',
                style: TextStyle(
                  color: Color(0xFF81C6E8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                onCallback?.call();
                Navigator.of(context).pop();
              },
              child: const Text(
                '删除',
                style: TextStyle(
                  color: Color(0xFF06283D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  };
}
