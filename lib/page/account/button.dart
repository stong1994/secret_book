import 'package:flutter/material.dart';

import 'add.dart';
import 'utils.dart';

Widget addButton(context, afterFn) {
  return Container(
    padding: const EdgeInsets.only(bottom: 5, right: 10),
    alignment: Alignment.bottomRight,
    child: FloatingActionButton(
      onPressed: () {
        AddPage(context: context, afterFn: afterFn).build();
      },
      child: const Icon(Icons.add),
    ),
  );
}

Widget genPwdButton(
  BuildContext context, {
  Function(String pwd)? callback,
  double? width,
  double? height,
}) {
  return Container(
    width: width,
    height: height,
    padding: const EdgeInsets.all(10),
    alignment: Alignment.bottomRight,
    child: FloatingActionButton(
      onPressed: onGenPwd(context, callback: callback),
      tooltip: '生成密码',
      child: const Icon(Icons.vpn_key),
    ),
  );
}
