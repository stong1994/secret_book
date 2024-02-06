import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/utils/time.dart';

class EventTokenCreated {}

class AddPage {
  final BuildContext context;

  final _titleEditingController = TextEditingController();
  final _contentEditingController = TextEditingController();

  AddPage({
    required this.context,
  });

  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
  }

  VoidCallback build() {
    return () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('添加数据',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
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
                  onTokenAdd();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    };
  }

  void onTokenAdd() {
    TokenBookData()
        .addToken(Token(
      title: _titleEditingController.text,
      content: _contentEditingController.text,
    ))
        .then((token) {
      if (!context.autoPushEvent) {
        return;
      }
      pushEvent(
          context.serverAddr,
          Event(
            name: "create token ${token.title}",
            date: nowStr(),
            data_type: "token",
            event_type: "create",
            content: token.toJson().toString(),
            from: context.name,
          ));
      // dispose();
    }).then((value) {
      eventBus.fire(EventTokenCreated());
    });
  }
}
