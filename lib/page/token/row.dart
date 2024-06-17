import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/utils/utils.dart';
import 'package:secret_book/extensions/context_extension.dart';

import 'detail.dart';

class EventTokenDeleted {}

class TokenRow extends StatelessWidget {
  final Token token;

  const TokenRow({
    Key? key,
    required this.token,
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
        });
      }).then((_) => eventBus.fire(EventTokenDeleted()));
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
          child: IconButton(
        icon: const Icon(Icons.key),
        onPressed: onCopy(context, token.content),
        tooltip: '复制token',
      )),
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.info),
        onPressed: _showInfo(context, token),
        tooltip: '详情',
      )),
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDeleteToken(context, token),
        tooltip: '删除',
        // disabledColor: _isEditing ? Colors.grey : Colors.red,
      )),
    ];
    if (context.canSync) {
      buttons.add(Expanded(
          child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: uploadToken(context, token),
        tooltip: '上传',
        // disabledColor: _isEditing ? Colors.grey : Colors.red,
      )));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Expanded(
          child: Container(
            child: Text(
              token.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
        context: context,
        token: token,
      ).build();
    };
  }
}