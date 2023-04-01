import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

import 'package:space_station/models/thread.dart';
import 'package:space_station/utils/constant.dart';
import 'package:space_station/views/_share/thread_listview.dart';

import '../../../models/tab_info.dart';
import 'category_selector.dart';

class MultiTabsThreadList extends StatefulWidget {
  final Future<ThreadsModel> Function(
    int pageID,
    int categoryID,
    String nextCursor,
  ) onRequest;

  const MultiTabsThreadList({Key? key, required this.onRequest})
      : super(key: key);

  @override
  State<MultiTabsThreadList> createState() => MultiTabsThreadListState();
}

class MultiTabsThreadListState extends State<MultiTabsThreadList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late KeysList _keysList;
  final tabs = kForumTabs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_onTabSwitched);
    _keysList = KeysList(tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: List.generate(
              tabs.length,
              (pageID) => DynamicTab(
                key: _keysList.tabs[pageID],
                tabInfo: tabs[pageID],
                onCategoryChanged: ((_) {
                  _keysList.views[pageID].currentState!.refresh();
                }),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                tabs.length,
                (pageID) => ThreadListView(
                  key: _keysList.views[pageID],
                  onRequest: (nextCursor) => widget.onRequest(
                      pageID + 1, currentCategoryID, nextCursor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get currentCategoryID {
    final tab = _keysList.tabs[_tabController.index].currentState;
    if (tab == null) return 0;
    return tab.categoryID;
  }

  void _onTabSwitched() {
    if (_tabController.indexIsChanging == true) return; //防止重複呼叫

    //隱藏上個分頁的子分頁選項
    _keysList.tabs[_tabController.previousIndex].currentState!.hideSelector();

    //顯示當前頁面的子分頁選項
    final currentTab = _keysList.tabs[_tabController.index].currentState!;
    currentTab.showSelector();

    //假如資為舊則刷新列表
    if (currentTab.isDataOutdated) {
      notifyParametersChanged();
      currentTab.isDataOutdated = false;
    }
  }

  void notifyParametersChanged() {
    //刷新當前頁面
    final view = _keysList.views[_tabController.index].currentState!;
    view.refresh();

    //將其它頁面的資料標記為舊，下次顯示時自動刷新
    for (var pageIndex = 0; pageIndex < _keysList.length; pageIndex++) {
      if (pageIndex != _tabController.index) {
        _keysList.tabs[pageIndex].currentState!.isDataOutdated = true;
      }
    }
  }

  void switchToTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _keysList.clear();
    super.dispose();
  }
}

class DynamicTab extends StatefulWidget {
  final TabInfo tabInfo;
  final void Function(int categoryID) onCategoryChanged;
  const DynamicTab({
    Key? key,
    required this.tabInfo,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  State<DynamicTab> createState() => DynamicTabState();
}

class DynamicTabState extends State<DynamicTab>
    with SingleTickerProviderStateMixin {
  int categoryID = 0;
  bool isDataOutdated = false;

  AnimationController? expandController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    if (widget.tabInfo.hasCategorySelector) {
      expandController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      animation = CurvedAnimation(
        parent: expandController!,
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Center(
        widthFactor: 1,
        child: Row(
          children: [
            Text(
              context.getString("page_${widget.tabInfo.key}"),
              softWrap: false,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            if (widget.tabInfo.hasCategorySelector)
              buildCategorySelector(context),
          ],
        ),
      ),
    );
  }

  Widget buildCategorySelector(BuildContext context) {
    return SizeTransition(
      axis: Axis.horizontal,
      axisAlignment: -1.0,
      sizeFactor: animation!,
      child: Align(
        alignment: AlignmentDirectional.center,
        child: CategorySelector(
          categoryKey: widget.tabInfo.categoryKey!,
          quantity: widget.tabInfo.categoriesQuantity!,
          categoryID: categoryID,
          onChanged: ((categoryID) {
            if (animation!.isCompleted) {
              this.categoryID = categoryID;
              widget.onCategoryChanged(categoryID);
              setState(() {});
            }
          }),
        ),
      ),
    );
  }

  void showSelector() {
    if (widget.tabInfo.hasCategorySelector) {
      expandController!.forward();
    }
  }

  void hideSelector() {
    if (widget.tabInfo.hasCategorySelector) {
      expandController!.reverse();
    }
  }

  @override
  void dispose() {
    if (widget.tabInfo.hasCategorySelector) {
      expandController!.dispose();
    }
    super.dispose();
  }
}

class KeysList {
  late List<GlobalKey<DynamicTabState>> tabs;
  late List<GlobalKey<ThreadListViewState>> views;
  KeysList(int quantity) {
    tabs = List.generate(quantity, (_) => GlobalKey<DynamicTabState>());
    views = List.generate(quantity, (_) => GlobalKey<ThreadListViewState>());
  }
  void clear() {
    tabs.clear();
    views.clear();
  }

  int get length {
    if (tabs.length != views.length) return 0;
    return views.length;
  }

  bool get isEmpty => length == 0;
}
