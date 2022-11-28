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
