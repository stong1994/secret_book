import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/state.dart';
import 'package:secret_book/model/type.dart';

class GoogleAuth {
  String id;
  String token;
  String title;
  String date;
  String desc;

  GoogleAuth({
    this.id = "",
    this.token = "",
    this.title = "",
    this.date = "",
    this.desc = "",
  });

  factory GoogleAuth.fromJson(Map<String, dynamic> json) {
    return GoogleAuth(
        id: json['id'],
        token: json['token'],
        title: json['title'],
        date: json['date'] ?? "",
        desc: json['desc'] ?? "");
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'title': title,
        'id': id,
        'date': date,
        'desc': desc,
      };

  GoogleAuth copyWith({
    String? token,
    String? id,
    String? title,
    String? date,
    String? desc,
  }) {
    return GoogleAuth(
      id: id ?? this.id,
      token: token ?? this.token,
      title: title ?? this.title,
      date: date ?? this.date,
      desc: desc ?? this.desc,
    );
  }

  factory GoogleAuth.fromState(DataState state) {
    return GoogleAuth(
      id: state.id,
      token: state.content,
      title: state.name,
      date: state.date,
      desc: state.desc,
    );
  }

  factory GoogleAuth.fromEvent(Event event) {
    return GoogleAuth(
      id: event.data_id,
      token: event.content,
      title: event.name,
      date: event.date,
      desc: event.desc,
    );
  }

  Event toEvent(EventType eventType, String from) {
    return Event(
      name: title,
      event_type: eventType,
      content: token,
      date: date,
      desc: desc,
      data_id: id,
      data_type: DataType.google_auth,
      from: from,
    );
  }
}
