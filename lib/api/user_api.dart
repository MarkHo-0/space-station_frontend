import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:space_station/api/api.dart';

Future<UserData> getUserData(int uid) async {
  http.Response response = await API("").myGet("/user/$uid", {});
  if (response.statusCode == 200) {
    return UserData.fromjson(jsonDecode(response.body));
  } else {
    throw Exception("No Authorization!");
  }
}

//if statecode==200 ,return UserData object:(field: basic_info:{Basic_Info Class},
//gender:String, create_time:int, sid:int, thread_count:int, comment_count:int)

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<UserThreads> getUserThreads(int uid) async {
  http.Response response = await API("").myGet("/user/$uid/thread", {});
  if (response.statusCode == 200) {
    return UserThreads.fromjson(jsonDecode(response.body));
  } else {
    throw Exception("No Authorization!");
  }
}

//if statecode==200 ,return UserThreads object:(field: threads:{Threads Class},
//stats:{Stats Class})

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<int?> getUserState(int sid) async {
  http.Response response = await API("").myGet("/user/$sid/state", {});
  if (response.statusCode == 200) {
    Map<String, int?> responsemap = jsonDecode(response.body);
    return responsemap["sid_state"];
  } else {
    throw Exception("Error");
  }
}
//if statecode==200 ,return sid_state:int? ( int or null)

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<bool> postRegisterUser(int sid, String pwd, String nickname) async {
  Map<String, dynamic> bodyMap = {"sid": sid, "pwd": pwd, 'nickname': nickname};
  http.Response response =
      await API("").myPost("/user/register", {}, bodyMap); //no query
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Wrong Input format");
  }
}
//if code==200, return true

/////////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//input usernameController.text, passwordController.text , function device_name();
Future<LoginData> postlogin(int sid, String pwd, String device_name) async {
  Map<String, dynamic> bodyMap = {
    "sid": sid,
    "pwd": pwd,
    'device_name': device_name
  };
  http.Response response = await API("").myPost("/user/login", {}, bodyMap);
  if (response.statusCode == 200) {
    return LoginData.fromjson(jsonDecode(response.body));
  } else {
    throw Exception("Wrong username or password");
  }
}

//if http response==200,
//return 一個LoginData object （有field : token:String, valid_time:int , user:{User object})
//如果error 要catch返Exception

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<bool> postlogout() async {
  http.Response response =
      await API("").myPost("/user/logout", {}, {}); //no query and body
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("No Authorization!"); //401
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<PathchedInfo> patUserFaculty(String coursename) async {
  http.Response response = await API("").myPatch("/user/faculty", {}, {
    "course_name": coursename
  }); //由 Controller 選擇course input as parameter body , no query
  switch (response.statusCode) {
    case 200:
      return PathchedInfo.fromjson(jsonDecode(response
          .body)); //if 200, return PathchedInfo object(field:fid:int,faculty_name:String)
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

//if statecode==200 patch data 並return PatchedInfo object field:(fid:int,faculty_name:String)
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<String?> patNickname(String newname) async {
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
Future<bool> patPassword(String oldpwd, String newpwd) async {
  Map<String, String> bodyMap = {"old_pwd": oldpwd, "new_pwd": newpwd};
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
