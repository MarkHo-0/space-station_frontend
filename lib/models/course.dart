class CourseInfo {
  final String coureseName;
  final String courseCode;
  final int minClassNum;
  final int maxClassNum;

  CourseInfo({
    required this.coureseName,
    required this.courseCode,
    required this.minClassNum,
    required this.maxClassNum,
  });

  factory CourseInfo.fromjson(Map<String, dynamic> json) {
    return CourseInfo(
        coureseName: json["name"],
        courseCode: json["code"],
        minClassNum: json["min_class_num"],
        maxClassNum: json["max_class_num"]);
  }
}

class CoursesModel {
  List<CourseInfo> coursesArray;

  CoursesModel(this.coursesArray);
  factory CoursesModel.fromJson(Map<String, dynamic> json) {
    List<CourseInfo> courses = (json["courses"] as Iterable)
        .map((t) => CourseInfo.fromjson(t))
        .toList();
    return CoursesModel(courses); //json is map json["has_next"] is a Map
  }
}
