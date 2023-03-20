import 'contact_info.dart';
import 'course.dart';
import 'grade.dart';

class StudyPartnerPost {
  final int id;
  final int publisherUserID;
  final Grade aimedGrade;
  final String description;
  final CourseInfo course;
  final ContactInfo contact;

  StudyPartnerPost(
    this.id,
    this.publisherUserID,
    this.aimedGrade,
    this.description,
    this.course,
    this.contact,
  );

  factory StudyPartnerPost.fromJson(Map<String, dynamic> json) {
    return StudyPartnerPost(
      json['id'],
      json['publisher_uid'],
      Grade(json['aimed_grade']),
      json['description'],
      CourseInfo.fromjson(json['course']),
      ContactInfo.fromJson(json['contact']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_code': course.courseCode,
      'description': description,
      'aimed_grade': aimedGrade.gradeIndex,
      'contact': contact.toJson(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class StudyPartnerQueryResult {
  final List<StudyPartnerPost> posts;
  final String continuous;

  StudyPartnerQueryResult(this.posts, this.continuous);

  factory StudyPartnerQueryResult.fromJson(Map<String, dynamic> json) {
    final posts = (json["posts"] as Iterable)
        .map((post) => StudyPartnerPost.fromJson(post))
        .toList();

    return StudyPartnerQueryResult(posts, json['continuous']);
  }
}
