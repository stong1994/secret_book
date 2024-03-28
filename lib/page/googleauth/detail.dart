import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/utils/time.dart';

class EventGoogleAuthUpdated {}

class DetailPage {
  final GoogleAuth googleAuth;
  final BuildContext context;

  DetailPage({
    Key? key,
    required this.context,
    required this.googleAuth,
  }) {
    initState();
  }

  late TextEditingController _titleEditingController;
  late TextEditingController _tokenEditingController;
  bool _isEditingTitle = false;
  bool _isShowToken = false;

  void initState() {
    _titleEditingController = TextEditingController(text: googleAuth.title);
    _tokenEditingController = TextEditingController(text: googleAuth.token);
  }

  void dispose() {
    _titleEditingController.dispose();
    _tokenEditingController.dispose();
  }

  Future<GoogleAuth?> build() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title:
                  _isEditingTitle ? _editTitle(setState) : _showTitle(setState),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildPasswordField(
                    controller: _tokenEditingController,
                    label: "秘钥",
                    setState: setState,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    dispose();
                    Navigator.of(context).pop(googleAuth);
                  },
                ),
                TextButton(
                  child: const Text('完成'),
                  onPressed: () {
                    GoogleAuthBookData()
                        .updateGoogleAuth(GoogleAuth(
                      id: googleAuth.id,
                      title: _titleEditingController.text,
                      token: _tokenEditingController.text,
                    ))
                        .then((googleAuth) {
                      if (!context.autoPushEvent) {
                        return googleAuth;
                      }
                      pushEvent(
                          context.serverAddr,
                          Event(
                            id: googleAuth.id,
                            name: "update google auth ${googleAuth.title}",
                            date: nowStr(),
                            content: jsonEncode(googleAuth.toJson()),
                            data_type: "google_auth",
                            event_type: "update",
                            from: context.name,
                          )).then((value) {
                        if (value == "") {
                          context.showSnackBar("发送事件成功");
                        } else {
                          context.showSnackBar("发送事件失败, 原因： $value");
                        }
                      });
                      return googleAuth;
                    }).then((googleAuth) {
                      eventBus.fire(EventGoogleAuthUpdated());
                      return googleAuth;
                    }).then((googleAuth) {
                      Navigator.of(context).pop(googleAuth);
                      dispose();
                    });
                    // _contentEditingController.clear();
                  },
                ),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
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
        // googleAuth.title = _tokenEditingController.text;
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
        child: Text(googleAuth.title,
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

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required setState,
  }) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          obscureText: !_isShowToken,
        )),
        IconButton(
          icon: _isShowToken
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
          onPressed: changeTokenStatus(setState),
          tooltip: _isShowToken ? '隐藏秘钥' : '显示秘钥',
        ),
      ],
    );
  }

  VoidCallback changeTokenStatus(setState) {
    return () {
      setState(() {
        _isShowToken = !_isShowToken;
      });
    };
  }
}
