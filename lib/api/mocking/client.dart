import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:space_station/api/mocking/interfaces.dart';

import '../methods.dart';

class TestClient extends MockClient {
  static final List<Route> _routes = [];

  TestClient() : super(_handleApiMock) {
    initializationInterfaces();
  }

  static Future<Response> _handleApiMock(Request req) {
    SimpleResponse? response;
    List<String> currPathSegs = req.url.pathSegments;
    for (final route in _routes) {
      //如果請求方法或地址段位長度不一，則直接跳過該路由
      if (req.method != route.method.name) continue;
      if (currPathSegs.length - 1 != route.pathSegments.length) continue;

      bool isPathMatched = true;
      Map<String, String> params = {};

      for (var i = 1; i < currPathSegs.length; i++) {
        final currSeg = currPathSegs[i];
        final targetSegModel = route.pathSegments[i - 1];

        //如果該段位屬於參數，則紀錄該段位的字串
        if (targetSegModel.isParam) {
          params.addAll({targetSegModel.key: currSeg});
          continue;
        }

        //如果段位不匹配，則跳出循環，進行驗證下一個路由
        if (currSeg != targetSegModel.key) {
          isPathMatched = false;
          params.clear();
          break;
        }
      }

      //如果所有段位都匹配，則表是找到路由
      if (isPathMatched) {
        //解析請求內文
        Map<String, dynamic>? body;
        if (req.body.isNotEmpty) {
          body = jsonDecode(req.body);
        }

        //獲取假數據
        response = route.onResponse(params, body);
        break;
      }
    }

    if (response == null) {
      return Future.value(Response('URL error, data could not be found', 400));
    }

    return Future.value(Response(
      jsonEncode(response.body),
      headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      response.statusCode,
    ));
  }

  static void _onRecieved(HttpMethod method, String path, HandleReqeust onResponse) {
    List<String> pathSegments = path.split('/');
    if (pathSegments.length < 2) return;
    pathSegments.removeAt(0);
    Route route = Route(method, pathSegments, onResponse);
    _routes.add(route);
  }

  static void onGet(String path, HandleReqeust onResponse) => _onRecieved(HttpMethod.GET, path, onResponse);

  static void onPost(String path, HandleReqeust onResponse) => _onRecieved(HttpMethod.POST, path, onResponse);

  static void onPatch(String path, HandleReqeust onResponse) => _onRecieved(HttpMethod.PATCH, path, onResponse);
}

class Route {
  HttpMethod method;
  late List<PathSegment> pathSegments;
  HandleReqeust onResponse;

  Route(this.method, List<String> pathSegments, this.onResponse) {
    this.pathSegments = pathSegments.map((seg) {
      late PathSegment segModel;

      if (seg.startsWith(':')) {
        if (seg.length < 2) throw Exception();
        segModel = PathSegment(seg.substring(1), isParam: true);
      } else {
        if (seg.isEmpty) throw Exception();
        segModel = PathSegment(seg);
      }

      return segModel;
    }).toList();
  }

  @override
  String toString() {
    return '${method.name}: ${pathSegments.map((s) => s.key).join('/')}';
  }
}

class PathSegment {
  final String key;
  final bool isParam;
  const PathSegment(this.key, {this.isParam = false});
}

class SimpleResponse {
  final Map<String, dynamic> body;
  final int statusCode;

  const SimpleResponse(this.body, {this.statusCode = 200});
}

typedef HandleReqeust = SimpleResponse Function(Map<String, String>? params, Map<String, dynamic>? body);
