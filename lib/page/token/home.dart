import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/model/token.dart';
import 'add.dart';
import 'detail.dart';

class TokenBook extends StatefulWidget {
  const TokenBook({super.key});

  @override
  _TokenBookState createState() => _TokenBookState();
}

class _TokenBookState extends State<TokenBook> {
  final _titleEditingController = TextEditingController();
  final _contentEditingController = TextEditingController();
  late final TokenBookData _tokenData;

  @override
  void initState() {
    super.initState();
    _tokenData = TokenBookData();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    super.dispose();
  }

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16),
        color: const Color.fromARGB(255, 187, 194, 187),
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
        onPressed: AddPage(context: context, afterFn: rebuild).build(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget mainArea() {
    return Expanded(
        child: FutureBuilder<List<Token>>(
            future: _tokenData.fetchTokens(),
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
                        onTokenUpdated: onTokenUpdate,
                        onTokenDeleted: onTokenDelete);
                  });
            }));
  }

  // void onClean() {
  //   setState(() {
  //     TokenBookData().clean();
  //   });
  // }

  void onTokenDelete(Token token) {
    setState(() {
      _tokenData.deleteToken(token);
    });
  }

  void onTokenUpdate(Token token) {
    setState(() {
      _tokenData.updateToken(token);
    });
  }

  void rebuild() {
    setState(() {});
  }
}