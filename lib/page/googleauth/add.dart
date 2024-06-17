import 'package:flutter/material.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/utils/time.dart';

class EventGoogleAuthCreated {}

class AddPage {
  final BuildContext context;

  final _titleEditingController = TextEditingController();
  final _tokenEditingController = TextEditingController();
  final _commentEditingController = TextEditingController();

  void dispose() {
    _titleEditingController.dispose();
    _tokenEditingController.dispose();
    _commentEditingController.dispose();
  }

  AddPage({
    required this.context,
  });

  void build(Function onDataChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
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
                    hintText: '请描述...',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 186, 186),
                      fontSize: 16,
                    ),
                    border: UnderlineInputBorder(),
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _tokenEditingController,
                  decoration: const InputDecoration(
                    // fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    hintText: '请填写秘钥...',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 186, 186),
                      fontSize: 16,
                    ),
                    border: UnderlineInputBorder(),
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _commentEditingController,
                  decoration: const InputDecoration(
                    // fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    hintText: '填写备注...',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 235, 186, 186),
                      fontSize: 16,
                    ),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ],
            )),
            actions: [
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  dispose();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('完成'),
                onPressed: () {
                  onAdd();
                  Navigator.of(context).pop();
                  onDataChanged();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void onAdd() {
    GoogleAuthBookData()
        .addGoogleAuth(GoogleAuth(
      title: _titleEditingController.text,
      token: _tokenEditingController.text,
      comment: _commentEditingController.text,
      date: nowStr(),
    ))
        .then((googleAuth) {
      if (!context.autoPushEvent) {
        return;
      }
      pushEvent(
        context.serverAddr,
        googleAuth.toEvent(EventType.create, context.name),
      ).then((value) {
        if (value == "") {
          context.showSnackBar("发送事件成功");
        } else {
          context.showSnackBar("发送事件失败, 原因： $value");
        }
      });
    });
  }
}
