import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:space_station/models/thread.dart';
import 'package:space_station/utils/parse_time.dart';
import 'package:space_station/views/forum_pages/widgets/comment_continer.dart';
import '../../api/interfaces/forum_api.dart';
import '../../models/comment.dart';
import '../_share/loading_page.dart';
import '../_share/network_error_page.dart';
import '../_share/unknown_error_popup.dart';

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
  String nextCursor = "";
  List<Widget> items = [];
  List<Comment> comments = [];
  Thread? thread;
  int? startViewingTime;
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
    //如果正在正在加載則退出
    if (isLoading) return Future.value();

    //如果沒有下一頁也退出
    if (comments.isNotEmpty && nextCursor.isEmpty && !freshLoad) return;

    setState(() => isLoading = true);
    return getThread(widget.threadID, freshLoad ? '' : nextCursor)
        .then((value) => updateCommentList(value, freshLoad))
        .onError((e, __) => showUnkownErrorDialog(context))
        .whenComplete(() => setState(() => isLoading = false));
  }

  Future<void> _refresh() {
    return _loadMore(freshLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(thread == null ? 'Loading' : thread!.title),
      ),
      body: buildbody(context),
    );
  }

  Widget buildbody(BuildContext context) {
    if (comments.isEmpty) {
      if (isLoading) return const LoadingPage();
      if (isNetError) return const NetworkErrorPage();
      return Text(
        context.getString('no_items_found'),
        textAlign: TextAlign.center,
      );
    } else {
      items = [];
      for (int i = 0; i < comments.length; i++) {
        items.add(buildItem(context, i));
      }
      if (thread!.pinedCid != null) {
        for (int i = 0; i < comments.length; i++) {
          if (thread!.pinedCid == comments[i].cid) {
            items.insert(0, items.removeAt(i));
            break;
          }
        }
      }
      items.add(buildItem(context, comments.length));

      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(parent: ScrollPhysics()),
          controller: _scrollController,
          children: items,
        ),
      );
    }
  }

  Widget buildItem(BuildContext context, int currentIndex) {
    //列表最後的組件顯示
    if (currentIndex == comments.length) {
      if (isLoading) {
        return ColorFiltered(
          colorFilter:
              ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
          child: const AspectRatio(
            aspectRatio: 6 / 1,
            child: RiveAnimation.asset(
              'assets/animations/stars_twinkle.riv',
            ),
          ),
        );
      }
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
      thread: thread!,
      index: currentIndex,
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
    super.dispose();
  }

  void updateCommentList(ThreadDetailModel value, bool shouldClearOld) {
    if (shouldClearOld) comments.clear();
    comments.addAll(value.commentsList);
    nextCursor = value.continuous;
    if (value.threadDetail != null) {
      thread = value.threadDetail;
      startViewingTime = getCurrUnixTime();
    }
  }

  void addComment(Comment comment) {
    comments.add(comment);
    setState(() {});
  }
}
