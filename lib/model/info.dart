class Info {
  String lastSyncDate;
  String serverAddr;
  String name;
  bool autoPushEvent;

  Info({
    this.lastSyncDate = "",
    this.serverAddr = "",
    this.name = "",
    this.autoPushEvent = true,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      lastSyncDate: json['last_sync_date'],
      serverAddr: json['server_addr'],
      name: json['name'],
      autoPushEvent: json['auto_push_event'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() => {
        'last_sync_date': lastSyncDate,
        'server_addr': serverAddr,
        'name': name,
        'auto_push_event': autoPushEvent,
      };
}
