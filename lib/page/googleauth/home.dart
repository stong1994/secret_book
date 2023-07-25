import 'package:flutter/material.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/page/account/row.dart';
import 'package:secret_book/page/googleauth/add.dart';
import 'package:secret_book/page/googleauth/row.dart';

class GoogleAuthBook extends StatefulWidget {
  const GoogleAuthBook({super.key});

  @override
  _GoogleAuthBookState createState() => _GoogleAuthBookState();
}

class _GoogleAuthBookState extends State<GoogleAuthBook> {
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
            ]));
  }

  Widget addButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16, right: 10),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: onAdd(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget mainArea() {
    return Expanded(
        child: FutureBuilder<List<GoogleAuth>>(
            future: GoogleAuthBookData().fetchGoogleAuths(),
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

              List<GoogleAuth> accounts = snapshot.data!;
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return GoogleAuthRow(
                      googleAuthID: accounts[index].id,
                      afterChangeFn: rebuild,
                    );
                  });
            }));
  }

  void rebuild() {
    setState(() {});
  }

  VoidCallback onAdd() {
    return () {
      AddPage(context: context, afterFn: rebuild).build();
    };
  }
}
