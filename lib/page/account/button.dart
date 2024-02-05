import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'add.dart';
import 'search.dart';
import 'utils.dart';

typedef AfterSearchFn = void Function(String? keyword);

Widget queryButton(
    BuildContext context, String queryKey, AfterSearchFn afterFn) {
  return Container(
    padding: const EdgeInsets.only(bottom: 10, right: 10),
    alignment: Alignment.bottomRight,
    child: queryKey.isEmpty
        ? waitSearchButton(context, afterFn)
        : cleanSearchButton(context, queryKey, () {
            afterFn("");
          }),
  );
}

Widget waitSearchButton(context, afterFn) {
  return FloatingActionButton(
    onPressed: () {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white.withOpacity(0.6),
        builder: (BuildContext context) {
          return QueryPage(afterFn: afterFn);
        },
      );
    },
    child: const Icon(Icons.search),
  );
}

Widget cleanSearchButton(
    BuildContext context, String queryKey, Function cleanSearch) {
  return Container(
    alignment: Alignment.bottomRight,
    child: FloatingActionButton(
      onPressed: () {
        cleanSearch();
      },
      backgroundColor: Color.fromARGB(255, 130, 118, 10),
      child: const Icon(
        Icons.clear,
        color: Colors.white,
      ),
    ),
  );
}

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
  BuildContext context,
  bool inScaffold, {
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
      onPressed: onGenPwd(context, inScaffold, callback: callback),
      tooltip: '生成密码',
      child: const Icon(Icons.vpn_key),
    ),
  );
}
