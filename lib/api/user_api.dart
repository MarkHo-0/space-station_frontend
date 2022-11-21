import 'dart:convert';
import 'dart:html';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

//input usernameController.text, passwordController.text , function device_name();
Future<http.Response> loginin(int sid, String pwd, String device_name) async {
  Map<String, dynamic> bodyMap = {
    "sid": sid,
    "pwd": pwd,
    'device_name': device_name
  };
  Map<String, String> HeaderMap = {"Content-Type": "application/json"};
  http.Response response = await http.post(Uri.parse(x),
      headers: HeaderMap, body: jsonEncode(bodyMap));

  return response;
}

//if http response==200, loginin successful
//return response, including statecode, 
//and requestbody:{token: ,valid_time:, User: {uid: ,nickname: ,subject_id: } }
