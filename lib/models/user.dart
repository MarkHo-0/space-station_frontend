import 'dart:convert';
import 'package:flutter/foundation.dart';

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
  late ValueNotifier<int> threadCount;
  late ValueNotifier<int> commentCount;
  final int? fid;

  UserInfo(
    this.uid,
    this.nickname,
    this.createTime,
    this.sid,
    int threadCount,
    int commentCount,
    this.fid,
  ) {
    this.threadCount = ValueNotifier(threadCount);
    this.commentCount = ValueNotifier(commentCount);
  }

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
      'thread_count': threadCount.value,
      'comment_count': commentCount.value,
      'fid': fid
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  User toSimpleUser() {
    return User(uid: uid, nickname: nickname);
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
