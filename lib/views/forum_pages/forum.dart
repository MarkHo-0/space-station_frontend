import 'package:flutter/material.dart';

import 'package:space_station/models/thread.dart';
import '../_share/thread_listview.dart';
import './widgets/forum_tabbar.dart';
import './widgets/forum_top_panel.dart';
import '../../api/interfaces/forum_api.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int facultyID = 0, orderID = 0;
  String quary = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ForumTopPanel(
          onSearch: (value) => updateParams(quary: value),
          onOrderChanged: (value) => updateParams(orderID: value),
        ),
        ForumTabBar(
          tabController: tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              ThreadListView(
                onLoad: loadThreads,
                onTaped: onThreadTaped,
              ),
              ThreadListView(
                onLoad: loadThreads,
                onTaped: onThreadTaped,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void updateParams({facultyID, int? orderID, String? quary}) {
    if (facultyID != null) this.facultyID = facultyID;
    if (orderID != null) this.orderID = orderID;
    if (quary != null) this.quary = quary;
  }

  void loadThreads(String? nextCursor, void Function(ThreadsModel?) onLoaded) {
    getThreads(
      pageID: tabController.index + 1,
      facultyID: facultyID,
      orderID: orderID,
      nextCursor: nextCursor,
    )
        .then((result) => onLoaded(result))
        .onError((error, stackTrace) => onLoaded(null));
  }

  void onThreadTaped(int threadID) {
    print(threadID);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
