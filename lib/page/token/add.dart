import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/utils/time.dart';

class AddPage {
  final BuildContext context;
  final Function onDataChanged;

  final _titleEditingController = TextEditingController();
  final _contentEditingController = TextEditingController();
  final _commentEditingController = TextEditingController();

  AddPage({
    required this.context,
    required this.onDataChanged,
  });

  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    _commentEditingController.dispose();
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
                    hintText: '请填写描述...',
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
      comment: _commentEditingController.text,
      date: nowStr(),
    ))
        .then((token) {
      if (!context.autoPushEvent) {
        return;
      }
      pushEvent(
        context.serverAddr,
        token.toEvent(EventType.create, context.name),
      ).then((value) {
        if (value == "") {
          context.showSnackBar("发送事件成功");
        } else {
          context.showSnackBar("发送事件失败, 原因： $value");
        }
      });
      // dispose();
    }).then((_) => onDataChanged());
  }
}
