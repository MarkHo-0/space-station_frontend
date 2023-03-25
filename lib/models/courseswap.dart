import 'package:space_station/models/contact_info.dart';
import 'package:space_station/models/course.dart';

class SearchRequest {
  int id;
  int classNum;
  SearchRequest({required this.id, required this.classNum});
  factory SearchRequest.fromjson(Map<String, dynamic> json) {
    return SearchRequest(
      id: json["id"],
      classNum: json["class_num"],
    );
  }
}

class SearchRequests {
  List<SearchRequest> requestArray;
  SearchRequests(this.requestArray);
  factory SearchRequests.fromjson(Map<String, dynamic> json) {
    List<SearchRequest> requests = (json["requests"] as Iterable)
        .map((t) => SearchRequest.fromjson(t))
        .toList();
    return SearchRequests(requests);
  }
}

class SwapRequest {
  String courseCode;
  int currentClassNum;
  int expectedClassNum;
  ContactInfo contact;
  SwapRequest(this.currentClassNum, this.expectedClassNum, this.contact,
      this.courseCode);

  Map<String, dynamic> toJson() {
    return {
      "course_code": courseCode,
      "current_class_num": currentClassNum,
      "expected_class_num": expectedClassNum,
      "contact": contact.toJson(),
    };
  }
}

class SwapRequestRecord {
  int id;
  CourseInfo course;
  int currentClassNum;
  int expectedClassNum;
  ContactInfo contactInfo;
  int requesterUid;
  int reponserUid;

  SwapRequestRecord(
      {required this.currentClassNum,
      required this.expectedClassNum,
      required this.contactInfo,
      required this.course,
      required this.id,
      required this.reponserUid,
      required this.requesterUid});
  factory SwapRequestRecord.fromjson(Map<String, dynamic> json) {
    return SwapRequestRecord(
        id: json["id"],
        course: CourseInfo.fromjson(json["course"]),
        currentClassNum: json["curr_class_num"],
        expectedClassNum: json["exp_class_num"],
        contactInfo: ContactInfo.fromJson(json["contact"]),
        reponserUid: json["responser_uid"],
        requesterUid: json["requester_uid"]);
  }
}

class SwapRequestRecords {
  List<SwapRequestRecord> swaprequestArray;
  SwapRequestRecords(this.swaprequestArray);
  factory SwapRequestRecords.fromjson(Map<String, dynamic> json) {
    List<SwapRequestRecord> requests = (json["requests"] as Iterable)
        .map((t) => SwapRequestRecord.fromjson(t))
        .toList();
    return SwapRequestRecords(requests);
  }
}
