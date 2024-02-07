import 'package:flutter/material.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/utils/time.dart';
import 'package:secret_book/utils/utils.dart';
import 'package:secret_book/extensions/context_extension.dart';

import 'detail.dart';
import 'get_code.dart';

class EventGoogleAuthDeleted {}

class GoogleAuthRow extends StatelessWidget {
  final GoogleAuth googleAuth;

  const GoogleAuthRow({
    Key? key,
    required this.googleAuth,
  }) : super(key: key);

  VoidCallback onDeleteGoogleAuth(BuildContext context, GoogleAuth googleAuth) {
    return () {
      GoogleAuthBookData().deleteGoogleAuth(googleAuth).then((_) {
        if (!context.autoPushEvent) {
          return;
        }
        pushEvent(
            context.serverAddr,
            Event(
              name: "delete google auth ${googleAuth.title}",
              date: nowStr(),
              content: googleAuth.toJson().toString(),
              data_type: "google_auth",
              event_type: "delete",
              from: context.name,
            ));
      }).then((_) => eventBus.fire(EventGoogleAuthDeleted()));
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Expanded(
          child: Container(
            child: Text(
              googleAuth.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Spacer(),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
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
          ],
        )),
        Spacer(),
      ],
    );
  }

  VoidCallback _showInfo(context, googleAuth) {
    return () {
      DetailPage(
        context: context,
        googleAuth: googleAuth,
      ).build();
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
