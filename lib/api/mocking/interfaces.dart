import 'dart:convert';

import '../../utils/parse_time.dart';

import 'client.dart';
import 'fake_data.dart';

const _kThreadsPerFetch = 15;
final _toBase64 = utf8.fuse(base64);

void initializationInterfaces() {
  generateRandomThreads(50);

  TestClient.onGet('/home', (_) {
    Map<String, dynamic> body = {
      'threads': sortByTime(null, 5, 0),
      'news': getNews(),
    };
    return SimpleResponse(body);
  });

  TestClient.onGet('/thread', (req) {
    final pid = int.parse(req.quaries['pid'] ?? '0');
    final fid = int.parse(req.quaries['fid'] ?? '0');
    final q = req.quaries['q'] ?? '';
    final order = int.parse(req.quaries['order'] ?? '1');
    final encodedCursor = req.quaries['cursor'] ?? '';

    //過濾合適的貼文
    final threads = filterThreads(pageID: pid, facultyID: fid, queryText: q);

    int offset = 0;

    //嘗試解析分頁指標
    if (encodedCursor.isNotEmpty) {
      final jsonCursor = _toBase64.decode(encodedCursor);
      final mappedCursor = jsonDecode(jsonCursor);
      offset = mappedCursor[1];
    }

    //排序
    late List<dynamic> result;
    if (order == 1) {
      result = sortByTime(threads, _kThreadsPerFetch, offset);
    } else {
      result = sortByHotness(threads, _kThreadsPerFetch, offset);
    }

    //生成下一頁指標
    String cursor = "";
    if (result.length >= _kThreadsPerFetch) {
      cursor = "[${getCurrUnixTime()},${offset + result.length}]";
      cursor = _toBase64.encode(cursor);
    }

    Map<String, dynamic> body = {
      'threads': result,
      'continuous': cursor,
    };

    return SimpleResponse(body);
  });
}
