import 'package:flutter/services.dart';

// 复制字符串到剪贴板
void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
