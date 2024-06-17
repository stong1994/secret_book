import 'package:flutter/material.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/utils/utils.dart';
import 'package:secret_book/extensions/context_extension.dart';

import 'detail.dart';
import 'get_code.dart';

class GoogleAuthRow extends StatelessWidget {
  final GoogleAuth googleAuth;
  final Function() onDataChanged;

  const GoogleAuthRow({
    Key? key,
    required this.googleAuth,
    required this.onDataChanged,
  }) : super(key: key);

  VoidCallback onDeleteGoogleAuth(BuildContext context, GoogleAuth googleAuth) {
    return () {
      GoogleAuthBookData().deleteGoogleAuth(googleAuth).then((googleAuth) {
        if (!context.autoPushEvent) {
          return;
        }
        pushEvent(
          context.serverAddr,
          googleAuth.toEvent(EventType.delete, context.name),
        ).then((value) {
          if (value == "") {
            context.showSnackBar("发送事件成功");
          } else {
            context.showSnackBar("发送事件失败, 原因： $value");
          }
        }).then((_) => onDataChanged());
      });
    };
  }

  VoidCallback uploadGoogleAuth(BuildContext context, GoogleAuth googleAuth) {
    return () {
      pushEvent(
        context.serverAddr,
        googleAuth.toEvent(EventType.update, context.name),
      ).then((value) {
        if (value == "") {
          context.showSnackBar("上传成功");
        } else {
          context.showSnackBar("上传失败, 原因： $value");
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.domain_verification),
        onPressed: copyCode(context, googleAuth.token),
        tooltip: '复制验证码',
      )),
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.key),
        onPressed: onCopy(context, googleAuth.token),
        tooltip: '复制秘钥',
      )),
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.info),
        onPressed: _showInfo(context, googleAuth),
        tooltip: '详情',
      )),
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDeleteGoogleAuth(context, googleAuth),
        tooltip: '删除',
        // disabledColor: _isEditing ? Colors.grey : Colors.red,
      )),
    ];
    if (context.canSync) {
      buttons.add(Expanded(
          child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: uploadGoogleAuth(context, googleAuth),
        tooltip: '上传',
        // disabledColor: _isEditing ? Colors.grey : Colors.red,
      )));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Expanded(
          child: Text(
            googleAuth.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: buttons,
        )),
        const Spacer(),
      ],
    );
  }

  VoidCallback _showInfo(context, googleAuth) {
    return () {
      DetailPage(
        parentContext: context,
        googleAuth: googleAuth,
      ).build(onDataChanged);
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
