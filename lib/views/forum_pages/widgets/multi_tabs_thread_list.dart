// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'package:space_station/models/thread.dart';
import 'package:space_station/views/_share/thread_listview.dart';

import 'category_selector.dart';

class MultiTabsThreadList extends StatefulWidget {
  final List<TabInfo> tabs;
  final void Function(int threadID) onThreadTaped;
  final Future<ThreadsModel> Function(
      int pageID, int categoryID, String nextCursor) requestData;

  const MultiTabsThreadList({
    Key? key,
    required this.tabs,
    required this.onThreadTaped,
    required this.requestData,
  }) : super(key: key);

  @override
  State<MultiTabsThreadList> createState() => MultiTabsThreadListState();
}

class MultiTabsThreadListState extends State<MultiTabsThreadList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late KeysList _keysList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(_onTabSwitched);
    _keysList = KeysList(widget.tabs.length);
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
              widget.tabs.length,
              (pageID) => DynamicTab(
                key: _keysList.tabs[pageID],
                tabInfo: widget.tabs[pageID],
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
                widget.tabs.length,
                (pageID) => ThreadListView(
                  key: _keysList.views[pageID],
                  requestData: (nextCursor) => widget.requestData(
                      pageID + 1, currentCategoryID, nextCursor),
                  onTaped: widget.onThreadTaped,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get currentCategoryID {
    DynamicTabState? tab = _keysList.tabs[_tabController.index].currentState;
    if (tab == null) return 0;
    return tab.categoryID;
  }

  void _onTabSwitched() {
    if (_tabController.indexIsChanging == true) return; //防止重複呼叫
    _keysList.tabs[_tabController.previousIndex].currentState!.hideSelector();
    _keysList.tabs[_tabController.index].currentState!.showSelector();
  }

  void refreshCurrentView() {
    if (_keysList.views.isEmpty) return;
    ThreadListViewState? view =
        _keysList.views[_tabController.index].currentState;
    if (view == null) return;
    view.refresh();
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

class DynamicTabState extends State<DynamicTab> {
  bool _shouldShowSelector = false;
  int categoryID = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Center(
        widthFactor: 1,
        child: Row(
          children: [
            Text(
              "page_${widget.tabInfo.key}".i18n(),
              softWrap: false,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
            if (widget.tabInfo.hasCategorySelector)
              Visibility(
                visible: _shouldShowSelector,
                child: CategorySelector(
                  categoryKey: widget.tabInfo.categoryKey!,
                  quantity: widget.tabInfo.categoriesQuantity!,
                  categoryID: categoryID,
                  onChanged: ((categoryID) {
                    this.categoryID = categoryID;
                    widget.onCategoryChanged(categoryID);
                    setState(() {});
                  }),
                ),
              )
          ],
        ),
      ),
    );
  }

  void showSelector() {
    if (widget.tabInfo.hasCategorySelector == false) return;
    setState(() {
      _shouldShowSelector = true;
    });
  }

  void hideSelector() {
    if (widget.tabInfo.hasCategorySelector == false) return;
    setState(() {
      _shouldShowSelector = false;
    });
  }
}

class TabInfo {
  final String key;
  final String? categoryKey;
  final int? categoriesQuantity;
  const TabInfo({
    required this.key,
    this.categoryKey,
    this.categoriesQuantity,
  });

  bool get hasCategorySelector =>
      categoryKey != null &&
      categoryKey!.isNotEmpty &&
      categoriesQuantity != null &&
      categoriesQuantity! > 0;
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
}
