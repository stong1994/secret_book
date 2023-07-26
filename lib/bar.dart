import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:secret_book/db/export.dart';
import 'package:secret_book/page/googleauth/home.dart';
import 'package:secret_book/utils/utils.dart';

import 'page/account/home.dart';
import 'token_book.dart';

class Bar extends StatefulWidget {
  @override
  _BarState createState() => _BarState();
}

class _BarState extends State<Bar> with SingleTickerProviderStateMixin {
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 10),
          child: AppBar(
            // title: Text('Navigation Bar Demo'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Token'),
                Tab(text: '账号'),
                Tab(text: '谷歌身份验证器'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(exportIcon),
                onPressed: () {
                  selectDirectory()
                      .then((dir) => exportTablesToJson(dir).then((success) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(
                                      const Duration(milliseconds: 5000), () {
                                    Navigator.of(context).pop();
                                  });
                                  return const AlertDialog(
                                    title: Text('文件已保存'),
                                  );
                                });
                          }));
                },
              ),
            ],
          ),
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
