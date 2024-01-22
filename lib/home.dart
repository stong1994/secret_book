import 'package:flutter/material.dart';
import 'package:secret_book/page/googleauth/home.dart';

import 'page/account/home.dart';
import 'page/data_exchange/exchange.dart';
import 'page/token/home.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const _kFontFam = 'MyFlutterApp';
  static const String? _kFontPkg = null;

  static const IconData exportIcon =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Row(children: [
            Expanded(
                child: TabBar(
              // isScrollable: true,
              controller: _tabController,
              tabs: const [
                Tab(text: 'Token'),
                Tab(text: '账号'),
                Tab(text: '谷歌身份验证器'),
              ],
            )),
            const SizedBox(width: 100),
            IconButton(
              icon: const Icon(exportIcon),
              tooltip: "导出数据",
              onPressed: export(context),
            ),
            IconButton(
              icon: const Icon(Icons.download_rounded),
              tooltip: "导入数据",
              onPressed: import(context),
            ),
          ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            TokenBook(),
            AccountBook(),
            GoogleAuthBook(),
          ],
        ),
      ),
    );
  }
}