String nowStr() {
  DateTime now = DateTime.now();
  return '${now.year}-${twoDigits(now.month)}-${twoDigits(now.day)} ${twoDigits(now.hour)}:${twoDigits(now.minute)}:${twoDigits(now.second)}';
}

String twoDigits(int n) {
  if (n >= 10) {
    return "$n";
  }
  return "0$n";
}

bool dateAfter(String d1, String d2) {
  return d1.compareTo(d2) > 0;
}
