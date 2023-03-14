import 'package:space_station/api/http.dart';
import '../../models/thread.dart';
import '../../models/comment.dart';

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

Future<int> postThread(int pid, int fid, String title, String content) async {
  final thread = {"pid": pid, "fid": fid, "title": title, "content": content};
  return HttpClient()
      .post('/thread', bodyItems: thread)
      .then((res) => res["new_tid"] as int);
}

Future<int> postComment(int tid, String content, int? replyTo) async {
  final comment = {"tid": tid, "reply_to": replyTo, "content": content};
  return HttpClient()
      .post('/comment', bodyItems: comment)
      .then((res) => res['new_cid'] as int);
}

Future<int> reactComment(int commentID, int type) {
  final reaction = {"type": type};
  return HttpClient()
      .post("/comment/$commentID/react", bodyItems: reaction)
      .then((res) => res['final_reaction'] as int);
}

Future<int?> pinComment(int commentID) async {
  return HttpClient()
      .post('/comment/$commentID/pin')
      .then((res) => res['new_pin'] as int?);
}

Future<void> reportComment(int commentID, int reasonID) async {
  final reason = {"reason_id": reasonID};
  return HttpClient()
      .post('/comment/$commentID/report', bodyItems: reason)
      .then((_) => null);
}

Future<void> recordViewTime(int tid, int viewTime) async {
  final viewcount = {"tid": tid, "view_time": viewTime};
  return HttpClient()
      .post('/thread/view', bodyItems: viewcount)
      .then((res) => null);
}
