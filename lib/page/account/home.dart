import 'package:flutter/material.dart';
import 'package:secret_book/db/account.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/page/account/row.dart';
import 'package:secret_book/utils/utils.dart';
import 'add.dart';
import 'dart:math';

import 'button.dart';

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
        color: Color.fromARGB(255, 200, 215, 200),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              mainArea(),
              addButton(context, rebuild),
              genPwdButton(context),
            ]));
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
}
