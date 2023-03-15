import 'package:space_station/api/http.dart';
import 'package:space_station/models/course.dart';

Future<CoursesModel> getCourseInfo(String q) async {
  final query = {"q": q};
  return HttpClient()
      .get("/completion/course", queryParameters: query)
      .then((res) => CoursesModel.fromJson(res));
}
