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
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedIconTheme: const IconThemeData(color: Colors.black54),
        selectedIconTheme: const IconThemeData(color: Colors.black87),
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.home_repair_service), label: "Toolbox"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
        currentIndex: pageIndex,
        onTap: onItemClick,
      ),
    );
  }

  void onItemClick(int index) {
    setState(() {
      pageIndex = index;
    });
  }
}
