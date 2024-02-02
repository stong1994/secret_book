import 'dart:convert';

import 'package:secret_book/db/account.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/db/info.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/model/token.dart';

import 'package:http/http.dart' as http;

Future<String> syncDataFromServer(
  String serverAddr,
  String lastSyncDate,
  String from,
) async {
  if (serverAddr == "") {
    throw ("服务器地址为空");
  }
  if (from == "") {
    throw ("来源未设置");
  }

  bool finished = false;

  while (finished) {
    List<Event> events = await getEvents(serverAddr, lastSyncDate);
    if (events.isEmpty) {
      finished = true;
      continue;
    }
    for (var event in events) {
      if (event.from == from) {
        continue;
      }
      try {
        await consumeEvent(event);
      } catch (e) {
        await updateSyncDate(lastSyncDate);
        return "同步中断，原因: $e";
      }
    }
    lastSyncDate = events.last.date;
  }
  await updateSyncDate(lastSyncDate);
  return "已同步至最新";
}

Future<List<Event>> getEvents(String syncAddr, String lastSyncDate) async {
  var request = http.Request('GET', Uri.parse('$syncAddr/fetch'));

  // request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String body = await response.stream.bytesToString();
    List<dynamic> list = jsonDecode(body);

    List<Event> rst = [];
    for (var item in list) {
      rst.add(Event.fromJson(item));
    }
    return rst;
  } else {
    print(response.reasonPhrase);
    throw (response.reasonPhrase!); // error thrown
  }
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
  switch (event.event_type) {
    case 'create':
      var account = Account.fromJson(jsonDecode(event.content));
      AccountBookData().addAccount(account);
      return;
    case 'update':
      var account = Account.fromJson(jsonDecode(event.content));
      AccountBookData().updateAccount(account);
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
  switch (event.event_type) {
    case 'create':
      var token = Token.fromJson(jsonDecode(event.content));
      TokenBookData().addToken(token);
      return;
    case 'update':
      var token = Token.fromJson(jsonDecode(event.content));
      TokenBookData().updateToken(token);
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
  switch (event.event_type) {
    case 'create':
      var googleAuth = GoogleAuth.fromJson(jsonDecode(event.content));
      GoogleAuthBookData().addGoogleAuth(googleAuth);
      return;
    case 'update':
      var googleAuth = GoogleAuth.fromJson(jsonDecode(event.content));
      GoogleAuthBookData().updateGoogleAuth(googleAuth);
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
