import 'dart:collection';
import 'dart:convert';

import 'package:secret_book/db/account.dart';
import 'package:secret_book/db/googleauth.dart';
import 'package:secret_book/db/info.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/model/account.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/googleauth.dart';
import 'package:secret_book/model/state.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/model/type.dart';
import 'package:secret_book/utils/show_error.dart';
import 'package:secret_book/utils/time.dart';

Future<void> syncDataWithServer(
  String serverAddr,
  String lastSyncDate,
  String from,
) async {
  if (serverAddr == "") {
    showError("服务器地址为空");
    return;
  }
  if (from == "") {
    showError("来源未设置");
    return;
  }
  print("syncing token data");
  // await syncTokenWithServer(serverAddr, lastSyncDate, from);
  print("syncing account data");
  await syncAccountWithServer(serverAddr, lastSyncDate, from);
  // print("syncing googel auth data");
  // await syncGoogleAuthWithServer(serverAddr, lastSyncDate, from);
}

Future<void> syncTokenWithServer(
  String serverAddr,
  String lastSyncDate,
  String from,
) async {
  List<Token> localTokens = await TokenBookData().fetchTokens();
  List<DataState> remoteTokens =
      await dataFromServer(serverAddr, DataType.token);
  // convert to map for quick search
  LinkedHashMap<String, Token> localTokenMap =
      LinkedHashMap<String, Token>.fromIterable(localTokens, key: (e) => e.id);
  LinkedHashMap<String, DataState> remoteTokenMap =
      LinkedHashMap<String, DataState>.fromIterable(remoteTokens,
          key: (e) => e.id);
  // add to local if local is not exists or older  & update to remote if local is newer
  await Future.forEach(remoteTokens, (remote) async {
    var local = localTokenMap[remote.id];
    if (local == null || dateAfter(remote.date, local.date)) {
      await TokenBookData().saveToken(Token.fromState(remote));
    } else if (dateAfter(local.date, remote.date)) {
      await pushEvent(serverAddr, local.toEvent(EventType.update, from));
    }
  });

  // add to remote if remote is not exist
  await Future.forEach(localTokens, (local) async {
    if (!remoteTokenMap.containsKey(local.id)) {
      await pushEvent(serverAddr, local.toEvent(EventType.create, from));
    }
  });
  // TODO: handle delete
}

Future<void> syncAccountWithServer(
  String serverAddr,
  String lastSyncDate,
  String from,
) async {
  var locals = await AccountBookData().fetchAccounts("");
  var remotes = await dataFromServer(serverAddr, DataType.account);
  // convert to map for quick search
  var localMap = Map.fromIterable(locals, key: (e) => e.id);
  var remoteMap = Map.fromIterable(remotes, key: (e) => e.id);
  // add to local if local is not exists or older  & update to remote if local is newer
  await Future.forEach(remotes, (remote) async {
    var local = localMap[remote.id];
    if (local == null || dateAfter(remote.date, remote.date)) {
      await AccountBookData().saveAccount(Account.fromState(remote));
    } else if (dateAfter(remote.date, local.date)) {
      await pushEvent(serverAddr, local.toEvent(EventType.update, from));
    }
  });

  // add to remote if remote is not exist
  await Future.forEach(locals, (local) async {
    if (!remoteMap.containsKey(local.id)) {
      await pushEvent(serverAddr, local.toEvent(EventType.create, from));
    }
  });
  // TODO: handle delete
}

Future<void> syncGoogleAuthWithServer(
  String serverAddr,
  String lastSyncDate,
  String from,
) async {
  List<GoogleAuth> locals = await GoogleAuthBookData().fetchGoogleAuths();
  var remotes = await dataFromServer(serverAddr, DataType.google_auth);
  // convert to map for quick search
  var localMap = Map.fromIterable(locals, key: (e) => e.id);
  var remoteMap = Map.fromIterable(remotes, key: (e) => e.id);
  // add to local if local is not exists or older  & update to remote if local is newer
  await Future.forEach(remotes, (remote) async {
    var local = localMap[remote.id];
    if (local == null || dateAfter(remote.date, local.date)) {
      await GoogleAuthBookData().saveGoogleAuth(GoogleAuth.fromState(remote));
    } else if (dateAfter(remote.date, local.date)) {
      await pushEvent(serverAddr, local.toEvent(EventType.update, from));
    }
  });

  // add to remote if remote is not exist
  await Future.forEach(locals, (local) async {
    if (!remoteMap.containsKey(local.id)) {
      await pushEvent(serverAddr, local.toEvent(EventType.create, from));
    }
  });
  // TODO: handle delete
}

Future<List<DataState>> dataFromServer(
  String serverAddr,
  DataType dataType,
) async {
  List<DataState> states = [];
  bool unFinished = true;
  String lastSyncID = "";

  while (unFinished) {
    try {
      List<DataState> data = await getStates(serverAddr, lastSyncID, dataType);
      if (data.isEmpty) {
        unFinished = false;
        continue;
      }
      lastSyncID = data.last.id;
      states.addAll(data);
    } catch (e) {
      showError("同步中断，原因: $e");
      rethrow; // make sure stop the execution
    }
  }
  return states;
}

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
    case DataType.token:
      return consumeTokenEvent(event);
    case DataType.account:
      return consumeAccountEvent(event);
    case DataType.google_auth:
      return consumeGoogleAuthEvent(event);
    default:
      throw ('Invalid data type: ${event.data_type}');
  }
}

Future<void> consumeAccountEvent(Event event) async {
  switch (event.event_type) {
    case EventType.create:
      var account = Account.fromEvent(event);
      AccountBookData().saveAccount(account);
      return;
    case EventType.update:
      var account = Account.fromEvent(event);
      AccountBookData().saveAccount(account);
      return;
    case EventType.delete:
      var account = Account.fromEvent(event);
      AccountBookData().deleteAccount(account);
      return;
    default:
      throw ('Invalid event type: ${event.event_type}');
  }
}

Future<void> consumeTokenEvent(Event event) async {
  switch (event.event_type) {
    case EventType.create:
      var token = Token.fromEvent(event);
      TokenBookData().saveToken(token);
      return;
    case EventType.update:
      var token = Token.fromEvent(event);
      TokenBookData().saveToken(token);
      return;
    case EventType.delete:
      var token = Token.fromEvent(event);
      TokenBookData().deleteToken(token);
      return;
    default:
      throw ('Invalid event type: ${event.event_type}');
  }
}

Future<void> consumeGoogleAuthEvent(Event event) async {
  switch (event.event_type) {
    case EventType.create:
      var googleAuth = GoogleAuth.fromEvent(event);
      GoogleAuthBookData().saveGoogleAuth(googleAuth);
      return;
    case EventType.update:
      var googleAuth = GoogleAuth.fromEvent(event);
      GoogleAuthBookData().saveGoogleAuth(googleAuth);
      return;
    case EventType.delete:
      var googleAuth = GoogleAuth.fromEvent(event);
      GoogleAuthBookData().deleteGoogleAuth(googleAuth);
      return;
    default:
      throw ('Invalid event type: ${event.event_type}');
  }
}

Future<void> updateSyncDate(String date) async {
  return InfoData().saveLastSyncDate(date);
}
