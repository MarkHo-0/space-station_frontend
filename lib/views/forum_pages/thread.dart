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
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isNetError = false;
  String nextCursor = "";
  List<Widget> items = [];
  List<int> order = [];
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

  void _loadMore() async {
    //如果正在正在加載則退出
    if (isLoading) return Future.value();
    //如果沒有下一頁也退出
    if (comments.isNotEmpty && nextCursor.isEmpty) return;
    setState(() => isLoading = true);
    getThread(widget.threadID, nextCursor)
        .then((value) => updateCommentList(value))
        .onError((e, __) => showUnkownErrorDialog(context))
        .whenComplete(() => setState(() => isLoading = false));
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
        order.add(i);
        items.add(buildItem(context, i));
      }
      if (thread!.pinedCid != null) {
        for (int i = 0; i < comments.length; i++) {
          if (thread!.pinedCid == comments[i].cid && i != 0) {
            items.insert(1, items.removeAt(i));
          }
        }
      }
      items.add(buildItem(context, comments.length));

      return ListView(
        controller: _scrollController,
        children: items,
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
      recordViewTime(widget.threadID, viewDuration).ignore();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void updateCommentList(ThreadDetailModel value) {
    comments.addAll(value.commentsList);
    nextCursor = value.continuous;
    if (value.threadDetail != null) {
      thread = value.threadDetail;
      startViewingTime = getCurrUnixTime();
    }
  }
}
