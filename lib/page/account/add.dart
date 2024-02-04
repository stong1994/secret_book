import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/info.dart';
import 'package:secret_book/utils/app_bloc.dart';

import '../../db/account.dart';
import '../../model/account.dart';
import 'package:flutter/material.dart';
import 'button.dart';

class AddAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    return ValueListenableBuilder(
        valueListenable: appState,
        builder: (context, state, _) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () async {
                final account = await showAddDialog(context);
                if (account != null) {
                  AccountBookData().addAccount(account);
                  Info info = appState.info;
                  if (info.autoPushEvent) {
                    
                  }
                  // appState.addAccount(account);
                }
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }

  Future<Account?> showAddDialog(BuildContext context) {
    String title = '';

    showDialog(
        context: context,
        builder: (context) {
          print("hi... ${context.info.autoPushEvent}");
          return AlertDialog(
            content: SingleChildScrollView(
                child: Column(
              children: [
                const TextField(
                  // focusNode: _focusNode,
                  autofocus: true,
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: InputDecoration(
                    // fillColor: Colors.white,
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
                TextField(
                  autofocus: true,
                  controller: _accountEditingController,
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
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      autofocus: true,
                      controller: _passwordEditingController,
                      decoration: const InputDecoration(
                        // fillColor: Colors.white,
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
                          callback: (String pwd) {
                            _passwordEditingController.text = pwd;
                          },
                          width: 100,
                          height: 50,
                        ))
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: _commentEditingController,
                  decoration: const InputDecoration(
                    // fillColor: Colors.white,
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
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('完成'),
                onPressed: () {
                  onAccountAdd();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  } // dispose(); todo dispose()会导致“取消”后报错：A TextEditingController was used after being disposed.暂时还不知道问题原因
}

class AddPage {
  final BuildContext context;
  final Function afterFn;

  AddPage({
    required this.context,
    required this.afterFn,
  });

  final _titleEditingController = TextEditingController();
  final _accountEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _commentEditingController = TextEditingController();

  void dispose() {
    _titleEditingController.dispose();
    _accountEditingController.dispose();
    _passwordEditingController.dispose();
    _commentEditingController.dispose();
  }

  void onAccountAdd() {
    AccountBookData()
        .addAccount(Account(
      title: _titleEditingController.text,
      account: _accountEditingController.text,
      password: _passwordEditingController.text,
      comment: _commentEditingController.text,
    ))
        .then((_) {
      afterFn();
    });
  }

  void build() {
    showDialog(
        context: context,
        builder: (context) {
          print("hi... ${context.info.autoPushEvent}");
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  TextField(
                    // focusNode: _focusNode,
                    autofocus: true,
                    controller: _titleEditingController,
                    decoration: const InputDecoration(
                      // fillColor: Colors.white,
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
                  TextField(
                    autofocus: true,
                    controller: _accountEditingController,
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
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        autofocus: true,
                        controller: _passwordEditingController,
                        decoration: const InputDecoration(
                          // fillColor: Colors.white,
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
                            callback: (String pwd) {
                              _passwordEditingController.text = pwd;
                            },
                            width: 100,
                            height: 50,
                          ))
                    ],
                  ),
                  TextField(
                    autofocus: true,
                    controller: _commentEditingController,
                    decoration: const InputDecoration(
                      // fillColor: Colors.white,
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
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('完成'),
                  onPressed: () {
                    onAccountAdd();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        }).then((_) {
      // dispose(); todo dispose()会导致“取消”后报错：A TextEditingController was used after being disposed.暂时还不知道问题原因
    });
  }
}
