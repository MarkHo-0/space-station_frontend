import 'dart:convert';

import '../../utils/parse_time.dart';

import 'client.dart';
import 'fake_data.dart';

const _kThreadsPerFetch = 15;
const _kCommentsPerFetch = 15;
final _toBase64 = utf8.fuse(base64);

void initializationInterfaces() {
  generateRandomThreads(50);

  TestClient.onGet('/home', (req) {
    Map<String, dynamic> body = {
      'threads': sortByTime(null, 5, 0),
      'news': getNews(),
    };
    if (req.isLogined) {
      body.addAll({
        'user': {
          'uid': fakeUser!.uid,
          'nickname': fakeUser!.nickname,
        }
      });
    }
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

  TestClient.onPost('/thread', (req) {
    if (req.isLogined == false) {
      return const SimpleResponse({}, statusCode: 401);
    }
    final pid = req.bodies['pid'] as int;
    final fid = req.bodies['fid'] as int;
    final title = req.bodies['title'] as String;
    final content = req.bodies['content'] as String;
    final tid = createNewThread(title, content, pid, fid);
    return SimpleResponse({'new_tid': tid});
  });

  TestClient.onGet('/thread/:tid', (req) {
    final threadID = int.parse(req.parameters['tid'] ?? '0');
    final encodedCursor = req.quaries['cursor'] ?? '';

    int offset = 0;

    //嘗試解析分頁指標
    if (encodedCursor.isNotEmpty) {
      final jsonCursor = _toBase64.decode(encodedCursor);
      final mappedCursor = jsonDecode(jsonCursor);
      offset = mappedCursor[0];
    }

    final thread = fakeThreads.firstWhere((t) => t['tid'] == threadID);
    final comments = filterComments(threadID, offset);

    //生成下一頁指標
    String cursor = "";
    if (comments.length >= _kCommentsPerFetch) {
      cursor = "[${comments.length}]";
      cursor = _toBase64.encode(cursor);
    }

    Map<String, dynamic> body = {
      'thread': thread,
      'comments': comments,
      'continuous': cursor,
    };

    return SimpleResponse(body);
  });

  TestClient.onPost('/comment/:cid/react', (req) {
    if (req.isLogined == false) {
      return const SimpleResponse({}, statusCode: 401);
    }
    final commentID = int.parse(req.parameters['cid']!);
    final newReaction = req.bodies['type'] as int;
    final finalReaction = updateReaction(commentID, newReaction);

    return SimpleResponse({'final_reaction': finalReaction});
  });

  TestClient.onGet('/user/state/:sid', (req) {
    final sid = int.parse(req.parameters['sid'] ?? '0');
    final body = {
      'sid_state': isFakeUser(sid) ? 1 : 0,
    };
    return SimpleResponse(body);
  });

  TestClient.onPost('/vfcode/send', (req) {
    return const SimpleResponse({});
  });

  TestClient.onPost('/vfcode/check', (req) {
    final sid = req.bodies['sid'] as int;
    final vfCode = req.bodies['vf_code'] as int;

    if (!isVfCodeValid(sid, vfCode)) {
      return const SimpleResponse({}, statusCode: 400);
    }

    return const SimpleResponse({});
  });

  TestClient.onPost('/user/register', (req) {
    final sid = req.bodies['sid'] as int;
    final pwd = req.bodies['pwd'];
    final nickname = req.bodies['nickname'];
    createFakeUser(sid, pwd, nickname);
    return const SimpleResponse({});
  });

  TestClient.onPost('/user/login', (req) {
    final sid = req.bodies['sid'] as int;
    final pwd = req.bodies['pwd'];

    if (!performLogin(sid, pwd)) {
      return const SimpleResponse({}, statusCode: 401);
    }

    final logined = {
      'token': fakeUserToken,
      'valid_time': 180,
      'user': {
        'uid': fakeUser!.uid,
        'nickname': fakeUser!.nickname,
      },
    };

    return SimpleResponse(logined);
  });

  TestClient.onPost('/user/logout', (req) {
    if (req.isLogined == false) {
      return const SimpleResponse({}, statusCode: 400);
    }
    return const SimpleResponse({});
  });

  TestClient.onGet('/toolbox', (_) {
    return const SimpleResponse({'class_swapping': true, 'study_parner': true});
  });
}
