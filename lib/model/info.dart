class Info {
  String lastSyncDate;
  String serverAddr;
  String name;

  Info({
    this.lastSyncDate = "",
    this.serverAddr = "",
    this.name = "",
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      lastSyncDate: json['last_sync_date'],
      serverAddr: json['server_addr'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'last_sync_date': lastSyncDate,
        'server_addr': serverAddr,
        'name': name,
      };
}
