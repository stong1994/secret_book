import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/utils/utils.dart';

VoidCallback onGenPwd(BuildContext context, bool inScaffold,
    {Function(String pwd)? callback}) {
  return () {
    var pwd = genPwd();
    copyToClipboard(pwd);
    if (callback != null) {
      callback(pwd);
    }
    if (inScaffold) {
      context.showSnackBar('新密码已复制到粘贴板');
    }
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     Future.delayed(const Duration(milliseconds: 500), () {
    //       Navigator.of(context).pop();
    //     });
    //     return const AlertDialog(
    //       title: Text('新密码已复制到粘贴板'),
    //     );
    //   },
    // );
  };
}

String genPwd() {
  const littleChars = 'abcdefghijklmnopqrstuvwxyz';
  const bigChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const specials = '~!@#&^*%';
  const nums = '1234567890';
  Random random = Random();
  String str = String.fromCharCodes(Iterable.generate(6,
          (_) => littleChars.codeUnitAt(random.nextInt(littleChars.length)))) +
      String.fromCharCodes(Iterable.generate(
          6, (_) => bigChars.codeUnitAt(random.nextInt(bigChars.length)))) +
      String.fromCharCodes(Iterable.generate(
          4, (_) => specials.codeUnitAt(random.nextInt(specials.length)))) +
      String.fromCharCodes(Iterable.generate(
          4, (_) => nums.codeUnitAt(random.nextInt(nums.length))));
  var chars = str.split('');
  chars.shuffle();
  return chars.join('');
}
