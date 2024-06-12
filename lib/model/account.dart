import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/state.dart';
import 'package:secret_book/model/type.dart';

class Account {
  String id;
  String title;
  String account;
  String password;
  String comment;
  String date;

  Account({
    this.id = "",
    this.title = "",
    this.account = "",
    this.password = "",
    this.comment = "",
    this.date = "",
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      title: json['title'],
      account: json['account'],
      password: json['password'],
      comment: json['comment'],
      date: json['date'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'account': account,
        'password': password,
        'comment': comment,
        'id': id,
        'date': date,
      };

  Account copyWith({
    String? title,
    String? id,
    String? account,
    String? password,
    String? comment,
  }) {
    return Account(
      id: id ?? this.id,
      title: title ?? this.title,
      account: account ?? this.account,
      password: password ?? this.password,
      comment: comment ?? this.comment,
    );
  }

  Event toEvent(EventType eventType, String from) {
    return Event(
      name: title,
      event_type: eventType,
      content: "$account $password $comment",
      date: date,
      data_id: id,
      data_type: DataType.account,
      from: from,
    );
  }

  factory Account.fromEvent(Event event) {
    var content = event.content.split(" ");
    return Account(
      id: event.data_id,
      title: event.name,
      date: event.date,
      account: content.first,
      password: content.length > 1 ? content[1] : "",
      comment: content.length > 2 ? content[2] : "",
    );
  }

  factory Account.fromState(DataState state) {
    var content = state.content.split(" ");
    return Account(
      id: state.id,
      title: state.name,
      date: state.date,
      account: content.first,
      password: content.length > 1 ? content[1] : "",
      comment: content.length > 2 ? content[2] : "",
    );
  }
}
