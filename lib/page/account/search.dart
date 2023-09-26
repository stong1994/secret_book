import 'package:flutter/material.dart';
import 'button.dart';

class QueryPage extends StatefulWidget {
  final AfterSearchFn afterFn;

  const QueryPage({Key? key, required this.afterFn}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        autofocus: true,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: '搜索...',
        ),
        onSubmitted: (value) {
          String query = value.trim();
          widget.afterFn(query.isNotEmpty ? query : null);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
