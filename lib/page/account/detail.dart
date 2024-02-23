import 'package:flutter/material.dart';
import 'package:secret_book/db/account.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/utils/time.dart';

class EventAccountUpdated {}

class DetailPage {
  final Account account;
  final BuildContext context;

  DetailPage({
    Key? key,
    required this.context,
    required this.account,
  }) {
    initState();
  }

  late TextEditingController _titleEditingController;
  late TextEditingController _accountEditingController;
  late TextEditingController _passwordEditingController;
  late TextEditingController _commentEditingController;
  bool _isEditingTitle = false;
  bool _isShowPwd = false;

  void initState() {
    _titleEditingController = TextEditingController(text: account.title);
    _accountEditingController = TextEditingController(text: account.account);
    _passwordEditingController = TextEditingController(text: account.password);
    _commentEditingController = TextEditingController(text: account.comment);
  }

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
              title:
                  _isEditingTitle ? _editTitle(setState) : _showTitle(setState),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextField(
                    controller: _accountEditingController,
                    label: "账号",
                  ),
                  buildPasswordField(
                    controller: _passwordEditingController,
                    label: "密码",
                    setState: setState,
                  ),
                  buildTextField(
                    controller: _commentEditingController,
                    label: "备注",
                  ),
                ],
              ),
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
                    AccountBookData()
                        .updateAccount(Account(
                      id: account.id,
                      title: _titleEditingController.text,
                      account: _accountEditingController.text,
                      password: _passwordEditingController.text,
                      comment: _commentEditingController.text,
                    ))
                        .then((newAccount) {
                      if (context.autoPushEvent) {
                        pushEvent(
                            context.serverAddr,
                            Event(
                              id: newAccount.id,
                              name: "update account ${newAccount.title}",
                              date: nowStr(),
                              data_type: "account",
                              event_type: "update",
                              content: newAccount.toJson().toString(),
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
                      eventBus.fire(EventAccountUpdated());
                    }).then((value) => dispose);
                    // _contentEditingController.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  Widget _editTitle(setState) {
    return TextFormField(
      controller: _titleEditingController,
      autofocus: true,
      style: TextStyle(fontSize: 18.0, color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.grey.shade400,
          ),
        ),
      ),
      onFieldSubmitted: (value) {
        // account.title = _accountEditingController.text;
      },
      onTapOutside: (event) => setState(() {
        // _isEditingTitle = false;
      }),
    );
  }

  Widget _showTitle(setState) {
    return GestureDetector(
        onTap: () => {
              setState(() {
                _isEditingTitle = true;
              })
            },
        child: Text(account.title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )));
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required setState,
  }) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          obscureText: !_isShowPwd,
        )),
        IconButton(
          icon: _isShowPwd
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
          onPressed: changePwdStatus(setState),
          tooltip: _isShowPwd ? '隐藏密码' : '显示密码',
        ),
      ],
    );
  }

  VoidCallback changePwdStatus(setState) {
    return () {
      setState(() {
        _isShowPwd = !_isShowPwd;
      });
    };
  }
}
