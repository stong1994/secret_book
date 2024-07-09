import 'package:flutter/material.dart';
import 'package:secret_book/db/info.dart';
import 'package:secret_book/db/scheme.dart';
import 'package:secret_book/utils/app_bloc.dart';
import 'home.dart';

void main() async {
  await initializeDB();
  var info = await InfoData().getInfo();
  runApp(
    AppBloc(
      appState: AppStateNotifier(
        state: AppState(
          info: info,
        ),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // get a better material design for
    return MaterialApp(
      title: '密码本',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Home(),
    );
  }
}
