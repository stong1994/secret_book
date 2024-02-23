import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:secret_book/model/event.dart';
import 'package:http/http.dart';

Future<String> pushEvent(String serverAddr, Event event) async {
  try {
    final response = await post(
      Uri.parse(handleUrl('$serverAddr/push')),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(event),
    );

    if (response.statusCode != 200) {
      throw ("push event failed: ${response.reasonPhrase}");
    }
    return "";
  } catch (e) {
    debugPrint(e.toString());
    return e.toString();
  }
}

Future<List<Event>> getEvents(String syncAddr, String lastSyncDate) async {
  var request = Request('GET', Uri.parse(handleUrl('$syncAddr/fetch')));
  // request.headers.addAll(headers);
  try {
    StreamedResponse response =
        await request.send().timeout(const Duration(seconds: 2));

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

String handleUrl(String url) {
  if (url.startsWith("http")) {
    return url;
  }
  return "http://$url";
}
