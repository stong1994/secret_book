class Event {
  String id;
  String name;
  String date;
  String event_type;
  String data_type;
  String content;
  String from;

  Event({
    this.id = "",
    this.name = "",
    this.date = "",
    this.data_type = "",
    this.event_type = "",
    this.content = "",
    this.from = "",
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      event_type: json['event_type'],
      data_type: json['data_type'],
      content: json['content'],
      from: json['from'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date,
        'event_type': event_type,
        'data_type': data_type,
        'content': content,
        'from': from,
      };
}
