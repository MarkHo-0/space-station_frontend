import 'dart:convert';
import 'thread.dart';

class User {
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

  factory User.fromInfo(UserInfo info) {
    return User(uid: info.uid, nickname: info.nickname);
  }
}

class UserInfo {
  final int uid;
  final String nickname;
  final int createTime;
  final int? sid;
  final int threadCount;
  final int commentCount;
  final int? fid;

  UserInfo(
    this.uid,
    this.nickname,
    this.createTime,
    this.sid,
    this.threadCount,
    this.commentCount,
    this.fid,
  );

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      json["uid"],
      json["nickname"],
      json["create_time"],
      json["sid"],
      json["thread_count"],
      json["comment_count"],
      json["fid"],
    );
  }

  factory UserInfo.fromString(String string) {
    final Map<String, dynamic> json = jsonDecode(string);
    return UserInfo.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'create_time': createTime,
      'sid': sid,
      'thread_count': threadCount,
      'comment_count': commentCount,
      'fid': fid
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class UserThreads {
  List<Thread> threads;
  UserThreads(this.threads);

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
  UserInfo user;
  LoginData(this.token, this.validTime, this.user);

  factory LoginData.fromjson(Map<String, dynamic> json) {
    return LoginData(
      json["token"],
      json["valid_time"],
      UserInfo.fromJson(
        json["user"],
      ),
    );
  }
}
