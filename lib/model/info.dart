class Info {
  int lastSyncDate;

  Info({
    this.lastSyncDate = 0,
});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      lastSyncDate: json['last_sync_date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'last_sync_date': lastSyncDate,
  };
}