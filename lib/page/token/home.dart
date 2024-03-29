import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/model/token.dart';
import 'add.dart';
import 'detail.dart';

class TokenBook extends StatefulWidget {
  const TokenBook({super.key});

  @override
  _TokenBookState createState() => _TokenBookState();
}

class _TokenBookState extends State<TokenBook> {

  @override
  void initState() {
    super.initState();
    eventBus.on<EventTokenCreated>().listen((_) {
      setState(() {});
    });
    eventBus.on<EventTokenUpdated>().listen((_) {
      setState(() {});
    });
    eventBus.on<EventTokenDeleted>().listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.all(2),
            color: const Color.fromARGB(255, 187, 194, 187),
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
        onPressed: AddPage(context: context).build(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget mainArea() {
    return Expanded(
        child: FutureBuilder<List<Token>>(
            future: TokenBookData().fetchTokens(),
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

              List<Token> tokens = snapshot.data!;
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: tokens.length,
                  itemBuilder: (context, index) {
                    return TokenAction(
                      token: tokens[index],
                    );
                  });
            }));
  }
}
