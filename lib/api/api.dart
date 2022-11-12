import 'dart:convert';
import 'package:flutter_application_3/class.dart';
import 'package:http/http.dart' as http;

Future<HomeData> getHomeData() async {
  var response = await http.get(Uri.parse(""));
  if (response.statusCode == 200) {
    return HomeData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load HomeData');
  }
}
