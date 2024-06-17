import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/utils/time.dart';
import 'package:secret_book/extensions/context_extension.dart';

class DetailPage {
  final Token token;
  final BuildContext parentContext;

  DetailPage({
    Key? key,
    required this.parentContext,
    required this.token,
  }) {
    initState();
  }

  late TextEditingController _titleEditingController;
  late TextEditingController _contentEditingController;
  late TextEditingController _commentEditingController;
  bool _isEditingTitle = false;

  void initState() {
    _titleEditingController = TextEditingController(text: token.title);
    _contentEditingController = TextEditingController(text: token.content);
    _commentEditingController = TextEditingController(text: token.comment);
  }

  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    _commentEditingController.dispose();
  }

  Future<Token?> build(Function onDataChanged) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title:
                  _isEditingTitle ? _editTitle(setState) : _showTitle(setState),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextField(
                    controller: _contentEditingController,
                    label: "token",
                  ),
                  buildTextField(
                    controller: _commentEditingController,
                    label: "描述",
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    dispose();
                    Navigator.of(context).pop(token);
                  },
                ),
                TextButton(
                    child: const Text('完成'),
                    onPressed: () {
                      TokenBookData()
                          .updateToken(Token(
                        id: token.id,
                        title: _titleEditingController.text,
                        content: _contentEditingController.text,
                        comment: _commentEditingController.text,
                        date: nowStr(),
                      ))
                          .then(
                        (token) {
                          if (!context.autoPushEvent) {
                            return token;
                          }
                          pushEvent(
                            context.serverAddr,
                            token.toEvent(EventType.update, context.name),
                          ).then((value) {
                            if (value == "") {
                              parentContext.showSnackBar("发送事件成功");
                            } else {
                              parentContext.showSnackBar("发送事件失败, 原因： $value");
                            }
                          }).then((token) {
                            Navigator.of(context).pop(token);
                            onDataChanged();
                          });
                        },
                      );
                    }),
              ],
            );
          });
        });
  }

  Widget _editTitle(setState) {
    return TextFormField(
      controller: _titleEditingController,
      autofocus: true,
      style: const TextStyle(fontSize: 18.0, color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.grey.shade400,
          ),
        ),
      ),
      onFieldSubmitted: (value) {
        // token.title = _tokenEditingController.text;
      },
      // onTapOutside: (event) => setState(() {
      //   // _isEditingTitle = false;
      // }),
    );
  }

  Widget _showTitle(setState) {
    return GestureDetector(
        onTap: () => {
              setState(() {
                _isEditingTitle = true;
              })
            },
        child: Text(token.title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )));
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
