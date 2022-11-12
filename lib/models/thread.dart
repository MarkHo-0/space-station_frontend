class Stats {
  final int like;
  final int dislike;
  final int reply;

  Stats({
    required this.like,
    required this.dislike,
    required this.reply,
    });
  
  factory Stats.fromjson(Map<String, dynamic> json){
    return Stats(
      like: json["like"],
      dislike: json["dislike"],
      reply: json["reply"],
      );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class Sender {
  final int uid;
  final String nickname;
  final int subject_id;

  Sender({
    required this.uid,
    required this.nickname,
    required this.subject_id,
  });

  factory Sender.fromjson(Map<String, dynamic> json) {
    return Sender(
      uid: json["uid"],
      nickname: json["nickname"],
      subject_id: json["subject_id"],
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class Threads {
  final int tid;
  final int pid;
  final int fid;
  final int create_time;
  final int last_update_time;
  final String title;
  final int content_cid;
  final int pined_cid;
  final Stats stats;
  final Sender sender;

  Threads({
    required this.tid,
    required this.pid,
    required this.fid,
    required this.create_time,
    required this.last_update_time,
    required this.title,
    required this.content_cid,
    required this.pined_cid,
    required this.stats,
    required this.sender,
  });

  factory Threads.fromJson(Map<String, dynamic> json) {
    return Threads(
      tid: json["tid"],
      pid: json["pid"],
      fid: json["fid"],
      create_time: json["create_time"],
      last_update_time: json["last_update_time"],
      title: json["title"],
      content_cid: json["content_cid"],
      pined_cid: json["pined_cid"],
      stats: Stats.fromjson(json),
      sender: Sender.fromjson(json),
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
