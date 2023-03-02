import 'package:flutter/material.dart';
import 'db/from_sqlite.dart';
import 'db/secret_data.dart';
import 'model/secret.dart';

class SecretBook extends StatefulWidget {
  const SecretBook({super.key});

  @override
  _SecretBookState createState() => _SecretBookState();
}

class _SecretBookState extends State<SecretBook> {
  final _titleEditingController = TextEditingController();
  final _contentEditingController = TextEditingController();

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    super.dispose();
  }

  void onClean() {
    setState(() {
      SqliteData().clean();
    });
  }

  void onSecretAdd(String title, String content) {
    setState(() {
      SqliteData().addSecret(Secret(title: title, content: content));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("秘钥簿"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAdd,
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: onClean,
          ),
        ],
      ),
      body: SecretList(),
    );
  }
}

class SecretList extends StatefulWidget {
  @override
  _SecretListState createState() => _SecretListState();
}

class _SecretListState extends State<SecretList> {
  late String title;
  late final SecretData _secretData;

  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _secretData = SqliteData();
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
            ]));
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
}
