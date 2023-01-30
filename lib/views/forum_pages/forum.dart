import 'package:flutter/material.dart';

import 'package:space_station/models/thread.dart';
import 'widgets/multi_tabs_thread_list.dart';
import './widgets/forum_top_panel.dart';
import '../../api/interfaces/forum_api.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with AutomaticKeepAliveClientMixin<ForumPage> {
  final _forumKey = GlobalKey<MultiTabsThreadListState>();

  int orderID = 1;
  String queryText = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        ForumTopPanel(
          onSearch: (value) => refreshList(queryText: value),
          onOrderChanged: (value) => refreshList(orderID: value),
          onGoToPostPage: onGoToPostPage,
        ),
        MultiTabsThreadList(
          key: _forumKey,
          tabs: _kTabs,
          onThreadTaped: onThreadTaped,
          requestData: requestThreads,
        ),
      ],
    );
  }

  void refreshList({int? orderID, String? queryText}) {
    if (orderID != null) this.orderID = orderID;
    if (queryText != null) this.queryText = queryText;
    _forumKey.currentState!.notifyParametersChanged();
  }

  Future<ThreadsModel> requestThreads(
      int pageID, int facultyID, String nextCursor) {
    return getThreads(
      pageID: pageID,
      facultyID: facultyID,
      orderID: orderID,
      queryText: queryText,
      nextCursor: nextCursor,
    );
  }

  void onThreadTaped(int threadID) {
    //TODO: 跳轉到貼文頁面
  }

  void onGoToPostPage() {
    //TODO: 跳轉到發佈頁面
  }

  @override
  bool get wantKeepAlive => true;
}

const List<TabInfo> _kTabs = [
  TabInfo(key: 'casual'),
  TabInfo(key: 'academic', categoryKey: 'faculty', categoriesQuantity: 6),
];
