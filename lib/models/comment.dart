import 'dart:convert';

import '../models/thread.dart';
import '../models/user.dart';

class CommentStats {
  int like;
  int dislike;
  int reply;
  int me;

  CommentStats(
      {required this.like,
      required this.dislike,
      required this.reply,
      required this.me});

  factory CommentStats.fromjson(Map<String, dynamic> json) {
    return CommentStats(
        like: json["like"],
        dislike: json["dislike"],
        reply: json["reply"],
        me: json["me"]);
  }
}

class Comments {
  final int cid;
  final String content;
  final int createTime;
  final Comments? replyto;
  final CommentStats stats;
  final Sender sender;
  final int status;
  Comments(
      {required this.cid,
      required this.content,
      required this.createTime,
      required this.replyto,
      required this.stats,
      required this.sender,
      required this.status});
  factory Comments.fromjson(Map<String, dynamic> json) {
    return Comments(
        cid: json["cid"],
        content: json["content"],
        createTime: json["createTime"],
        replyto:
            Comments.fromjson(json["reply_to"]), //json["reply_to"] is a map
        stats: CommentStats.fromjson(json["stats"]),
        sender: Sender.fromjson(json["sender"]),
        status: json["status"]);
  }
}

class GetThreadinsideComment {
  final List<Comments> commentsList;
  final Hasnext hasnext;
  final Threads threadDetail;

  GetThreadinsideComment(this.commentsList, this.hasnext, this.threadDetail);

  factory GetThreadinsideComment.fromJson(Map<String, dynamic> json) {
    List<String> a = json[
        "comments"]; //json["comments"] return List , all index element become String
    List<Comments> b = [];
    for (int i = 0; i < a.length; i++) {
      b.add(Comments.fromjson(jsonDecode(a[i])));
    }
    return GetThreadinsideComment(
        b,
        Hasnext.fromJson(
            json["has_next"]), //json["has_next"] is map, b is <List>Comments
        Threads.fromJson(json["thread_detail"])); //json["thread_detail"] is map
  }
}
