import 'package:flutter/material.dart';
import 'secret_book.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get a better material design for
    return MaterialApp(
      title: 'Secret Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SecretBook(),
    );
  }
}
