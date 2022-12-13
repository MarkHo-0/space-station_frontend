import 'dart:convert';
import 'User.dart';

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
  int reply;

  Stats({
    required this.like,
    required this.dislike,
    required this.reply,
  });

  factory Stats.fromjson(Map<String, dynamic> json) {
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

  Sender({
    required this.uid,
    required this.nickname,
  });

  factory Sender.fromjson(Map<String, dynamic> json) {
    return Sender(
      uid: json["uid"],
      nickname: json["nickname"],
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class Threads {
  final int tid;
  final int pid;
  final int fid;
  final int createTime;
  final int lastUpdateTime;
  final String title;
  final int contentCid;
  final int? pinedCid;
  Stats stats;
  Sender sender;

  Threads({
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

  factory Threads.fromJson(Map<String, dynamic> json) {
    return Threads(
      tid: json["tid"],
      pid: json["pid"],
      fid: json["fid"],
      createTime: json["create_time"],
      lastUpdateTime: json["last_update_time"],
      title: json["title"],
      contentCid: json["content_cid"],
      pinedCid: json["pined_cid"],
      stats: Stats.fromjson(json["stats"]), //json["stats"] return map
      sender: Sender.fromjson(
          json["threadsender"]), //json["threadsender"] return map
    ); //homedata 將 json "threads"的array 的 單獨index 的Map 比threads object
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//Called in api "/home"
class GetHomeData {
  final List<News> newsArray;
  final List<Threads> threadsArray;
  final User user;

  GetHomeData(
    this.newsArray,
    this.threadsArray,
    this.user,
  ); //gethome object is not a map

  factory GetHomeData.fromJson(Map<String, dynamic> json) {
    List<String> a = json["News"]; //json["News"] is a List
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
    return GetHomeData(
        c, d, User.fromjson(json["user"])); //json["user"] is a Map
  }
}

//要將json Map 分"thread"同"news"拆成Array  比 threads同news
// ignore: camel_case_types
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
class Hasnext {
  final bool hasMore;
  final String nextCursor;

  Hasnext({required this.hasMore, required this.nextCursor});

  factory Hasnext.fromJson(Map<String, dynamic> json) {
    return Hasnext(
      hasMore: json["has_more"],
      nextCursor: json["next_cursor"],
    );
  }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//Called in api "/thread"
class GetThreadPage {
  List<Threads> threadsArray;
  Hasnext hasNext;

  GetThreadPage(
    this.threadsArray,
    this.hasNext,
  );

  factory GetThreadPage.fromJson(Map<String, dynamic> json) {
    List<String> a = json["Threads"];
    List<Threads> b = [];
    for (int i = 0; i < a.length; i++) {
      b.add(Threads.fromJson(jsonDecode(a[i])));
    }

    return GetThreadPage(
        b,
        Hasnext.fromJson(
            json["has_next"])); //json is map json["has_next"] is a Map
  }
}

class GetSearchedThread {
  final List<Threads> threadsList;
  final Hasnext hasnext;
  final String query;

  GetSearchedThread(this.threadsList, this.hasnext, this.query);

  factory GetSearchedThread.fromJson(Map<String, dynamic> json) {
    List<String> a = json[
        "threads"]; //json["threads"] return List , all index element become String
    List<Threads> b = [];
    for (int i = 0; i < a.length; i++) {
      b.add(Threads.fromJson(jsonDecode(a[
          i]))); //index element from string to map and assign to create object Threads
    }
    return GetSearchedThread(
        b, Hasnext.fromJson(json["has_next"]), json["query"]);
  }
}
