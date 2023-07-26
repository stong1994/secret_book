import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/model/token.dart';

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
              Container(
                padding: const EdgeInsets.only(bottom: 16, right: 10),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: onAdd,
                  child: const Icon(Icons.add),
                ),
              )
            ]));
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

  void onTokenAdd(String title, String content) {
    setState(() {
      TokenBookData().addToken(Token(title: title, content: content));
    });
  }

  // 添加数据
  void onAdd() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('添加新数据',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )),
          content: SingleChildScrollView(
              child: Column(
            children: [
              TextField(
                // focusNode: _focusNode,
                autofocus: true,
                controller: _titleEditingController,
                decoration: const InputDecoration(
                  // fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  hintText: '请描述标题...',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 235, 186, 186),
                    fontSize: 16,
                  ),
                  border: UnderlineInputBorder(),
                ),
              ),
              TextField(
                autofocus: true,
                controller: _contentEditingController,
                decoration: const InputDecoration(
                  // fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  hintText: '请描述秘钥...',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 235, 186, 186),
                    fontSize: 16,
                  ),
                  border: UnderlineInputBorder(),
                ),
              )
            ],
          )),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('完成'),
              onPressed: () {
                String title = _titleEditingController.text;
                String content = _contentEditingController.text;
                onTokenAdd(title, content);
                _titleEditingController.clear();
                _contentEditingController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
}
