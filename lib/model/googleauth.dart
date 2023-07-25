class GoogleAuth {
  String id;
  String token;
  String title;

  GoogleAuth({
    this.id = "",
    this.token = "",
    this.title = "",
  });

  factory GoogleAuth.fromJson(Map<String, dynamic> json) {
    return GoogleAuth(
      id: json['id'],
      token: json['token'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'title': title,
        'id': id,
      };

  GoogleAuth copyWith({
    String? token,
    String? id,
    String? title,
  }) {
    return GoogleAuth(
      id: id ?? this.id,
      token: token ?? this.token,
      title: title ?? this.title,
    );
  }
}
