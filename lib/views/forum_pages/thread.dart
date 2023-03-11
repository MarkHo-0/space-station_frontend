import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:space_station/models/thread.dart';
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
  List<Comment> comments = [];
  Thread? thread;
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
      if (thread!.pinedCid != null &&
          thread!.pinedCid! > 1 &&
          thread!.pinedCid! < comments.length) {
        Comment switcher = comments[thread!.pinedCid!];
        comments.removeAt(thread!.pinedCid!);
        comments.insert(1, switcher);
      }
      return ListView.builder(
        itemCount: comments.length + 1,
        itemBuilder: ((context, index) => buildItem(context, index)),
        controller: _scrollController,
      );
    }
  }

  Widget buildItem(BuildContext context, int currentIndex) {
    final bottomLoadingWidget = ColorFiltered(
      colorFilter:
          ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
      child: const AspectRatio(
        aspectRatio: 6 / 1,
        child: RiveAnimation.asset(
          'assets/animations/stars_twinkle.riv',
        ),
      ),
    );

    final bottomNoMoreWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        context.getString('no_more_items'),
        textAlign: TextAlign.center,
      ),
    );

    //列表最後的組件顯示
    if (currentIndex == comments.length) {
      return isLoading ? bottomLoadingWidget : bottomNoMoreWidget;
    }

    return CommentContiner(
      comment: comments[currentIndex],
      thread: thread!,
      index: currentIndex,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void updateCommentList(ThreadDetailModel value) {
    comments.addAll(value.commentsList);
    nextCursor = value.continuous;
    if (value.threadDetail != null) {
      thread = value.threadDetail;
    }
  }
}
