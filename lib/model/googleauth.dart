import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/state.dart';
import 'package:secret_book/model/type.dart';

class GoogleAuth {
  String id;
  String token;
  String title;
  String date;
  String comment;

  GoogleAuth({
    this.id = "",
    this.token = "",
    this.title = "",
    this.date = "",
    this.comment = "",
  });

  factory GoogleAuth.fromJson(Map<String, dynamic> json) {
    return GoogleAuth(
        id: json['id'],
        token: json['token'],
        title: json['title'],
        date: json['date'] ?? "",
        comment: json['comment'] ?? "");
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'title': title,
        'id': id,
        'date': date,
        'comment': comment,
      };

  GoogleAuth copyWith({
    String? token,
    String? id,
    String? title,
    String? date,
    String? comment,
  }) {
    return GoogleAuth(
      id: id ?? this.id,
      token: token ?? this.token,
      title: title ?? this.title,
      date: date ?? this.date,
      comment: comment ?? this.comment,
    );
  }

  factory GoogleAuth.fromState(DataState state) {
    return GoogleAuth(
      id: state.id,
      token: state.content,
      title: state.name,
      date: state.date,
      comment: state.desc,
    );
  }

  factory GoogleAuth.fromEvent(Event event) {
    return GoogleAuth(
      id: event.data_id,
      token: event.content,
      title: event.name,
      date: event.date,
      comment: event.desc,
    );
  }

  Event toEvent(EventType eventType, String from) {
    return Event(
      name: title,
      event_type: eventType,
      content: token,
      date: date,
      desc: comment,
      data_id: id,
      data_type: DataType.google_auth,
      from: from,
    );
  }
}
