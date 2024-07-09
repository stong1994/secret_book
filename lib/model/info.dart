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

  Info defaultInfo() {
    return Info(
      lastSyncDate: "",
      serverAddr: "localhost:12345",
      name: "1234567",
      autoPushEvent: true,
    );
  }

  Map<String, dynamic> toJson() => {
        'last_sync_date': lastSyncDate,
        'server_addr': serverAddr,
        'name': name,
        'auto_push_event': autoPushEvent ? 1 : 0,
      };
}
