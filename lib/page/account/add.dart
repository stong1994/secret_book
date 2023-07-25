import 'package:flutter/material.dart';
import '../../db/account.dart';
import '../../model/account.dart';

class AddPage {
  final BuildContext context;
  final Function afterFn;

  final _titleEditingController = TextEditingController();
  final _accountEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _commentEditingController = TextEditingController();

  AddPage({
    required this.context,
    required this.afterFn,
  });

  void dispose() {
    _titleEditingController.dispose();
    _accountEditingController.dispose();
    _passwordEditingController.dispose();
    _commentEditingController.dispose();
  }

  void build() {
    showDialog(
        context: context,
        builder: (context) {
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
                    dispose();
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
        });
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
      dispose();
    });
  }
}
