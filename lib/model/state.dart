class DataState {
  String id;
  String name;
  String data_type;
  String content;
  String desc;
  String date;

  DataState({
    this.id = "",
    this.name = "",
    this.data_type = "",
    this.content = "",
    this.desc = "",
    this.date = "",
  });

  factory DataState.fromJson(Map<String, dynamic> json) {
    return DataState(
      id: json['id'],
      name: json['name'],
      data_type: json['data_type'],
      content: json['content'],
      desc: json['desc'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'data_type': data_type,
        'content': content,
        'desc': desc,
        'date': date,
      };
}
