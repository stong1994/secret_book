import 'package:flutter/material.dart';
import 'package:secret_book/db/account.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/utils/utils.dart';
import 'detail.dart';

class AccountRow extends StatefulWidget {
  final String accountID;
  final Function afterChangeFn;

  const AccountRow({
    Key? key,
    required this.accountID,
    required this.afterChangeFn,
  }) : super(key: key);

  @override
  _AccountRowState createState() => _AccountRowState();
}

class _AccountRowState extends State<AccountRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  VoidCallback onDeleteAccount(account) {
    return () {
      AccountBookData().deleteAccount(account);
      widget.afterChangeFn();
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
    return FutureBuilder<Account>(
        future: AccountBookData().getAccountByID(widget.accountID),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          final account = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    account.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                  child: Row(
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
                    onPressed: onDeleteAccount(account),
                    tooltip: '删除',
                    // disabledColor: _isEditing ? Colors.grey : Colors.red,
                  )),
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

  VoidCallback _showInfo(context, account) {
    return () {
      DetailPage(context: context, account: account)
          .build();
    };
  }
}
