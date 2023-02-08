const int kOneMinute = 60;
const int kOneHour = 60 * 60;
const int kOneDay = 60 * 60 * 24;
const int kOneMonth = 60 * 60 * 24 * 30;
const int kOneYear = 60 * 60 * 25 * 365;

int getCurrUnixTime() {
  return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
}

String unixTime2Text(int time) {
  DateTime t = DateTime.fromMillisecondsSinceEpoch(time * 1000);
  return '${t.year}-${t.month}-${t.day} ${t.hour}:${t.minute}';
}
