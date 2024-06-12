import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/state.dart';
import 'package:secret_book/model/type.dart';

class Token {
  String id;
  String title;
  String content;
  String date;

  Token({
    this.id = "",
    this.title = "",
    this.content = "",
    this.date = "",
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        date: json['date'] ?? "");
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'id': id,
        'date': date,
      };

  Token copyWith({
    String? title,
    String? id,
    String? content,
    String? date,
  }) {
    return Token(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Event toEvent(EventType eventType, String from) {
    return Event(
      name: title,
      event_type: eventType,
      content: content,
      date: date,
      data_id: id,
      data_type: DataType.token,
      from: from,
    );
  }

  factory Token.fromState(DataState state) {
    return Token(
      id: state.id,
      title: state.name,
      content: state.content,
      date: state.date,
    );
  }

  factory Token.fromEvent(Event event) {
    return Token(
      id: event.data_id,
      title: event.name,
      content: event.content,
      date: event.date,
    );
  }
}
