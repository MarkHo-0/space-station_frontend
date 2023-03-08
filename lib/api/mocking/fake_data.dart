import 'dart:convert';
import 'dart:math';

import '../../models/user.dart';
import '../../utils/parse_time.dart';
import 'package:crypto/crypto.dart';

//假數據處理

List<dynamic> sortByHotness(List<dynamic>? threads, int quantity, int offset) {
  return _sort(threads, quantity, offset, 'heat');
}

List<dynamic> sortByTime(List<dynamic>? threads, int quantity, int offset) {
  return _sort(threads, quantity, offset, 'last_update_time');
}

List<dynamic> _sort(List? threads, int quantity, int offset, String compkey) {
  final data = threads ?? fakeThreads.sublist(0);
  data.sort((a, b) => (b[compkey] as int).compareTo(a[compkey] as int));
  return data.skip(offset).take(quantity).toList();
}

List<dynamic> filterThreads({pageID = 0, facultyID = 0, queryText = ''}) {
  return fakeThreads.where((t) {
    if (pageID > 0 && t['pid'] != pageID) return false;
    if (facultyID > 0 && t['fid'] != facultyID) return false;
    if (queryText != '') {
      if (!((t['title'] as String).contains(queryText))) return false;
    }
    return true;
  }).toList();
}

List<dynamic> filterComments({tid = 0, offset = 0, count = 15}) {
  return fakeComments
      .where((c) => c['tid'] == tid)
      .skip(offset)
      .take(count)
      .toList();
}

bool isFakeUser(int sid) => fakeUserSid == sid;

bool isVfCodeValid(int sid, int code) =>
    code.toString() == sid.toString().substring(4, 8);

int createFakeUser(int sid, String pwd, String nickname) {
  final fakeUserID = Random().nextInt(100) + _nicknames.length;
  fakeUser = User(uid: fakeUserID, nickname: nickname);
  fakeUserSid = sid;
  fakeUserPwd = pwd;
  return fakeUserID;
}

bool performLogin(int sid, String pwd) {
  if (sid != fakeUserSid || pwd != fakeUserPwd) return false;
  fakeUserToken = sha512.convert(utf8.encode('${sid}_123')).toString();
  return true;
}

//單例類型假數據生成

List<dynamic> fakeThreads = [];
List<dynamic> fakeComments = [];
User? fakeUser;
int? fakeUserSid;
String? fakeUserPwd;
String? fakeUserToken;

void generateRandomThreads(int quantity) {
  fakeThreads.clear();
  fakeComments.clear();

  for (var i = 1; i <= quantity; i++) {
    int pid = getRandomPID();
    int fid = pid == 2 ? getRandomFID() : 0;
    int lastUpdateTime = getRandomPassTime(getCurrUnixTime());
    int createTime = getRandomPassTime(lastUpdateTime, percentInSameDay: 0.3);
    Map<String, int> stats = getRandomStats();
    int heat =
        ((stats['like']! + stats['dislike']!) / 2).floor() + stats['comment']!;

    dynamic threadSender = getRandomUser();

    dynamic thread = {
      'tid': i,
      'pid': pid,
      'fid': fid,
      'title': getRandomTitle(pid),
      'sender': threadSender,
      'create_time': createTime,
      'last_update_time': lastUpdateTime,
      'stats': stats,
      'content_cid': 1,
      'pined_cid': getRandomThreadPinCid(),
      'heat': heat,
    };

    for (var j = 1; j <= stats['comment']!; j++) {
      dynamic comment = {
        'tid': i,
        'cid': fakeComments.length + 1,
        'content': getRandomContent(),
        'createTime': createTime,
        'replyto': null,
        'stats': j == 1 ? stats : getRandomStats(),
        'sender': j == 1 ? threadSender : getRandomUser(),
        'status': j == 1 ? 0 : getRandomStatus(),
      };
      fakeComments.add(comment);
    }

    fakeThreads.add(thread);
  }
}

int createNewThread(String title, String content, int pid, int fid) {
  dynamic defaultStats = {'like': 0, 'dislike': 0, 'comment': 0};
  dynamic sender = {'uid': fakeUser!.uid, 'nickname': fakeUser!.nickname};
  dynamic thread = {
    'tid': fakeThreads.length,
    'pid': pid,
    'fid': fid,
    'title': title,
    'sender': sender,
    'create_time': getCurrUnixTime(),
    'last_update_time': getCurrUnixTime(),
    'stats': defaultStats,
    'content_cid': 1,
    'pined_cid': null,
    'heat': 0,
  };
  dynamic firstComment = {
    'tid': fakeThreads.length,
    'cid': fakeComments.length,
    'content': content,
    'createTime': getCurrUnixTime(),
    'replyto': null,
    'stats': defaultStats,
    'sender': sender,
    'status': 0,
  };
  fakeThreads.add(thread);
  fakeComments.add(firstComment);
  return fakeThreads.length - 1;
}

//復合類型假數據生成

dynamic getRandomUser() {
  final uid = Random().nextInt(_nicknames.length - 1);
  return {'uid': uid, 'nickname': _nicknames[uid]};
}

Map<String, int> getRandomStats() {
  return <String, int>{
    'like': getRandomInt(50, 0.1),
    'dislike': getRandomInt(50, 0.1),
    'comment': getRandomInt(10, 0.2),
    'me': 0
  };
}

List<dynamic> getNews() {
  int uuidCounter = 1;
  int pTime = getCurrUnixTime();
  return (_news..shuffle())
      .map((n) => {
            'title': n[1],
            'content': n[2],
            'uuid': uuidCounter++,
            'public_time': pTime = getRandomPassTime(pTime),
          })
      .toList();
}

//基礎類型假數據生成

String getRandomTitle(int pid) {
  final targetList = pid == 1 ? _casualTitles : _academicTitles;
  final i = Random().nextInt(targetList.length - 1);
  return targetList[i];
}

String getRandomContent() {
  final i = Random().nextInt(_comments.length - 1);
  return _comments[i].toString();
}

int getRandomStatus() {
  const normalThreshold = 90;
  const hideThreshold = 70;
  final i = Random().nextInt(100);
  if (i < normalThreshold) return 0;
  final j = Random().nextInt(100);
  return j < hideThreshold ? 1 : 2;
}

int getRandomPassTime(int curr, {double percentInSameDay = 0.7}) {
  final bool isSameDay = Random().nextDouble() < percentInSameDay;
  final int maxDiff = isSameDay ? 86400 : 31536000;
  return curr - Random().nextInt(maxDiff);
}

int getRandomFID() {
  return Random().nextInt(6) + 1;
}

int getRandomPID() {
  final i = Random().nextInt(10);
  return i < 3 ? 1 : 2;
}

int getRandomThreadPinCid() {
  final i = Random().nextInt(10);
  return i < 3 ? 0 : Random().nextInt(100) + 1;
}

int getRandomInt(int max, double percentIsZero) {
  final isZero = Random().nextDouble() <= percentIsZero;
  return isZero ? 0 : Random().nextInt(max) + 1;
}

//手動輸入假資料

List<String> _casualTitles = [
  'My grade is very low',
  'Who is the most susiest in HKUSPACE',
  'Im really excited about the opening of Tuen Ma',
  'I really want to date',
  'The weather is very cold',
  'When will the grade come out?',
  'Does getting LEVEL 4 GPA has any skills, share plzzzz',
  'Whats delicious near KEC',
  'Which campus is the most beautiful in HKUSPACE',
  'EST is suck',
  'I want to know how everyone knows about this platform',
];

List<String> _academicTitles = [
  'C vs C++ vs C#',
  'Explain that the speed of light cannot be surpassed? ',
  'The speed of sound is so much slower than the speed of light? ',
  'The direction of electron flow point solution is opposite to the direction of current',
  'How to install MySQL server?',
  'What note-taking software do you like most? ',
  'EAP reference format',
  'Point solution 1 + 1 = 2',
  'The energy system does not belong to the true system conservation',
  'IELTS most frequently tested questions',
  'Is SSH really safe?',
  'What system do you use a lot? ',
  'Read pneumonoultramicroscopicsilicovolcanoconiosis',
  'Evolution vs Creation',
  'I want to write a compiler by myself, do you have any resources to recommend?'
];

List<String> _comments = [
  'I support you!',
  'I don\'t know what you asking.',
  'Base my understanding, you are wrong.',
  '# Please report this thread!\nHe is posting sensitive thing',
  'I can give some example:\n> www.google.com\n> www.youtube.com',
  'This can be solve by the following equation:\n\$\$\nmx+y=c\n\$\$',
  'You can try the following code:\n```js\nconsole.log("Hello world")\n````'
];

List<String> _nicknames = [
  'The first person in the forum',
  'Favorite programming',
  'Where are you',
  'I am an astronaut',
  'Little Big Space',
  'IT Dog',
  'Moonlight in front of the bed',
  'Moon from the future',
  'True cant be fake',
  'I am Iron Man',
  'T_T',
  'for love',
  'Suddenly moved',
  'Death to Love',
  'Elon Musk',
  'Joe Biden',
  'One reason is Ma Guoming',
  'Leap forward students',
  'There is no such person',
];

List<dynamic> _news = [
  {
    1: "Travel with peace of mind is officially coming to an end",
    2: "The mask order has also ended ..."
  },
  {
    1: "The school has been fully changed to Microsoft",
    2: "The biggest reason is that Google Education Edition IKEA no longer has unlimited storage space, I don't want to buy it"
  },
  {
    1: "All students need to pass the National Security Law Examination before graduation",
    2: "My land is more expensive than the Education Bureau, everyone makes a hard scene and makes a good scene"
  },
  {
    1: "HDIT is about to become the most successful subject in the school",
    2: "This subject is expected to have a 100% enrollment rate in 2333"
  },
  {1: "The new school forum is online", 2: "Hurry up and leave your thoughts"},
  {
    1: "Pay the tuition for next semester",
    2: "If you don't pay the tuition any more, call and talk to your landlord"
  },
]; /* #endregion */