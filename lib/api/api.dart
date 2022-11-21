import 'dart:convert';
import 'package:http/http.dart' as http;

Future<HomeData> getHomeData() async {
  String domain = "";
  var response = await http.get(Uri.parse("$domain/home"));
  if (response.statusCode == 200) {
    return HomeData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load HomeData');
  }
}

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
  }

  Future<http.Response> myGet(String path, Map<String, dynamic> params) {
    Uri uri = Uri(host: domain, path: path, queryParameters: params);
    return super.get(uri);
  }

  Future<http.Response> myPost(
      String path, Map<String, dynamic> params, Map<String, dynamic> mybody) {
    Uri uri = Uri(host: domain, path: path, queryParameters: params);
    return super
        .post(uri, headers: {"Content-Type": "application/json"}, body: mybody);
  }

  Future<http.Response> myPatch(
      String path, Map<String, dynamic> params, Map<String, dynamic> mybody) {
    Uri uri = Uri(host: domain, path: path, queryParameters: params);
    return super.patch(uri, body: mybody);
  }
}
