import 'dart:math';

import 'package:space_station/utils/parse_time.dart';

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

String getRandomTitle(int pid) {
  final targetList = pid == 1 ? _casualTitles : _academicTitles;
  final i = Random().nextInt(targetList.length - 1);
  return targetList[i];
}

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

int getRandomInt(int max, double percentIsZero) {
  final isZero = Random().nextDouble() <= percentIsZero;
  return isZero ? 0 : Random().nextInt(max) + 1;
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
];
