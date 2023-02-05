import 'thread.dart';

class User {
  //basic_info too
  final int uid;
  final String nickname;

  User({
    required this.uid,
    required this.nickname,
  });

  factory User.fromjson(Map<String, dynamic> json) {
    return User(
      uid: json["uid"],
      nickname: json["nickname"],
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class UserInfo {
  final User basicInfo;
  final String gender;
  final int createTime;
  final int sid;
  final int threadCount;
  final int commentCount;
  final int fid;
  UserInfo(this.basicInfo, this.gender, this.createTime, this.sid,
      this.threadCount, this.commentCount, this.fid);

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        User.fromjson(json["basic_info"]),
        json["gender"],
        json["create_time"],
        json["sid"],
        json["thread_count"],
        json["comment_count"],
        json["fid"]);
  }
}

class UserThreads {
  List<Thread> threadsArray;
  UserThreads(this.threadsArray);

  factory UserThreads.fromjson(Map<String, dynamic> json) {
    dynamic a = json["threads"]; //return list of map type
    List<Thread> b = [];
    for (int i = 0; i < a.length; i++) {
      a[i]["sender"] = null; //無"sender" set null
      b.add(Thread.fromJson(a[
          i])); //each index item is String and convert back to Map ,and assign object to new List
    }
    return UserThreads(b);
  }
}

class LoginData {
  String token;
  int validTime;
  User user;
  LoginData(this.token, this.validTime, this.user);
  factory LoginData.fromjson(Map<String, dynamic> json) {
    return LoginData(
        json["token"], json["valid_time"], User.fromjson(json["user"]));
  }
}

class NewFaculty {
  int fid;
  String facultyName;
  NewFaculty(this.fid, this.facultyName);
  factory NewFaculty.fromjson(Map<String, dynamic> json) {
    return NewFaculty(json["fid"], json["faculty_name"]); //return 文字
  }
}
