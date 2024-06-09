import 'dart:convert';

import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/info.dart';
import 'package:secret_book/utils/time.dart';

import '../../db/account.dart';
import '../../model/account.dart';
import 'package:flutter/material.dart';
import 'button.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class EventAccountAdded {}

class AddAccountButton {
  void build(
      BuildContext context, Map<String, dynamic> recentlyUsedAccounts) async {
    final appState = context.appState;
    final account = await showAddDialog(context, recentlyUsedAccounts);
    if (account != null) {
      AccountBookData().addAccount(account);
      Info info = appState.info;
      if (info.autoPushEvent) {
        pushEvent(
                info.serverAddr,
                Event(
                    id: account.id,
                    name: "add account ${account.title}",
                    date: nowStr(),
                    data_type: "account",
                    event_type: "create",
                    content: jsonEncode(account.toJson()),
                    from: info.name))
            .then((value) {
          if (value == "") {
            context.showSnackBar("发送事件成功");
          } else {
            context.showSnackBar("发送事件失败, 原因： $value");
          }
        });
      }
      eventBus.fire(EventAccountAdded());
    }
  }

  Future<Account?> showAddDialog(
      BuildContext context, Map<String, dynamic> recentlyUsedAccounts) {
    String title = '';
    TextEditingController passwordCtrl = TextEditingController();
    TextEditingController accountCtrl = TextEditingController();
    String comment = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    hintText: '请描述标题...',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 186, 186),
                      fontSize: 16,
                    ),
                    border: UnderlineInputBorder(),
                  ),
                ),
                TypeAheadField<String>(
                  suggestionsCallback: (search) {
                    return recentlyUsedAccounts.keys
                        .map((key) => key.toLowerCase())
                        .where((key) => key.contains(search..toLowerCase()))
                        .toList();
                  },
                  controller: accountCtrl,
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        // fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        hintText: '请填写账号...',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 235, 186, 186),
                          fontSize: 16,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    );
                  },
                  itemBuilder: (context, account) {
                    return ListTile(
                      title: Text(account),
                    );
                  },
                  onSelected: (account) {
                    accountCtrl.text = account;
                  },
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      autofocus: true,
                      controller: passwordCtrl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        hintText: '请填写密码...',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 235, 186, 186),
                          fontSize: 16,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    Positioned(
                        right: 0,
                        child: genPwdButton(
                          context,
                          false,
                          callback: (String pwd) {
                            passwordCtrl.text = pwd;
                          },
                          width: 100,
                          height: 50,
                        ))
                  ],
                ),
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    comment = value;
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    hintText: '请填写备注...',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 186, 186),
                      fontSize: 16,
                    ),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ],
            )),
            actions: [
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              TextButton(
                child: const Text('完成'),
                onPressed: () {
                  Navigator.of(context).pop(Account(
                    title: title,
                    account: accountCtrl.text,
                    password: passwordCtrl.text,
                    comment: comment,
                  ));
                },
              ),
            ],
          );
        }).then((value) {
      passwordCtrl.dispose;
      accountCtrl.dispose;
      return value;
    });
  }
}
