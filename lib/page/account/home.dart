import 'package:flutter/material.dart';
import 'package:secret_book/db/account.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/page/account/add.dart';
import 'package:secret_book/page/account/detail.dart';
import 'package:secret_book/page/account/row.dart';

import 'button.dart';

class AccountBook extends StatefulWidget {
  const AccountBook({super.key});

  @override
  _AccountBookState createState() => _AccountBookState();
}

class _AccountBookState extends State<AccountBook> {
  late String title;
  String queryKey = "";

  Map<String, dynamic> recentlyUsedAccounts = {};
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    eventBus.on<EventAccountAdded>().listen((_) {
      setState(() {});
    });
    eventBus.on<EventAccountUpdated>().listen((_) {
      setState(() {});
    });
    eventBus.on<EventAccountDeleted>().listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(2),
      color: const Color(0xFFFCDC94),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: mainArea(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                queryButton(context, queryKey, search),
                addButton(context, recentlyUsedAccounts),
                // AddAccountButton(),
                genPwdButton(context, true),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget mainArea() {
    return FutureBuilder<List<Account>>(
        future: AccountBookData().fetchAccounts(queryKey),
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
          accounts.forEach((account) {
            recentlyUsedAccounts[account.account] = {};
          });
          return ListView.builder(
              controller: _scrollController,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return AccountRow(
                  account: accounts[index],
                );
              });
        });
  }

  void search(key) {
    setState(() {
      queryKey = key;
    });
  }
}
