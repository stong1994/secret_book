import 'package:flutter/material.dart';

import '../event/event_bus.dart';
import '../utils/utils.dart';

class Account {
  String id;
  String title;
  String account;
  String password;
  String comment;

  Account({
    this.id = "",
    this.title = "",
    this.account = "",
    this.password = "",
    this.comment = "",
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      title: json['title'],
      account: json['account'],
      password: json['password'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'account': account,
        'password': password,
        'comment': comment,
        'id': id,
      };

  Account copyWith({
    String? title,
    String? id,
    String? account,
    String? password,
    String? comment,
  }) {
    return Account(
      id: id ?? this.id,
      title: title ?? this.title,
      account: account ?? this.account,
      password: password ?? this.password,
      comment: comment ?? this.comment,
    );
  }
}

class AccountAction extends StatefulWidget {
  final Account account;
  final FocusNode? focusNode;
  final Function(Account) onAccountUpdated;
  final Function(Account) onAccountDeleted;

  const AccountAction({
    Key? key,
    required this.account,
    required this.onAccountUpdated,
    required this.onAccountDeleted,
    this.focusNode,
  }) : super(key: key);

  @override
  _AccountActionState createState() => _AccountActionState();
}

class _AccountActionState extends State<AccountAction> {
  late TextEditingController _titleEditingController;
  late TextEditingController _accountEditingController;
  late TextEditingController _passwordEditingController;
  late TextEditingController _commentEditingController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController(text: widget.account.title);
    _accountEditingController =
        TextEditingController(text: widget.account.account);
    _passwordEditingController =
        TextEditingController(text: widget.account.title);
    _commentEditingController =
        TextEditingController(text: widget.account.comment);
    eventBus.on<int>().listen((hashCode) {
      onOtherAccountEditing(hashCode);
    });
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _accountEditingController.dispose();
    _passwordEditingController.dispose();
    _commentEditingController.dispose();
    super.dispose();
  }

  onOtherAccountEditing(int hashCode) {
    if (widget.hashCode != hashCode && _isEditing) {
      _toggleEditing();
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _updateAccount(Account account) {
    widget.onAccountUpdated(account);
    _toggleEditing();
  }

  void _deleteAccount() {
    widget.onAccountDeleted(widget.account);
  }

  void onAccountCopy() {
    copyToClipboard(widget.account.account);
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
  }

  void onPasswordCopy() {
    copyToClipboard(widget.account.password);
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
  }

  Widget _build() {
    return GestureDetector(
      onTap: () {
        _toggleEditing();
        eventBus.fire(widget.hashCode);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.account.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: onAccountCopy,
                tooltip: '复制账号',
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: onPasswordCopy,
                tooltip: '复制密码',
              ),
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: _showContent,
                tooltip: '详情',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteAccount,
                tooltip: '删除',
                // disabledColor: _isEditing ? Colors.grey : Colors.red,
              ),
            ],
          ))
        ],
      ),
    );
  }

  void _showContent() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.account.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(
                controller: _accountEditingController,
                label: "账号",
              ),
              buildTextField(
                controller: _passwordEditingController,
                label: "密码",
                obscureText: true,
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('完成'),
              onPressed: () {
                _updateAccount(Account(
                  id: widget.account.id,
                  title: _titleEditingController.text,
                  account: _accountEditingController.text,
                  password: _passwordEditingController.text,
                  comment: _commentEditingController.text,
                ));
                // _contentEditingController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build();
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
    );
  }
}
