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
  bool isSyncing = false;

  Future<void> syncData() async {
    setState(() {
      isSyncing = true;
    });

    syncDataFromServer(
            widget.info.serverAddr, widget.info.lastSyncDate, widget.info.name)
        .then((_) {
      setState(() {
        isSyncing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isSyncing ? null : syncData,
          child: Text('同步中。。。'),
        ),
        SizedBox(height: 16.0),
        if (isSyncing)
          CircularProgressIndicator(), // Show a progress indicator while syncing
      ],
    );
  }
}
