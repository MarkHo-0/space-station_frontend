import 'dart:convert';
import 'package:http/http.dart' as http;

class API extends http.BaseClient {
  String domain = "";
  String auth = "";
  final http.Client _inner = http.Client();

  API(this.domain);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (auth != "") {
      request.headers["Authorization"] = auth;
    }
    return _inner.send(request);
  } //run automatically when create a uri object.

  Future<http.Response> myGet(String path, Map<String, dynamic> query) {
    Uri uri = Uri(host: domain, path: path, queryParameters: query);
    return super.get(uri);
  }

  Future<http.Response> myPost(
      String path, Map<String, dynamic> query, Map<String, dynamic> mybody) {
    Uri uri = Uri(host: domain, path: path, queryParameters: query);
    return super
        .post(uri, headers: {"Content-Type": "application/json"}, body: mybody);
  }

  Future<http.Response> myPatch(
      String path, Map<String, dynamic> query, Map<String, dynamic> mybody) {
    Uri uri = Uri(host: domain, path: path, queryParameters: query);
    return super.patch(uri, body: mybody);
  }
}

Future<bool> sendverification(int sid) async {
  http.Response response =
      await API("").myPost("/vfcode/send", {}, {'sid': sid}); //no query
  if (response.statusCode == 200) {
    return true; //if 200, return ture and send code to email
  } else {
    int reason = jsonDecode(response.body)["reason_id"];
    throw Exception("Failed to send,ReasonID:$reason");
  }
}

Future<bool> checkverification(int sid, int vfcode) async {
  Map<String, dynamic> bodyMap = {'sid': sid, 'vf_code': vfcode};
  http.Response response =
      await API("").myPost("/vfcode/check", {}, bodyMap); //no query
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Fail to verify!");
  }
}
