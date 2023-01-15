import 'package:flutter/widgets.dart';

import '../../models/thread.dart';
import '../_share/loading_page.dart';
import '../_share/thread_item.dart';

class ThreadListView extends StatefulWidget {
  const ThreadListView(
      {super.key, required this.onLoad, required this.onTaped});

  final void Function(String? nextCursor, void Function(ThreadsModel?)) onLoad;

  final void Function(int threadID) onTaped;

  @override
  State<ThreadListView> createState() => _ThreadListViewState();
}

class _ThreadListViewState extends State<ThreadListView>
    with AutomaticKeepAliveClientMixin<ThreadListView> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  String nextCursor = "";
  List<Thread> threads = [];

  void loadMore() {
    setState(() => isLoading = true);
    widget.onLoad(nextCursor, (reuslt) {
      if (reuslt != null) {
        threads.addAll(reuslt.threadsArray);
        nextCursor = reuslt.continuous;
      }
      setState(() => isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    loadMore();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (threads.isEmpty) {
      if (isLoading) return const LoadingPage();
      return const Text('沒有數據');
    }

    return ListView.builder(
      itemCount: threads.length,
      itemBuilder: ((_, i) => ThreadItem(
            data: threads[i],
            onTap: ((threadID) => widget.onTaped(threadID)),
          )),
      controller: _scrollController,
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
