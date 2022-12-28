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
      uid: int.parse(json["uid"]),
      nickname: json["nickname"],
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class GetUserDetail {
  final User basicInfo;
  final String gender;
  final int createTime;
  final int sid;
  final int threadCount;
  final int commentCount;
  final int fid;
  GetUserDetail(this.basicInfo, this.gender, this.createTime, this.sid,
      this.threadCount, this.commentCount, this.fid);

  factory GetUserDetail.fromJson(Map<String, dynamic> json) {
    return GetUserDetail(
        User.fromjson(json["basic_info"]),
        json["gender"],
        int.parse(json["create_time"]),
        int.parse(json["sid"]),
        int.parse(json["thread_count"]),
        int.parse(json["comment_count"]),
        int.parse(json["fid"]));
  }
}
