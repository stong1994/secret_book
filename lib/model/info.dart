class Info {
  String lastSyncDate;
  String serverAddr;

  Info({
    this.lastSyncDate = "",
    this.serverAddr = "",
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
        lastSyncDate: json['last_sync_date'], serverAddr: json['server_addr']);
  }

  Map<String, dynamic> toJson() => {
        'last_sync_date': lastSyncDate,
        'server_addr': serverAddr,
      };
}
