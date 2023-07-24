import 'package:flutter/material.dart';
import 'db/account_book.dart';
import 'db/api.dart';
import 'model/account.dart';

class AccountBook extends StatefulWidget {
  const AccountBook({super.key});

  @override
  _AccountBookState createState() => _AccountBookState();
}

class _AccountBookState extends State<AccountBook> {
  final _titleEditingController = TextEditingController();
  final _accountEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _commentEditingController = TextEditingController();

  late String title;
  late final AccountData _accountData;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _accountData = AccountBookData();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _accountEditingController.dispose();
    _passwordEditingController.dispose();
    _commentEditingController.dispose();
    super.dispose();
  }

  void onClean() {
    setState(() {
      AccountBookData().clean();
    });
  }

  void onAccountAdd(
      String title, String account, String password, String comment) {
    setState(() {
      AccountBookData().addAccount(Account(
        title: title,
        account: account,
        password: password,
        comment: comment,
      ));
    });
  }

  // 添加数据
  void onAdd() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('添加新数据',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )),
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('完成'),
              onPressed: () {
                onAccountAdd(
                  _titleEditingController.text,
                  _accountEditingController.text,
                  _passwordEditingController.text,
                  _commentEditingController.text,
                );
                _titleEditingController.clear();
                _accountEditingController.clear();
                _passwordEditingController.clear();
                _commentEditingController.clear();
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
    return Container(
        margin: EdgeInsets.all(16),
        color: Colors.grey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              mainArea(),
              Container(
                padding: EdgeInsets.only(bottom: 16, right: 10),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: onAdd,
                  child: Icon(Icons.add),
                ),
              ),
            ]));
  }

  void onAccountDelete(Account account) {
    setState(() {
      _accountData.deleteAccount(account);
    });
  }

  void onAccountUpdate(Account account) {
    setState(() {
      _accountData.updateAccount(account);
    });
  }

  Widget mainArea() {
    return Expanded(
        child: FutureBuilder<List<Account>>(
            future: _accountData.fetchAccounts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}}"),
                );
              }

              List<Account> accounts = snapshot.data!;
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return AccountAction(
                        account: accounts[index],
                        onAccountUpdated: onAccountUpdate,
                        onAccountDeleted: onAccountDelete);
                  });
            }));
  }
}
