class User {
  final int uid;
  final String nickname;
  final int subject_id;

  const User({
    required this.uid,
    required this.nickname,
    required this.subject_id,
  });

  factory User.fromjson(Map<String, dynamic> json) {
    return User(
      uid: json["uid"],
      nickname: json["nickname"],
      subject_id: json["subject_id"],
    );
  }
}
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
