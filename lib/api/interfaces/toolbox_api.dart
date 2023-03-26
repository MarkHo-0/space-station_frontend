import 'package:space_station/api/http.dart';
import 'package:space_station/models/courseswap.dart';
import '../../models/study_partner_post.dart';

Future<StudyPartnerQueryResult> queryPosts(String query, String cursor) {
  Map<String, String> data = {};
  if (query.isNotEmpty) data.addAll({'q': query});
  if (query.isNotEmpty) data.addAll({'cursor': cursor});
  return HttpClient()
      .get("/studypartner/post", queryParameters: data)
      .then((res) => StudyPartnerQueryResult.fromJson(res));
}

Future<List<StudyPartnerPost>> getPostRecords() {
  return HttpClient().get("/studypartner/record").then(
        (res) => (res['posts'] as List).map((p) {
          return StudyPartnerPost.fromJson(p);
        }).toList(),
      );
}

Future<void> createPost(StudyPartnerPost post) {
  final data = post.toJson();
  return HttpClient()
      .post("/studypartner/post", bodyItems: data)
      .then((res) => null);
}

Future<void> editPost(StudyPartnerPost post) {
  final data = post.toJson();
  return HttpClient()
      .patch("/studypartner/post/${post.id}", bodyItems: data)
      .then((_) => null);
}

Future<void> removePost(StudyPartnerPost post) {
  return HttpClient().delete("/studypartner/post/${post.id}").then((_) => null);
}

Future<SearchRequests> searchRequest(
    String courseCode, int currentClassNum) async {
  final query = {
    "course_code": courseCode,
    "current_class_num": currentClassNum
  };
  return HttpClient()
      .get("/classswap/search", queryParameters: query)
      .then((res) => SearchRequests.fromjson(res));
}

Future<void> createSwapRequest(SwapRequest request) {
  final data = request.toJson();
  return HttpClient()
      .post("/classswap/request", bodyItems: data)
      .then((res) => null);
}

Future<SwapRequestRecords> getSwapRecord() {
  return HttpClient()
      .get("/classswap/record")
      .then((res) => SwapRequestRecords.fromjson(res));
}

Future<void> removeRequest(int id) {
  return HttpClient().delete("/classswap/request/$id").then((_) => null);
}

Future<void> repostRequest(int id) {
  return HttpClient().post("/classswap/request/$id/repost").then((_) => null);
}

Future<SwapRequestRecord> swapRequest(int id) {
  final data = {"request_id": id};
  return HttpClient()
      .post("/classswap/swap", bodyItems: data)
      .then((res) => SwapRequestRecord.fromjson(res));
}
