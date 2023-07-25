import 'package:flutter/material.dart';
import 'db/token.dart';
import 'model/token.dart';

class TokenBook extends StatefulWidget {
  const TokenBook({super.key});

  @override
  _TokenBookState createState() => _TokenBookState();
}

class _TokenBookState extends State<TokenBook> {
  final _titleEditingController = TextEditingController();
  final _contentEditingController = TextEditingController();
  late final SecretBookData _secretData;

  @override
  void initState() {
    super.initState();
    _secretData = SecretBookData();
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
        margin: EdgeInsets.all(16),
        color: Colors.grey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              mainArea(),
              Container(
                padding: EdgeInsets.only(bottom: 16, right: 10),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: onAdd,
                  child: Icon(Icons.add),
                ),
              )
            ]));
  }

  Widget mainArea() {
    return Expanded(
        child: FutureBuilder<List<Secret>>(
            future: _secretData.fetchSecrets(),
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

              List<Secret> secrets = snapshot.data!;
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: secrets.length,
                  itemBuilder: (context, index) {
                    return SecretAction(
                        secret: secrets[index],
                        onSecretUpdated: onSecretUpdate,
                        onSecretDeleted: onSecretDelete);
                  });
            }));
  }

  // void onClean() {
  //   setState(() {
  //     SecretBookData().clean();
  //   });
  // }

  void onSecretAdd(String title, String content) {
    setState(() {
      SecretBookData().addSecret(Secret(title: title, content: content));
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
                onSecretAdd(title, content);
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

  void onSecretDelete(Secret secret) {
    setState(() {
      _secretData.deleteSecret(secret);
    });
  }

  void onSecretUpdate(Secret secret) {
    setState(() {
      _secretData.updateSecret(secret);
    });
  }
}
