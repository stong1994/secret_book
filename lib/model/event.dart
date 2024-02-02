class Event {
  String name;
  String date;
  String event_type;
  String data_type;
  String content;
  String from;

  Event({
    this.name = "",
    this.date = "",
    this.data_type = "",
    this.event_type = "",
    this.content = "",
    this.from = "",
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      date: json['date'],
      event_type: json['event_type'],
      data_type: json['data_type'],
      content: json['content'],
      from: json['from'],
    );
  }
}
