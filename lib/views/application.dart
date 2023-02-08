import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';

import './forum_pages/forum.dart';
import './home_pages/home.dart';
import 'profile_pages/profile.dart';
import './toolbox_pages/toolbox.dart';

class ApplicationContainer extends StatefulWidget {
  const ApplicationContainer({super.key});

  @override
  State<ApplicationContainer> createState() => _ApplicationContainerState();
}

class _ApplicationContainerState extends State<ApplicationContainer> {
  int pageIndex = 0;
  final pages = const [HomePage(), ForumPage(), ToolboxPage(), ProfilePage()];
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        onDestinationSelected: onDestinationClicked,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: context.getString('home_page'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.forum),
            label: context.getString('forum_page'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.home_repair_service),
            label: context.getString('toolbox_page'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.people),
            label: context.getString('profile_page'),
          ),
        ],
      ),
    );
  }

  void onDestinationClicked(int index) {
    setState(() {
      pageIndex = index;
      pageController.jumpToPage(index);
    });
  }
}
