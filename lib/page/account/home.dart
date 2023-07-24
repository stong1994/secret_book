import 'package:flutter/material.dart';
import 'package:secret_book/page/account/row.dart';
import 'package:secret_book/utils/utils.dart';
import '../../db/account.dart';
import '../../model/account.dart';
import 'add.dart';
import 'dart:math';

class AccountBook extends StatefulWidget {
  const AccountBook({super.key});

  @override
  _AccountBookState createState() => _AccountBookState();
}

class _AccountBookState extends State<AccountBook> {
  late String title;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              addButton(),
              genPwdButton(),
            ]));
  }

  Widget addButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16, right: 10),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget genPwdButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16, right: 10),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: onGenPwd,
        child: const Icon(Icons.vpn_key),
        tooltip: '生成密码',
      ),
    );
  }

  Widget mainArea() {
    return Expanded(
        child: FutureBuilder<List<Account>>(
            future: AccountBookData().fetchAccounts(),
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
                    return AccountRow(
                      accountID: accounts[index].id,
                      afterChangeFn: rebuild,
                    );
                  });
            }));
  }

  void rebuild() {
    setState(() {});
  }

  void onAdd() {
    showDialog(context: context, builder: AddPage(rebuild).build);
  }

  void onGenPwd() {
    copyToClipboard(genPwd());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).pop();
        });
        return const AlertDialog(
          title: Text('新密码已复制到粘贴板'),
        );
      },
    );
  }

  String genPwd() {
    const littleChars = 'abcdefghijklmnopqrstuvwxyz';
    const bigChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const specials = '~!@#&^*%';
    const nums = '1234567890';
    Random random = Random();
    String str = String.fromCharCodes(Iterable.generate(
            3,
            (_) =>
                littleChars.codeUnitAt(random.nextInt(littleChars.length)))) +
        String.fromCharCodes(Iterable.generate(
            3, (_) => bigChars.codeUnitAt(random.nextInt(bigChars.length)))) +
        String.fromCharCodes(Iterable.generate(
            2, (_) => specials.codeUnitAt(random.nextInt(specials.length)))) +
        String.fromCharCodes(Iterable.generate(
            2, (_) => nums.codeUnitAt(random.nextInt(nums.length))));
    var chars = str.split('');
    chars.shuffle();
    return chars.join('');
  }
}
