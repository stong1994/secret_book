class Token {
  String id;
  String title;
  String content;

  Token({
    this.id = "",
    this.title = "",
    this.content = "",
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'id': id,
      };

  Token copyWith({
    String? title,
    String? id,
    String? content,
  }) {
    return Token(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
