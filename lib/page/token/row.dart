import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/page/buttons.dart';
import 'package:secret_book/utils/utils.dart';
import 'package:secret_book/extensions/context_extension.dart';

import 'detail.dart';

class TokenRow extends StatelessWidget {
  final Token token;
  final Function onDataChanged;

  const TokenRow({
    Key? key,
    required this.token,
    required this.onDataChanged,
  }) : super(key: key);

  VoidCallback onDeleteToken(BuildContext context, Token token) {
    return () {
      TokenBookData().deleteToken(token).then((token) {
        if (!context.autoPushEvent) {
          return;
        }
        pushEvent(
          context.serverAddr,
          token.toEvent(EventType.delete, context.name),
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

  VoidCallback uploadToken(BuildContext context, Token token) {
    return () {
      pushEvent(
        context.serverAddr,
        token.toEvent(EventType.update, context.name),
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
          child: copyButton("复制token", null, onCopy(context, token.content))),
      Expanded(child: infoButton(_showInfo(context, token))),
      Expanded(child: deleteButton(context, onDeleteToken(context, token))),
    ];
    if (context.canSync) {
      buttons.add(Expanded(child: uploadButton(uploadToken(context, token))));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Expanded(
          child: Text(
            token.title,
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

  VoidCallback _showInfo(context, token) {
    return () {
      DetailPage(
        parentContext: context,
        token: token,
      ).build(onDataChanged);
    };
  }
}
