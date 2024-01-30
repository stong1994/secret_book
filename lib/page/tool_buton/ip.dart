import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:secret_book/utils/ips.dart';

class IpPage {
  final BuildContext context;

  IpPage({
    required this.context,
  });

  VoidCallback build() {
    return () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: getIps(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AlertDialog(
                  title: const Text("当前IP列表"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                        snapshot.data!.length,
                        (index) => ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                              title: Text(snapshot.data![index]),
                            )),
                  ),
                  actions: [
                    TextButton(onPressed: ()=>{Navigator.pop(context)}, child: const Text('关闭'))
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
            },
          );
        },
      );
    };
  }
}
