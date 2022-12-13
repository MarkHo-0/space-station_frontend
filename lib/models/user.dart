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
}
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
