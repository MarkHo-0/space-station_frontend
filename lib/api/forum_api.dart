import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';

Future<HomeData> getHomeData() async {
  String domain = "";
  var response = await http.get(Uri.parse("$domain/home"));
  if (response.statusCode == 200) {
    return HomeData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load HomeData');
  }
}
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

Future<ThreadPage> getThreadPageData(
    String? cursor, int? order, int? pid, int? fid) async {
  http.Response response;
  Map<String, dynamic> query = {};
  if (cursor != null) query["cursor"] = cursor;
  if (order != null) query["order"] = order;
  if (pid != null) query["pid"] = pid;
  if (fid != null) query["fid"] = fid;
  response = await API("").myGet("/thread", query);
  if (response.statusCode == 200) {
    return ThreadPage.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load ThreadPage');
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<ThreadDetail> getThreadInsideData(String tid, String cursor) async {
  http.Response response;
  response = await API("").myGet("/thread/$tid", {"cursor": cursor});

  if (response.statusCode == 200) {
    return ThreadDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Thread doesn't exist");
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<SearchThread> getSearchedThread(String q, String cursor) async {
  http.Response response;
  response = await API("").myGet("/thread/search", {"cursor": cursor, "q": q});

  if (response.statusCode == 200) {
    return SearchThread.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Fail to do this.");
  }
}

/////////////////////////////////////////////////////////
//////////////////////////////////////////////////////

Future<CommentDetail> getCommentInsideData(String cid) async {
  http.Response response = await API("").myGet("/comment/$cid", {});
  if (response.statusCode == 200) {
    return CommentDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load CommentDetail');
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<bool> postThread(int cid, int fid, String title, String content) async {
  Map<String, dynamic> bodyMap = {
    "cid": cid,
    "fid": fid,
    "title": title,
    "content": content
  };
  http.Response response = await API("").myPost("/thread", {}, bodyMap);
  switch (response.statusCode) {
    case 200:
      return true;
    case 413:
      throw Exception("Thread title/body have over the word limit");
    case 403:
      Map<String, dynamic> responsemap = jsonDecode(response.body);
      String exceptionString =
          "Limited:${responsemap["reason_id"]}\n${responsemap["extra_data"]}\nPlease contect the admin!";
      throw Exception(exceptionString);
    case 401:
      throw Exception("No Authorization!");
    default:
      return false;
  }
}

////如果200 ,return true
///413or403or401 , 要catch exception message

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
// ignore: non_constant_identifier_names
Future<bool> postComment(int tid, int reply_to, String content) async {
  Map<String, dynamic> bodyMap = {"reply_to": reply_to, "content": content};
  http.Response response =
      await API("").myPost("/thread/$tid/comment", {}, bodyMap);
  switch (response.statusCode) {
    case 200:
      return true;
    case 413:
      throw Exception("Comment body have over the word limit");
    case 403:
      throw Exception("You are not allow to do this,please call the admin.");
    case 401:
      throw Exception("No Authorization!");
    default:
      return false;
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<Map<String, dynamic>> postCommentReation(int cid, int type) async {
  http.Response response =
      await API("").myPost("/comment/$cid/reaction", {"type": type}, {});
  switch (response.statusCode) {
    case 200:
      return jsonDecode(response.body);
    case 403:
      throw Exception("You are not allow to do this,please call the admin.");
    case 401:
      throw Exception("No Authorization!");
    default:
      throw Exception("Error.Please try again.");
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<bool> postPinComment(int cid) async {
  http.Response response = await API("").myPost("/comment/$cid/pin", {}, {});
  switch (response.statusCode) {
    case 200:
      return true;
    case 404:
      throw Exception("Can't find the comment!");
    case 401:
      throw Exception("No Authorization!");
    case 403:
      throw Exception("Don't have the permissions!");
    default:
      throw Exception("Error.Please try again.");
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

// ignore: non_constant_identifier_names
Future<bool> postReportComment(int cid, int reason_id) async {
  http.Response response = await API("")
      .myPost("/comment/$cid/report", {"reason_id": reason_id}, {});
  switch (response.statusCode) {
    case 200:
      return true;
    case 401:
      throw Exception("No Authorization!");
    default:
      throw Exception("Error.Please try again.");
  }
}
