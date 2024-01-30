import 'dart:io';

Future<List<String>> getIps() async {
  // Get the list of network interfaces
  List<NetworkInterface> interfaces = await NetworkInterface.list();
  return List.generate(
      interfaces.length, (index) => interfaces[index].addresses.first.address);
}
