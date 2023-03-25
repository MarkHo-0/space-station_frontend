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
      .then((res) {
    return SearchRequests.fromjson(res);
  });
  // return Future.value(SearchRequests(
  //    [SearchRequest(id: 0, classNum: 2), SearchRequest(id: 2, classNum: 3)]));
}
