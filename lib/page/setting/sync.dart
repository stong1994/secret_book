import 'dart:io';

import 'package:flutter/material.dart';
import 'package:secret_book/db/sync.dart';
import 'package:secret_book/model/info.dart';

class SyncDataWidget extends StatefulWidget {
  final Info info;
  const SyncDataWidget({
    super.key,
    required this.info,
  });

  @override
  _SyncDataWidgetState createState() => _SyncDataWidgetState();
}

class _SyncDataWidgetState extends State<SyncDataWidget> {
  bool finished = false;
  String finishStr = "";
  Future<void> syncData() async {
    syncDataWithServer(
            widget.info.serverAddr, widget.info.lastSyncDate, widget.info.name)
        .then((_) {
      setState(() {
        sleep(const Duration(seconds: 1));
        finishStr = "同步完成";
        finished = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    syncData();
  }

  @override
  Widget build(BuildContext context) {
    if (!finished) {
      return const LoadingWidget();
      // return AlertDialog(
      // title: const Text("同步中"),
      // content: LoadingWidget(),
      // );
    }
    return AlertDialog(
      title: Text(finishStr),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
