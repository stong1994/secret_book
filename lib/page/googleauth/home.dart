import 'package:flutter/material.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/page/googleauth/add.dart';
import 'package:secret_book/page/googleauth/detail.dart';
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
    eventBus.on<EventGoogleAuthCreated>().listen((event) {
      setState(() {});
    });
    eventBus.on<EventGoogleAuthUpdated>().listen((event) {
      setState(() {});
    });
    eventBus.on<EventGoogleAuthDeleted>().listen((event) {
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
            margin: EdgeInsets.all(2),
            color: Color.fromARGB(255, 204, 216, 204),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  mainArea(),
                  addButton(),
                ])));
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
                      googleAuth: accounts[index],
                    );
                  });
            }));
  }

  VoidCallback onAdd() {
    return () {
      AddPage(context: context).build();
    };
  }
}
