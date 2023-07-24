class Account {
  String id;
  String title;
  String account;
  String password;
  String comment;

  Account({
    this.id = "",
    this.title = "",
    this.account = "",
    this.password = "",
    this.comment = "",
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      title: json['title'],
      account: json['account'],
      password: json['password'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'account': account,
        'password': password,
        'comment': comment,
        'id': id,
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
}
