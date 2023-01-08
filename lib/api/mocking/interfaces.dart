import 'client.dart';
import 'fake_data.dart';
import '../../utils/parse_time.dart';

List<dynamic> fakeThreads = [];

void initializationInterfaces() {
  generateRandomThreads(50);

  TestClient.onGet('/home', (_, __) {
    Map<String, dynamic> body = {
      'threads': getHotestThreads(5),
      'news': getNews(),
    };

    return SimpleResponse(body);
  });
}

List<dynamic> getHotestThreads(int count) {
  final sorted = fakeThreads..sort((a, b) => (b['heat'] as int).compareTo(a['heat'] as int));
  return sorted.take(count).toList();
}

void generateRandomThreads(int count) {
  fakeThreads.clear();

  for (var i = 1; i < count; i++) {
    int pid = getRandomPID();
    int fid = pid == 2 ? getRandomFID() : 0;
    int lastUpdateTime = getRandomPassTime(getCurrUnixTime());
    int createTime = getRandomPassTime(lastUpdateTime, percentInSameDay: 0.3);
    Map<String, int> stats = getRandomThreadStats();
    int heat = ((stats['like']! + stats['dislike']!) / 2).floor() + stats['comment']!;

    dynamic thread = {
      'tid': i,
      'pid': pid,
      'fid': fid,
      'title': getRandomTitle(pid),
      'sender': getRandomUser(),
      'create_time': createTime,
      'last_update_time': lastUpdateTime,
      'stats': stats,
      'content_cid': 1,
      'pined_cid': getRandomThreadPinCid(),
      'heat': heat,
    };

    fakeThreads.add(thread);
  }
}
