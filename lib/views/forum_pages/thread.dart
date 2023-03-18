import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/thread.dart';
import '../../utils/parse_time.dart';
import '../_share/loading_banner.dart';
import '../../api/interfaces/forum_api.dart';
import '../../models/comment.dart';
import '../../providers/auth_provider.dart';
import '../_share/unknown_error_popup.dart';
import 'reply.dart';
import 'widgets/comment_continer.dart';

class ThreadPage extends StatefulWidget {
  final int threadID;
  const ThreadPage(this.threadID, {super.key});

  @override
  State<ThreadPage> createState() => ThreadPageState();
}

class ThreadPageState extends State<ThreadPage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isNetError = false;

  ValueNotifier<int?> pinnedCommentID = ValueNotifier(null);
  List<Comment> comments = [];
  String nextCursor = "";
  Thread? thread;
  int? startViewingTime;
  bool isOwnedByMe = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      final pos = _scrollController.position;
      if (pos.pixels > pos.maxScrollExtent - 40) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore({freshLoad = false}) async {
    if (isLoading) return;
    if (comments.isNotEmpty && nextCursor.isEmpty && !freshLoad) return;

    setState(() => isLoading = true);
    return getThread(widget.threadID, freshLoad ? '' : nextCursor)
        .then((value) => onLoaded(value, freshLoad))
        .onError((e, __) => showUnkownErrorDialog(context))
        .whenComplete(() => setState(() => isLoading = false));
  }

  void onLoaded(ThreadDetailModel data, bool shouldClearOld) {
    if (shouldClearOld) comments.clear();
    if (thread != null) startViewingTime = getCurrUnixTime();
    if (data.threadDetail != null) {
      thread = data.threadDetail;
      pinnedCommentID.value = thread!.pinedCid;
      if (getLoginedUser(context)?.uid == thread!.sender.uid) {
        isOwnedByMe = true;
      }
    }
    nextCursor = data.continuous;
    comments.addAll(data.commentsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: FittedBox(
          fit: BoxFit.fill,
          child: Text(thread == null ? 'Loading' : thread!.title),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () => onPostComment(context, null, null),
              icon: const Icon(Icons.reply),
            ),
          ),
        ],
      ),
      body: buildbody(context),
    );
  }

  Widget buildbody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadMore(freshLoad: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: ScrollPhysics()),
        controller: _scrollController,
        children: List.generate(
          comments.length + 1,
          (floorIndex) => buildComment(context, floorIndex),
        ),
      ),
    );
  }

  Widget buildComment(BuildContext context, int currentIndex) {
    //列表最後的組件顯示
    if (currentIndex == comments.length) {
      if (isLoading) return const LoadingBanner();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          context.getString('no_more_items'),
          textAlign: TextAlign.center,
        ),
      );
    }

    return CommentContiner(
      comment: comments[currentIndex],
      currentPinned: pinnedCommentID,
      floorIndex: currentIndex,
      isOwnedParentThread: isOwnedByMe,
      onPin: onPinComment,
      onReply: onPostComment,
    );
  }

  void onPostComment(BuildContext ctx, int? replyToFloor, Function? onDone) {
    final user = getLoginedUser(ctx, warnOnEmpty: true);
    if (user == null) return;

    Comment? replyToCMT;
    if (replyToFloor != null) replyToCMT = comments[replyToFloor];

    Future<bool> runner(String content) {
      return postComment(widget.threadID, content, replyToCMT?.cid).then(
        (newCommentID) {
          user.commentCount.value++;
          if (onDone != null) onDone();
          if (nextCursor.isEmpty) {
            final cmt = Comment.byUser(newCommentID, content, user, replyToCMT);
            setState(() => comments.add(cmt));
            Future.delayed(const Duration(milliseconds: 500), scrollToBottom);
          }
          return Future.value(true);
        },
      ).catchError((err) {
        showUnkownErrorDialog(ctx);
        return Future.value(false);
      });
    }

    Navigator.of(ctx).push(
      CupertinoPageRoute(
        builder: ((_) => ReplyPage(runner, replyToCMT, replyToFloor)),
      ),
    );
  }

  void onPinComment(BuildContext context, int commentID) {
    if (getLoginedUser(context, warnOnEmpty: true) == null) return;
    pinComment(commentID).then(
      (newID) => pinnedCommentID.value = newID,
      onError: (err) => showUnkownErrorDialog(context),
    );
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    if (startViewingTime != null) {
      final viewDuration = getCurrUnixTime() - startViewingTime!;
      if (kDebugMode) print('viewTime: $viewDuration');
      recordViewTime(widget.threadID, viewDuration).onError((_, __) => null);
    }
    _scrollController.dispose();
    pinnedCommentID.dispose();
    super.dispose();
  }
}
