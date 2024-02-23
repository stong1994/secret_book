import 'package:flutter/material.dart';
import 'package:secret_book/db/account.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/utils/time.dart';
import 'package:secret_book/utils/utils.dart';
import 'detail.dart';

class EventAccountDeleted {}

class AccountRow extends StatelessWidget {
  final Account account;

  AccountRow({
    required this.account,
  });

  VoidCallback onDeleteAccount(BuildContext context, Account account) {
    return () {
      AccountBookData().deleteAccount(account).then((_) {
        if (context.autoPushEvent) {
          pushEvent(
              context.serverAddr,
              Event(
                id: account.id,
                name: "delete account ${account.title}",
                date: nowStr(),
                data_type: "account",
                event_type: "delete",
                content: account.toJson().toString(),
                from: context.name,
              )).then((value) {
            if (value == "") {
              context.showSnackBar("发送事件成功");
            } else {
              context.showSnackBar("发送事件失败, 原因： $value");
            }
          });
        }
      }).then((_) {
        eventBus.fire(EventAccountDeleted());
      });
    };
  }

  VoidCallback uploadAccount(BuildContext context, Account account) {
    return () {
      pushEvent(
          context.serverAddr,
          Event(
            id: account.id,
            name: "upload account ${account.title}",
            date: nowStr(),
            data_type: "account",
            event_type: "update",
            content: account.toJson().toString(),
            from: context.name,
          )).then((value) {
        if (value == "") {
          context.showSnackBar("上传成功");
        } else {
          context.showSnackBar("上传失败, 原因： $value");
        }
      });
    };
  }

  VoidCallback onAccountCopy(context, account) {
    return () {
      copyToClipboard(account.account);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).pop();
          });
          return const AlertDialog(
            title: Text('已复制'),
          );
        },
      );
    };
  }

  VoidCallback onPasswordCopy(context, account) {
    return () {
      copyToClipboard(account.password);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).pop();
          });
          return const AlertDialog(
            title: Text('已复制'),
          );
        },
      );
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
              account.title,
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
              icon: const Icon(Icons.switch_account),
              onPressed: onAccountCopy(context, account),
              tooltip: '复制账号',
            )),
            Expanded(
                child: IconButton(
              icon: const Icon(Icons.password_outlined),
              onPressed: onPasswordCopy(context, account),
              tooltip: '复制密码',
            )),
            Expanded(
                child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: _showInfo(context, account),
              tooltip: '详情',
            )),
            Expanded(
                child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDeleteAccount(context, account),
              tooltip: '删除',
              // disabledColor: _isEditing ? Colors.grey : Colors.red,
            )),
            Expanded(
                child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: uploadAccount(context, account),
            ))
          ],
        )),
        Spacer(),
      ],
    );
  }

  VoidCallback _showInfo(context, account) {
    return () {
      DetailPage(context: context, account: account).build();
    };
  }
}
