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
User? fakeUser;
int? fakeUserSid;
String? fakeUserPwd;
String? fakeUserToken;

void generateRandomThreads(int quantity) {
  fakeThreads.clear();

  for (var i = 1; i < quantity; i++) {
    int pid = getRandomPID();
    int fid = pid == 2 ? getRandomFID() : 0;
    int lastUpdateTime = getRandomPassTime(getCurrUnixTime());
    int createTime = getRandomPassTime(lastUpdateTime, percentInSameDay: 0.3);
    Map<String, int> stats = getRandomThreadStats();
    int heat =
        ((stats['like']! + stats['dislike']!) / 2).floor() + stats['comment']!;

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

int createNewThread(String title, String content, int pid, int fid) {
  dynamic thread = {
    'tid': fakeThreads.length,
    'pid': pid,
    'fid': fid,
    'title': title,
    'sender': {'uid': fakeUser!.uid, 'nickname': fakeUser!.nickname},
    'create_time': getCurrUnixTime(),
    'last_update_time': getCurrUnixTime(),
    'stats': {'like': 0, 'dislike': 0, 'comment': 0},
    'content_cid': 1,
    'pined_cid': null,
    'heat': 0,
  };
  fakeThreads.add(thread);
  return fakeThreads.length - 1;
}

//復合類型假數據生成

dynamic getRandomUser() {
  final uid = Random().nextInt(_nicknames.length - 1);
  return {'uid': uid, 'nickname': _nicknames[uid]};
}

Map<String, int> getRandomThreadStats() {
  return <String, int>{
    'like': getRandomInt(50, 0.1),
    'dislike': getRandomInt(50, 0.1),
    'comment': getRandomInt(30, 0.2),
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
  '爛左龜，好灰吖',
  'Space 邊個 course 最靚龜',
  '屯馬開通真的很興奮',
  '好想拍拖',
  '天氣好凍',
  '幾時出 grade ?',
  '爆 4 有咩技巧，求學霸分享',
  'KEC 附近有咩好吃',
  'Space 邊間分校最靚',
  'EST 真係好廢',
  '想知大家點樣得知呢個平台',
];

List<String> _academicTitles = [
  'C vs C++ vs C#',
  '點解光速無法被超越？',
  '音速點解慢光速咁多？',
  '電子流動嘅方向點解同電流嘅方向相反',
  'How to install MySQL server?',
  '大家最鐘意用咩筆記軟件？',
  'EAP reference 嘅格式',
  '點解 1 + 1 = 2',
  '能量係唔係真係守恆',
  'IELTS 最常考嘅題目',
  'SSH 係唔係真係安全?',
  '大家用咩 system 多？',
  '點樣讀 pneumonoultramicroscopicsilicovolcanoconiosis',
  '進化論 vs 創造論',
  '想自己寫一個編譯器，有咩資源推介'
];

List<String> _nicknames = [
  '論壇第一人',
  '最愛編程',
  '你在何方',
  '我係太空人',
  'Little Big Space',
  'IT Dog',
  '床前明月光',
  '來自未來的月亮',
  '真的假不了',
  'I am Iron Man',
  'T_T',
  '為了愛',
  '忽然心動',
  '死了都要愛',
  'Elon Musk',
  'Joe Biden',
  '一理通馬國明',
  '飛躍進步學生',
  '查無此人',
];

List<dynamic> _news = [
  {1: "安心出行正式壽終正寢", 2: "口罩令依然保持..."},
  {1: "學校已經全面轉為 Microsoft", 2: "最大原因係Google教育版宜家唔再係無限儲存空間，我地唔想買"},
  {1: "所有學生需要在畢業前通過國安法考試", 2: "我地都係比教育局逼嘅，大家拍硬檔做好場戲好來好去"},
  {1: "HDIT即將成為全校最成功嘅科目", 2: "預計該科在2333年擁有100%的升學率"},
  {1: "全新校內論壇上線", 2: "快啲來留低你地嘅諗法"},
  {1: "繳交下學期學費", 2: "再唔交學費就打電話同你地屋企人講"},
]; /* #endregion */
