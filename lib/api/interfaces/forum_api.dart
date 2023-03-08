import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:space_station/api/http.dart';
import '../../models/thread.dart';
import '../../models/comment.dart';
import '../api.dart';

Future<HomePageModel> getHomeData() async {
  return HttpClient().get('/home').then((res) => HomePageModel.fromJson(res));
}

Future<ThreadsModel> getThreads({
  int orderID = 1,
  int pageID = 0,
  int facultyID = 0,
  String queryText = '',
  String nextCursor = '',
}) async {
  Map<String, dynamic> query = {};
  if (orderID > 1) query.addAll({"order": orderID});
  if (pageID > 0) query.addAll({"pid": pageID});
  if (facultyID > 0) query.addAll({"fid": facultyID});
  if (nextCursor.isNotEmpty) query.addAll({"cursor": nextCursor});
  if ((queryText.isNotEmpty) && (queryText.length <= 10)) {
    query.addAll({"q": queryText});
  }

  return HttpClient()
      .get('/thread', queryParameters: query)
      .then((res) => ThreadsModel.fromJson(res));
}

Future<ThreadDetailModel> getThread(int tid, String cursor) async {
  final query = {"cursor": cursor};
  return HttpClient()
      .get("/thread/$tid", queryParameters: query)
      .then((res) => ThreadDetailModel.fromJson(res));
}

Future<CommentDetail> getComment(String cid) async {
  http.Response response = await API("").myGet("/comment/$cid", {});
  if (response.statusCode == 200) {
    return CommentDetail.fromjson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load CommentDetail');
  }
}

Future<int> postThread(int pid, int fid, String title, String content) async {
  final thread = {"pid": pid, "fid": fid, "title": title, "content": content};
  return HttpClient()
      .post('/thread', bodyItems: thread)
      .then((res) => res["new_tid"] as int);
}

////如果200 ,return true
///413or403or401 , 要catch exception message

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
// ignore: non_constant_identifier_names
Future<int?> postComment(int tid, int replyTo, String content) async {
  Map<String, dynamic> bodyMap = {"reply_to": replyTo, "content": content};
  http.Response response =
      await API("").myPost("/thread/$tid/comment", {}, bodyMap);
  switch (response.statusCode) {
    case 200:
      Map<String, dynamic> x = jsonDecode(response.body);
      return (x["new_cid"]);
    case 413:
      throw Exception("Comment body have over the word limit");
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
Future<int> postCommentReation(int cid, int type) async {
  http.Response response =
      await API("").myPost("/comment/$cid/reaction", {"type": type}, {});
  switch (response.statusCode) {
    case 200:
      Map<String, dynamic> x = jsonDecode(response.body);
      return (x["final_reaction"]);
    case 403:
      throw Exception("You are not allow to do this,please call the admin.");
    case 401:
      throw Exception("No Authorization!");
    default:
      throw Exception("Error.Please try again.");
  }
}

//if code==200 , return LikeDislikeCount object (Field: liked:int, disliked:int)
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
Future<bool> pinComment(int cid) async {
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
Future<bool> reportComment(int cid, int reason_id) async {
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
