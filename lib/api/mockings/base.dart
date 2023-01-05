import 'package:http/http.dart';

Future<Response> handleApiMock(Request req) {
  switch (req.url.path) {
    case '/home':
      return Future.value(Response('{"test":"abc"}', 200));
    case '/thread':
      break;
    default:
  }
  return Future.value(Response('{}', 400));
}
