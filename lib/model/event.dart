import 'package:secret_book/model/type.dart';

enum EventType {
  create,
  update,
  delete,
}

EventType getEventTypeFromString(String type) {
  switch (type) {
    case 'create':
      return EventType.create;
    case 'update':
      return EventType.update;
    case 'delete':
      return EventType.delete;
    default:
      throw ArgumentError('Invalid type string: $type');
  }
}

class Event {
  String id;
  String name;
  String date;
  EventType event_type;
  String data_id;
  DataType data_type;
  String content;
  String from;

  Event({
    this.id = "",
    this.name = "",
    this.date = "",
    this.data_type = DataType.account,
    this.data_id = "",
    this.event_type = EventType.create,
    this.content = "",
    this.from = "",
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      event_type: getEventTypeFromString(json['event_type']),
      data_id: json['data_id'],
      data_type: getDataTypeFromString(json['data_type']),
      content: json['content'],
      from: json['from'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date,
        'event_type': event_type.name,
        'data_id': data_id,
        'data_type': data_type.name,
        'content': content,
        'from': from,
      };
}
