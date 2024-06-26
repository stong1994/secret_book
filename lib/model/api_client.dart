import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secret_book/model/event.dart';
import 'package:http/http.dart';
import 'package:secret_book/model/state.dart';
import 'package:secret_book/model/type.dart';

Future<String> pushEvent(String serverAddr, Event event) async {
  debugPrint("pushing event: ${event.toString()}");
  try {
    final response = await post(
      Uri.parse(handleUrl('$serverAddr/push')),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(event),
    );

    if (response.statusCode != 200) {
      debugPrint(
          "push failed, url: ${handleUrl('$serverAddr/push')}, status: ${response.statusCode}");
      throw ("push event failed: ${response.reasonPhrase}");
    }
    return "";
  } catch (e) {
    debugPrint("push failed: ${e.toString()}");
    return e.toString();
  }
}

Future<List<Event>> getEvents(String syncAddr, String lastSyncDate) async {
  var request = Request('GET',
      Uri.parse(handleUrl('$syncAddr/fetch?last_sync_date=$lastSyncDate')));
  // request.headers.addAll(headers);
  try {
    StreamedResponse response =
        await request.send().timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      List<dynamic> list = jsonDecode(body);

      List<Event> rst = [];
      for (var item in list) {
        rst.add(Event.fromJson(item));
      }
      return rst;
    } else {
      throw (response.reasonPhrase!); // error thrown
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<DataState>> getStates(
    String syncAddr, String lastSyncID, DataType dataType) async {
  var request = Request(
      'GET',
      Uri.parse(handleUrl(
          '$syncAddr/fetch_states?last_sync_id=$lastSyncID&data_type=${dataType.name}')));
  // request.headers.addAll(headers);
  try {
    StreamedResponse response =
        await request.send().timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      List<dynamic> list = jsonDecode(body);

      List<DataState> rst = [];
      for (var item in list) {
        rst.add(DataState.fromJson(item));
      }
      return rst;
    } else {
      throw (response.reasonPhrase!); // error thrown
    }
  } catch (e) {
    rethrow;
  }
}

String handleUrl(String url) {
  if (url.startsWith("http")) {
    return url;
  }
  return "http://$url";
}
