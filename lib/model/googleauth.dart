import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/state.dart';
import 'package:secret_book/model/type.dart';

class GoogleAuth {
  String id;
  String token;
  String title;
  String date;

  GoogleAuth({
    this.id = "",
    this.token = "",
    this.title = "",
    this.date = "",
  });

  factory GoogleAuth.fromJson(Map<String, dynamic> json) {
    return GoogleAuth(
        id: json['id'],
        token: json['token'],
        title: json['title'],
        date: json['date'] ?? "");
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'title': title,
        'id': id,
        'date': date,
      };

  GoogleAuth copyWith({
    String? token,
    String? id,
    String? title,
    String? date,
  }) {
    return GoogleAuth(
      id: id ?? this.id,
      token: token ?? this.token,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  factory GoogleAuth.fromState(DataState state) {
    return GoogleAuth(
      id: state.id,
      token: state.content,
      title: state.name,
      date: state.date,
    );
  }

  factory GoogleAuth.fromEvent(Event event) {
    return GoogleAuth(
      id: event.data_id,
      token: event.content,
      title: event.name,
      date: event.date,
    );
  }

  Event toEvent(EventType eventType, String from) {
    return Event(
      name: title,
      event_type: eventType,
      content: token,
      date: date,
      data_id: id,
      data_type: DataType.google_auth,
      from: from,
    );
  }
}
