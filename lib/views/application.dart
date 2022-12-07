import 'package:flutter/material.dart';

import './forum_pages/forum.dart';
import './home_pages/home.dart';
import './setting_pages/setting.dart';
import './toolbox_pages/toolbox.dart';

class ApplicationContainer extends StatefulWidget {
  const ApplicationContainer({super.key});

  @override
  State<ApplicationContainer> createState() => _ApplicationContainerState();
}

class _ApplicationContainerState extends State<ApplicationContainer> {
  int pageIndex = 0;
  final pages = const [HomePage(), ForumPage(), ToolboxPage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: pages[pageIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: pageIndex,
          onDestinationSelected: onDestinationClicked,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.forum), label: "Forum"),
            NavigationDestination(icon: Icon(Icons.home_repair_service), label: "Toolbox"),
            NavigationDestination(icon: Icon(Icons.settings), label: "Setting"),
          ],
        ),
      ),
    );
  }

  void onDestinationClicked(int index) {
    setState(() {
      pageIndex = index;
    });
  }
}
