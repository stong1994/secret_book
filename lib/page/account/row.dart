import 'package:flutter/material.dart';
import 'package:secret_book/db/account.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/page/colors.dart';
import 'package:secret_book/utils/utils.dart';
import 'detail.dart';

class EventAccountDeleted {}

class AccountRow extends StatelessWidget {
  final Account account;

  const AccountRow({
    super.key,
    required this.account,
  });

  VoidCallback onDeleteAccount(BuildContext context, Account account) {
    return () {
      AccountBookData().deleteAccount(account).then((account) {
        if (context.autoPushEvent) {
          pushEvent(
            context.serverAddr,
            account.toEvent(EventType.delete, context.name),
          ).then((value) {
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
        account.toEvent(EventType.update, context.name),
      ).then((value) {
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
    List<Widget> buttons = [
      Expanded(
          child: copyButton(null, const Icon(Icons.account_circle_outlined),
              onAccountCopy(context, account))),
      Expanded(child: copyPasswordButton(onPasswordCopy(context, account))),
      Expanded(child: infoButton(_showInfo(context, account))),
      Expanded(child: deleteButton(context, onDeleteAccount(context, account))),
    ];
    if (canSync(context)) {
      buttons
          .add(Expanded(child: uploadButton(uploadAccount(context, account))));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Expanded(
          child: Text(
            account.title,
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

  VoidCallback _showInfo(context, account) {
    return () {
      DetailPage(context: context, account: account).build();
    };
  }

  bool canSync(BuildContext context) {
    return context.serverAddr != "" && context.name != "";
  }
}
