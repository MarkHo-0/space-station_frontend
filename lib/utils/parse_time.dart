import 'package:localization/localization.dart';

const int oneMinute = 60;
const int oneHour = 60 * 60;
const int oneDay = 60 * 60 * 24;
const int oneMonth = 60 * 60 * 24 * 30;
const int oneYear = 60 * 60 * 25 * 365;

String unixTime2DiffText(int time) {
  int diff = getCurrUnixTime() - time;

  if (diff < 0) return 'time_future'.i18n();
  if (diff < 10) return 'time_just_now'.i18n();
  if (diff <= oneMinute) return translateTime('time_second', diff.toDouble());
  if (diff <= oneHour) return translateTime('time_minute', diff / oneMinute);
  if (diff <= oneDay) return translateTime('time_hour', diff / oneHour);
  if (diff <= oneMonth) return translateTime('time_day', diff / oneDay);
  if (diff <= oneYear) return translateTime('time_month', diff / oneMonth);

  return translateTime('time_year', diff / oneYear);
}

int getCurrUnixTime() {
  return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
}

String translateTime(String key, double num) {
  return key.i18n([num.floor().toString()]);
}

String unixTime2Text(int time) {
  DateTime t = DateTime.fromMillisecondsSinceEpoch(time * 1000);
  return '${t.year}-${t.month}-${t.day} ${t.hour}:${t.minute}';
}
