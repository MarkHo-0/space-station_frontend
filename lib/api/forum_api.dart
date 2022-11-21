import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';

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
  Map<String, dynamic> query = {};
  if (cursor != "") query["cursor"] = cursor;
  response = await API("").myGet("/thread/$tid", query);

  if (response.statusCode == 200) {
    return ThreadDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load ThreadDetail');
  }
}
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

Future<CommentDetail> getCommentInsideData(String cid) async {
  http.Response response = await API("").myGet("/comment/$cid", {});
  if (response.statusCode == 200) {
    return CommentDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load CommentDetail');
  }
}
