import 'package:flutter/material.dart';

import 'account_book.dart';
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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 10),
          child: AppBar(
            // title: Text('Navigation Bar Demo'),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Token'),
                Tab(text: '账号'),
                // Tab(icon: Icon(Icons.person), text: 'Profile'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            TokenBook(),
            AccountBook(),
          ],
        ),
      ),
    );
  }
}
