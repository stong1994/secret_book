import 'package:flutter/material.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/utils/utils.dart';

import 'detail.dart';
import 'get_code.dart';

class GoogleAuthRow extends StatefulWidget {
  final String googleAuthID;
  final Function afterChangeFn;

  const GoogleAuthRow({
    Key? key,
    required this.googleAuthID,
    required this.afterChangeFn,
  }) : super(key: key);

  @override
  _GoogleAuthRowState createState() => _GoogleAuthRowState();
}

class _GoogleAuthRowState extends State<GoogleAuthRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  VoidCallback onDeleteGoogleAuth(googleAuth) {
    return () {
      GoogleAuthBookData().deleteGoogleAuth(googleAuth);
      widget.afterChangeFn();
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GoogleAuth>(
        future: GoogleAuthBookData().getGoogleAuthByID(widget.googleAuthID),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}}"),
            );
          }
          final googleAuth = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    googleAuth.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                  child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.domain_verification),
                    onPressed: copyCode(context, googleAuth.token),
                    tooltip: '复制验证码',
                  ),
                  IconButton(
                    icon: const Icon(Icons.key),
                    onPressed: onCopy(context, googleAuth.token),
                    tooltip: '复制秘钥',
                  ),
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: _showInfo(context, googleAuth),
                    tooltip: '详情',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDeleteGoogleAuth(googleAuth),
                    tooltip: '删除',
                    // disabledColor: _isEditing ? Colors.grey : Colors.red,
                  ),
                ],
              ))
            ],
          );
        });
  }

  void rebuildCallback() {
    // widget.afterChangeFn();
    setState(() {});
  }

  VoidCallback _showInfo(context, googleAuth) {
    return () {
      DetailPage(
              context: context,
              googleAuth: googleAuth,
              afterFn: rebuildCallback)
          .build();
    };
  }

  VoidCallback copyCode(BuildContext context, String token) {
    return () {
      var authCode = getCode(token);
      showOnCopy(
        context,
        authCode.code,
        tip: '已复制，还剩${authCode.expireSecond}秒过期',
        retentionMillSecond: 1000,
      );
    };
  }
}
