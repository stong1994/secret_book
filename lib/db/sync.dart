import 'dart:convert';

import 'package:secret_book/db/account.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/db/info.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/model/token.dart';

Future<String> syncDataFromServer(
  String serverAddr,
  String lastSyncDate,
  String from,
) async {
  if (serverAddr == "") {
    return "服务器地址为空";
  }
  if (from == "") {
    return "来源未设置";
  }

  bool unFinished = true;

  while (unFinished) {
    try {
      List<Event> events = await getEvents(serverAddr, lastSyncDate);
      if (events.isEmpty) {
        unFinished = false;
        continue;
      }
      for (var event in events) {
        if (event.from == from) {
          continue;
        }
        await consumeEvent(event);
      }
      lastSyncDate = events.last.date;
    } catch (e) {
      await updateSyncDate(lastSyncDate);
      return "同步中断，原因: $e";
    }
  }
  await updateSyncDate(lastSyncDate);
  return "已同步至最新";
}

Future<void> consumeEvent(Event event) async {
  switch (event.data_type) {
    case 'token':
      return consumeTokenEvent(event);
    case 'account':
      return consumeAccountEvent(event);
    case 'google_auth':
      return consumeGoogleAuthEvent(event);
    default:
      throw ('Invalid data type: ${event.data_type}');
  }
}

Future<void> consumeAccountEvent(Event event) async {
  switch (event.event_type.toLowerCase()) {
    case 'create':
      var account = Account.fromJson(jsonDecode(event.content));
      AccountBookData().saveAccount(account);
      return;
    case 'update':
      var account = Account.fromJson(jsonDecode(event.content));
      AccountBookData().saveAccount(account);
      return;
    case 'delete':
      var account = Account.fromJson(jsonDecode(event.content));
      AccountBookData().deleteAccount(account);
      return;
    default:
      throw ('Invalid event type: ${event.event_type}');
  }
}

Future<void> consumeTokenEvent(Event event) async {
  switch (event.event_type.toLowerCase()) {
    case 'create':
      var token = Token.fromJson(jsonDecode(event.content));
      TokenBookData().saveToken(token);
      return;
    case 'update':
      var token = Token.fromJson(jsonDecode(event.content));
      TokenBookData().saveToken(token);
      return;
    case 'delete':
      var token = Token.fromJson(jsonDecode(event.content));
      TokenBookData().deleteToken(token);
      return;
    default:
      throw ('Invalid event type: ${event.event_type}');
  }
}

Future<void> consumeGoogleAuthEvent(Event event) async {
  switch (event.event_type.toLowerCase()) {
    case 'create':
      var googleAuth = GoogleAuth.fromJson(jsonDecode(event.content));
      GoogleAuthBookData().saveGoogleAuth(googleAuth);
      return;
    case 'update':
      var googleAuth = GoogleAuth.fromJson(jsonDecode(event.content));
      GoogleAuthBookData().saveGoogleAuth(googleAuth);
      return;
    case 'delete':
      var googleAuth = GoogleAuth.fromJson(jsonDecode(event.content));
      GoogleAuthBookData().deleteGoogleAuth(googleAuth);
      return;
    default:
      throw ('Invalid event type: ${event.event_type}');
  }
}

Future<void> updateSyncDate(String date) async {
  return InfoData().saveLastSyncDate(date);
}
