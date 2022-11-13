import 'user.dart';


//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class News {
  final String title;
  final String content;
  final int create_time;
  final int valid_time;

  News({
    required this.title,
    required this.content,
    required this.create_time,
    required this.valid_time,
  });

  factory News.fromjson(Map<String, dynamic> json) {
    return News(
      title: json["title"],
      content: json["content"],
      create_time: json["create_time"],
      valid_time: json["valid_time"],
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
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
class ThreadSender {
  final int uid;
  final String nickname;
  final int subject_id;

  ThreadSender({
    required this.uid,
    required this.nickname,
    required this.subject_id,
  });

  factory ThreadSender.fromjson(Map<String, dynamic> json) {
    return ThreadSender(
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
  final ThreadSender threadsender;

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
    required this.threadsender,
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
      stats: Stats.fromjson(json["stats"]),                        //json["stats"] return map
      threadsender: ThreadSender.fromjson(json["threadsender"]),   //json["threadsender"] return map
    );   //homedata 將 json "threads"的array 的 單獨index 的Map 比threads object
  }
}
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//Called in api
class HomeData {
  List<News> NewsArray;
  List<Threads> ThreadsArray;
  User user;

  HomeData(
    this.NewsArray,
    this.ThreadsArray,
    this.user,
  );

  factory HomeData.fromJson(Map<String, dynamic> json) {
    List<String> a = json["News"]; //json[title] is a List
    List<String> b = json["Threads"]; //json["Threads"] is a List
    List<News> c = [];
    List<Threads> d = [];
    for (int i = 0; i < a.length; i++) {
      c.add(News.fromjson(jsonDecode(a[
          i]))); //each index item is String and convert back to Map ,and assign object to new List
    }
    for (int t = 0; t < b.length; t++) {
      d.add(Threads.fromJson(jsonDecode(a[t])));
    }
    return HomeData(c, d, User.fromjson(json["user"]));
  }
}
//要將json Map 分"thread"同"news"拆成Array  比 threads同news
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
