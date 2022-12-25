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
        like: int.parse(json["like"]),
        dislike: int.parse(json["dislike"]),
        reply: int.parse(json["reply"]),
        me: int.parse(json["me"]));
  }
}

class Comments {
  final int cid;
  final String content;
  final int createTime;
  final Comments? replyto;
  CommentStats stats;
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
        cid: int.parse(json["cid"]),
        content: json["content"],
        createTime: int.parse(json["createTime"]),
        replyto:
            Comments.fromjson(json["reply_to"]), //json["reply_to"] is a map
        stats: CommentStats.fromjson(json["stats"]),
        sender: Sender.fromjson(json["sender"]),
        status: int.parse(json["status"]));
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

class CommentReplies {
  final int cid;
  final String content;
  final int createTime;
  CommentStats stats;
  final Sender sender;

  CommentReplies(
      {required this.cid,
      required this.content,
      required this.createTime,
      required this.stats,
      required this.sender});

  factory CommentReplies.fromjson(Map<String, dynamic> json) {
    return CommentReplies(
        cid: int.parse(json["cid"]),
        content: json["content"],
        createTime: int.parse(json["createTime"]),
        stats: CommentStats.fromjson(json["stats"]),
        sender: Sender.fromjson(json["sender"]));
  }
}

class GetSingleCommentDetail {
  Comments comment;
  List<CommentReplies> replies;

  GetSingleCommentDetail(this.comment, this.replies);

  factory GetSingleCommentDetail.fromjson(Map<String, dynamic> json) {
    List<String> a = json[
        "replies"]; //json["replies"] return List , all index element become String
    List<CommentReplies> b = [];
    for (int i = 0; i < a.length; i++) {
      b.add(CommentReplies.fromjson(jsonDecode(a[i])));
    }
    return GetSingleCommentDetail(Comments.fromjson(json["comment"]), b);
  }
}

class LikeDislikeCount {
  bool liked;
  bool disliked;
  LikeDislikeCount(this.liked, this.disliked);
  factory LikeDislikeCount.fromjson(Map<String, dynamic> json) {
    bool x = (json["liked"] == 'true');
    bool y = (json["disliked"] == 'true');
    return LikeDislikeCount(x, y);
  }
}
