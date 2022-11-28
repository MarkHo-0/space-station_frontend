import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:space_station/api/api.dart';

//input usernameController.text, passwordController.text , function device_name();
Future<Map<String, dynamic>> loginin(
    int sid, String pwd, String device_name) async {
  Map<String, dynamic> bodyMap = {
    "sid": sid,
    "pwd": pwd,
    'device_name': device_name
  };
  http.Response response = await API("").myPost("/user/login", {}, bodyMap);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Wrong username or password");
  }
}

//if http response==200, loginin successful
//return requestbody:{token: ,valid_time:, User: {uid: ,nickname: ,subject_id: } }
//要catch返Exception

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

Future<Map<String, dynamic>> getUserThread(int uid) async {}
