import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:space_station/views/_share/network_error_page.dart';

import '../../api/error.dart';
import '../../models/thread.dart';
import '../_share/loading_page.dart';
import '../_share/thread_item.dart';

class ThreadListView extends StatefulWidget {
  const ThreadListView({super.key, required this.onRequest});

  final Future<ThreadsModel> Function(String nextCursor) onRequest;

  @override
  State<ThreadListView> createState() => ThreadListViewState();
}

class ThreadListViewState extends State<ThreadListView>
    with AutomaticKeepAliveClientMixin<ThreadListView> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  bool isNetError = false;
  String nextCursor = '';
  List<Thread> threads = [];

  @override
  void initState() {
    super.initState();
    _loadMore(freshLoad: true);
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
    if (!freshLoad && nextCursor.isEmpty) return;
    setState(() => isLoading = true);
    try {
      final cursor = freshLoad ? '' : nextCursor;
      final data = await widget.onRequest(cursor);

      if (freshLoad) threads.clear();
      threads.addAll(data.threadsArray);

      nextCursor = data.continuous;
    } catch (e) {
      if (e is NetworkError) isNetError = true;
      nextCursor = '';
    }

    setState(() => isLoading = false);
    return Future.value();
  }

  Future<void> refresh() async {
    await _loadMore(freshLoad: true);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (threads.isEmpty) {
      if (isLoading) return const LoadingPage();
      if (isNetError) return const NetworkErrorPage();
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          context.getString('no_items_found'),
          textAlign: TextAlign.center,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: threads.length + 1,
        itemBuilder: buildItem,
        controller: _scrollController,
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    //列表最後的組件顯示
    if (index == threads.length) {
      if (isLoading) return buildLoadingWidget(context);
      return buildBottomNoMoreWidget(context);
    }

    return ThreadItem(data: threads[index]);
  }

  Widget buildLoadingWidget(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Theme.of(context).primaryColor,
        BlendMode.srcIn,
      ),
      child: const AspectRatio(
        aspectRatio: 6 / 1,
        child: RiveAnimation.asset('assets/animations/stars_twinkle.riv'),
      ),
    );
  }

  Widget buildBottomNoMoreWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        context.getString('no_more_items'),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
