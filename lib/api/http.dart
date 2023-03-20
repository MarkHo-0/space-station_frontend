// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'mocking/client.dart' show TestClient;
import 'error.dart';
import 'methods.dart';

typedef JsonObj = Map<String, dynamic>;

class HttpClient {
  final ClientConfig _config;
  String _authKey = '';

  HttpClient._(this._config);

  //單例模式，本類永遠只存在一個實體
  static HttpClient? _singleton;
  factory HttpClient() => _singleton!;
  static void init(ClientConfig config) {
    _singleton ??= HttpClient._(config);
  }

  Future<JsonObj> _send(
      HttpMethod methold, String path, JsonObj? query, JsonObj? body) async {
    //構建請求網址
    final url = _config.pasteUrl(path, query);
    Request req = Request(methold.name, url);

    //如果有請求內文，則添加進 body 欄。
    if (body != null && body.isNotEmpty) {
      req.headers.addAll({'Content-Type': 'application/json'});
      req.body = jsonEncode(body);
    }

    //如果有身份令牌，則添加進 Authorization 欄。
    if (_authKey.isNotEmpty) {
      req.headers.addAll({'Authorization': _authKey});
    }

    //發出請求
    late Response res;
    try {
      StreamedResponse streamResponse = await _config.baseClient.send(req);
      res = await Response.fromStream(streamResponse);
    } catch (e) {
      if (e is SocketException) {
        return Future.error(NetworkError());
      }
      return Future.error(e);
    }

    //嘗試將 body 轉為Json Object
    JsonObj decodedBody = {};
    if (res.body.isNotEmpty) {
      decodedBody = jsonDecode(res.body);
    }

    //全局錯誤處理
    if (res.statusCode != 200) {
      return Future.error(handleException(res.statusCode, decodedBody));
    }

    //返回結果
    return decodedBody;
  }

  Future<JsonObj> get(String path, {JsonObj? queryParameters}) {
    return _send(HttpMethod.GET, path, queryParameters, null);
  }

  Future<JsonObj> post(String path, {JsonObj? bodyItems}) {
    return _send(HttpMethod.POST, path, null, bodyItems);
  }

  Future<JsonObj> patch(String path, {JsonObj? bodyItems}) {
    return _send(HttpMethod.PATCH, path, null, bodyItems);
  }

  Future<JsonObj> delete(String path) {
    return _send(HttpMethod.DELETE, path, null, null);
  }

  void setAuthKey(String key) {
    _authKey = key;
  }
}

class ClientConfig {
  late final String host;
  late final int port;
  late final Client baseClient;

  ClientConfig(
      {bool shouldUseFakeData = false,
      this.host = 'www.spacestation.nets.hk',
      this.port = 3000}) {
    baseClient = shouldUseFakeData ? TestClient() : Client();
  }

  Uri pasteUrl(String path, Map<String, dynamic>? query) {
    //將 query 的 int 轉為 String
    if (query != null && query.isNotEmpty) {
      query.forEach((key, value) {
        if (value is int) {
          query[key] = value.toString();
        }
      });
    }
    return Uri(
        scheme: 'http',
        host: host,
        path: 'api$path',
        queryParameters: query,
        port: port);
  }
}
