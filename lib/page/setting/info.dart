import 'package:flutter/material.dart';
import 'package:secret_book/db/info.dart';
import 'package:secret_book/extensions/context_extension.dart';
import 'package:secret_book/model/info.dart';
import 'package:secret_book/page/setting/sync.dart';

class InfoPage extends StatefulWidget {
  InfoPage();

  @override
  State<StatefulWidget> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _serverController = TextEditingController();

  @override
  void dispose() {
    _serverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Info>(
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
                            serverPage(context, snapshot.data!.serverAddr);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("是否自动推送事件"),
                    const Spacer(),
                    Switch(
                      value: snapshot.data!.autoPushEvent,
                      onChanged: (newValue) {
                        if (newValue && snapshot.data!.serverAddr == "") {
                          needSetServer(context);
                          return;
                        }
                        InfoData().saveAutoPushEvent(newValue).then((_) {
                          context.info.autoPushEvent = newValue;
                          setState(() {});
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("拉取服务端数据"),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        if (snapshot.data!.serverAddr == "") {
                          needSetServer(context);
                          return;
                        }
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SyncDataWidget(
                                info: snapshot.data!,
                              );
                            });
                      },
                      icon: const Icon(Icons.sync),
                    )
                  ],
                )
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('${snapshot.error}'),
          );
        }
        return const CircularProgressIndicator();
      },
    );
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

void needSetServer(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).pop(true);
        });
        return const AlertDialog(
          title: Text("需要先设置服务端地址"),
        );
      });
}
