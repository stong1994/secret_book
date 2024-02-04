import 'dart:io';

import 'package:flutter/material.dart';
import 'package:secret_book/db/info.dart';
import 'package:secret_book/utils/app_bloc.dart';
import 'home.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
    // this step, it will use the sqlite version available on the system.
    databaseFactory = databaseFactoryFfi;
  }
  var info = await InfoData().getInfo();
  runApp(
    AppBloc(
      appState: AppStateNotifier(
        state: AppState(
          info: info,
        ),
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get a better material design for
    return MaterialApp(
      title: '密码本',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
