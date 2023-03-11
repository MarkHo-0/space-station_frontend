import 'user.dart';

class News {
  final String title;
  final int uuid;
  final String content;
  final int publicTime;

  News({
    required this.title,
    required this.uuid,
    required this.content,
    required this.publicTime,
  });

  factory News.fromjson(Map<String, dynamic> json) {
    return News(
      title: json["title"],
      uuid: json["uuid"],
      content: json["content"],
      publicTime: json["public_time"],
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class Stats {
  int like;
  int dislike;
  int comment;

  Stats({
    required this.like,
    required this.dislike,
    required this.comment,
  });

  factory Stats.fromjson(Map<String, dynamic> json) {
    return Stats(
      like: json["like"],
      dislike: json["dislike"],
      comment: json["comment"],
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class Thread {
  final int tid;
  final int pid;
  final int fid;
  final int createTime;
  final int lastUpdateTime;
  final String title;
  final int contentCid;
  int? pinedCid;
  final Stats stats;
  final User sender;

  Thread({
    required this.tid,
    required this.pid,
    required this.fid,
    required this.createTime,
    required this.lastUpdateTime,
    required this.title,
    required this.contentCid,
    required this.pinedCid,
    required this.stats,
    required this.sender,
  }); //Threads object is a map

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      tid: json["tid"],
      pid: json["pid"],
      fid: json["fid"] ?? 0,
      createTime: json["create_time"],
      lastUpdateTime: json["last_update_time"],
      title: json["title"],
      contentCid: json["content_cid"],
      pinedCid: json["pined_cid"],
      stats: Stats.fromjson(json["stats"]), //json["stats"] return map
      sender: User.fromjson(json["sender"]), //json["threadsender"] return map
    ); //homedata 將 json "threads"的array 的 單獨index 的Map 比threads object
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//Called in api "/home"
class HomePageModel {
  final List<News> newsArray;
  final List<Thread> threadsArray;
  final User? user;

  HomePageModel(
    this.newsArray,
    this.threadsArray,
    this.user,
  ); //gethome object is not a map

  factory HomePageModel.fromJson(Map<String, dynamic> json) {
    //json["News"] is a List //json["Threads"] is a List
    List<News> news =
        (json["news"] as Iterable).map((n) => News.fromjson(n)).toList();
    List<Thread> threads =
        (json["threads"] as Iterable).map((t) => Thread.fromJson(t)).toList();
    User? user = json["user"] == null ? null : User.fromjson(json["user"]);

    return HomePageModel(news, threads, user); //json["user"] is a Map
  }
}

//要將json Map 分"thread"同"news"拆成Array  比 threads同news
// ignore: camel_case_types
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//Called in api "/thread"
class ThreadsModel {
  List<Thread> threadsArray;
  String continuous;

  ThreadsModel(
    this.threadsArray,
    this.continuous,
  );

  factory ThreadsModel.fromJson(Map<String, dynamic> json) {
    List<Thread> threads =
        (json["threads"] as Iterable).map((t) => Thread.fromJson(t)).toList();
    return ThreadsModel(
        threads, json["continuous"]); //json is map json["has_next"] is a Map
  }
}
