import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'faculty_selector.dart';

class ForumTabBar extends StatefulWidget {
  final TabController tabController;

  const ForumTabBar({super.key, required this.tabController});

  @override
  State<ForumTabBar> createState() => _ForumTabBarState();
}

class _ForumTabBarState extends State<ForumTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      isScrollable: true,
      indicatorColor: Theme.of(context).primaryColor,
      tabs: [
        const DynamicTab(textKey: 'page_casual'),
        DynamicTab(
          textKey: 'page_academic',
          showOnSelected: Visibility(
            visible: widget.tabController.index == 1,
            maintainState: true,
            child: FacultySelector(
              onFacultyChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }
}

class DynamicTab extends StatelessWidget {
  final String textKey;
  final Widget? showOnSelected;
  const DynamicTab({super.key, required this.textKey, this.showOnSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Center(
        widthFactor: 1,
        child: Row(
          children: [
            Text(
              textKey.i18n(),
              softWrap: false,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
            if (showOnSelected != null) showOnSelected!
          ],
        ),
      ),
    );
  }
}
