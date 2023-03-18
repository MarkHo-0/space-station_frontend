import 'package:space_station/models/toolbox.dart';

import '../../models/course.dart';
import '../http.dart';

Future<ToolboxAvailabilities> getToolboxAvailabilities() async {
  return HttpClient()
      .get('/toolbox')
      .then((res) => ToolboxAvailabilities.fromjson(res));
}

Future<CoursesModel> getCourseInfo(String q) async {
  final query = {"q": q};
  return HttpClient()
      .get("/completion/course", queryParameters: query)
      .then((res) => CoursesModel.fromJson(res));
}
