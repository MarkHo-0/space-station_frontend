import 'package:flutter/material.dart';

import '../../models/thread.dart';
import '../_share/loading_page.dart';
import '../_share/thread_item.dart';

class ThreadListView extends StatefulWidget {
  const ThreadListView(
      {super.key, required this.requestData, required this.onTaped});

  final Future<ThreadsModel> Function(String nextCursor) requestData;

  final void Function(int threadID) onTaped;

  @override
  State<ThreadListView> createState() => ThreadListViewState();
}

class ThreadListViewState extends State<ThreadListView>
    with AutomaticKeepAliveClientMixin<ThreadListView> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
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
      final data = await widget.requestData(cursor);

      if (freshLoad) threads.clear();
      threads.addAll(data.threadsArray);

      nextCursor = data.continuous;
    } catch (e) {
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
      return const Text('沒有數據');
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        itemCount: threads.length + 1,
        itemBuilder: buildItem,
        controller: _scrollController,
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    if (index == threads.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(width: 15),
                    Text('正在加載中...'),
                  ],
                )
              : const Text('空即是色 色即是空'),
        ),
      );
    }

    return ThreadItem(
      data: threads[index],
      onTap: ((threadID) => widget.onTaped(threadID)),
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
