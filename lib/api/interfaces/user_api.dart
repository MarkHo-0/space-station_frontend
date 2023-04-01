import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:space_station/api/http.dart';
import 'package:space_station/models/thread.dart';
import '../../models/user.dart';

Future<ThreadsModel> getUserThreads(int uid, String cursor) async {
  Map<String, dynamic> query = {};
  if (cursor.isNotEmpty) query.addAll({'cursor': cursor});
  return HttpClient()
      .get('/user/$uid/thread', queryParameters: query)
      .then((res) => ThreadsModel.fromJson(res));
}

///獲取用戶狀態，0: 不存在，1: 正常, 2: 被禁止登入
Future<int> getUserState(int sid) async {
  return HttpClient()
      .get('/user/state/$sid')
      .then((res) => res["sid_state"] as int);
}

///用戶進行註冊
Future<void> registerUser(int sid, String pwd, String nickname) async {
  final hasedpwd = sha256.convert(utf8.encode(pwd)).toString();
  final user = {"sid": sid, "pwd": hasedpwd, 'nickname': nickname};
  return HttpClient().post('/user/register', bodyItems: user).then((_) => null);
}

Future<LoginData> loginUser(int sid, String pwd) async {
  final hasedpwd = sha256.convert(utf8.encode(pwd)).toString();
  final loginForm = {
    "sid": sid,
    "pwd": hasedpwd,
    'device_name': '', //暫時無法簡單實現
  };

  return HttpClient()
      .post('/user/login', bodyItems: loginForm)
      .then((res) => LoginData.fromjson(res));
}

Future<void> logoutUser() async {
  return HttpClient().post('/user/logout').then((_) => null);
}

Future<void> sendVfCode(int studentID) async {
  final user = {'sid': studentID};
  return HttpClient().post('/vfcode/send', bodyItems: user).then((_) => null);
}

Future<void> checkVfCode(int studentID, int vfcode) async {
  final vfData = {'sid': studentID, 'vf_code': vfcode};
  return HttpClient()
      .post('/vfcode/check', bodyItems: vfData)
      .then((_) => null);
}
