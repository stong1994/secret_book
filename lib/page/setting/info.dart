import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:secret_book/db/info.dart';
import 'package:secret_book/page/setting/sync.dart';

class InfoPage {
  final BuildContext context;

  InfoPage({
    required this.context,
  });

  final _serverController = TextEditingController();

  VoidCallback build() {
    return () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: InfoData().getInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AlertDialog(
                    title: const Text("设置"),
                    content: Column(
                      children: [
                        Row(
                          children: [
                            const Text('服务端地址'),
                            const Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    serverPage(
                                        context, snapshot.data!.serverAddr);
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    SyncDataWidget(info: snapshot.data!);
                                  },
                                  icon: const Icon(Icons.sync),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text('关闭'))
                    ],
                    actionsAlignment: MainAxisAlignment.center,
                  );
                }
                if (snapshot.hasError) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text('${snapshot.error}'),
                  );
                }
                return const CircularProgressIndicator();
              });
        },
      );
    };
  }

  void serverPage(context, serverAddr) {
    _serverController.text = serverAddr;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("编辑服务端地址"),
            content: TextField(
              autofocus: true,
              controller: _serverController,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  InfoData().saveServerAddr(_serverController.text);
                  Navigator.of(context).pop();
                },
                child: const Text("确认"),
              )
            ],
          );
        });
  }
}
