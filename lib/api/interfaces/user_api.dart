import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:space_station/api/api.dart';
import 'package:crypto/crypto.dart';
import 'package:space_station/api/http.dart';
import 'package:space_station/models/thread.dart';
import '../../models/user.dart';

Future<UserInfo> getUserData(int uid) async {
  http.Response response = await API("").myGet("/user/$uid", {});
  switch (response.statusCode) {
    case 200:
      return UserInfo.fromJson(jsonDecode(response.body));
    case 401:
      throw Exception("No Authorization!");
    case 422:
      throw Exception("Illegal");
    default:
      throw Exception("Error.Please try again.");
  }
}

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
Future<bool> registerUser(int sid, String pwd, String nickname) async {
  final hasedpwd = sha256.convert(utf8.encode(pwd)).toString();
  final user = {"sid": sid, "pwd": hasedpwd, 'nickname': nickname};
  return HttpClient().post('/user/register', bodyItems: user).then((_) => true);
}
//if code==200, return true

/////////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//input usernameController.text, passwordController.text , function device_name();
Future<LoginData> loginUser(int sid, String pwd) async {
  final hasedpwd = sha256.convert(utf8.encode(pwd)).toString();
  final loginForm = {
    "sid": sid,
    "pwd": hasedpwd,
    'device_name': '', //TODO
  };

  return HttpClient()
      .post('/user/login', bodyItems: loginForm)
      .then((res) => LoginData.fromjson(res));
}

Future<void> logoutUser() async {
  return HttpClient().post('/user/logout').then((_) => null);
}

//if statecode==200 patch data 並return PatchedInfo object field:(fid:int,faculty_name:String)
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<String?> changeNickname(String newname) async {
  http.Response response = await API("").myPatch("/user/nickname", {}, {
    'nickname': newname
  }); //由 Controller.text input newname as parameter, no query
  switch (response.statusCode) {
    case 200:
      Map<String, String?> responsemap = jsonDecode(response.body);
      return responsemap['nickname']; //if 200, return String? (String or null)
    case 422:
      throw Exception("Wrong input Format");
    case 403:
      throw Exception("Don't have the permissions!");
    case 401:
      throw Exception("No Authorization!");
    case 406:
      throw Exception("Operation is too frequent!");
    default:
      return null;
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<bool> changePassword(String oldpwd, String newpwd) async {
  String hasedoldpwd = sha256.convert(utf8.encode(oldpwd)).toString();
  String hasednewpwd = sha256.convert(utf8.encode(newpwd)).toString();

  Map<String, String> bodyMap = {
    "old_pwd": hasedoldpwd,
    "new_pwd": hasednewpwd
  };
  http.Response response =
      await API("").myPatch("/user/pwd", {}, bodyMap); //no query
  switch (response.statusCode) {
    case 200:
      return true; //if 200, return ture;
    case 422:
      throw Exception("Wrong input Format");
    case 403:
      throw Exception("Don't have the permissions!");
    case 401:
      throw Exception("No Authorization!");
    default:
      return false;
  }
}

Future<bool> sendVfCode(int studentID) async {
  final user = {'sid': studentID};
  return HttpClient().post('/vfcode/send', bodyItems: user).then((_) => true);
}

Future<bool> checkVfCode(int studentID, int vfcode) async {
  final vfData = {'sid': studentID, 'vf_code': vfcode};
  return HttpClient()
      .post('/vfcode/check', bodyItems: vfData)
      .then((_) => true);
}
