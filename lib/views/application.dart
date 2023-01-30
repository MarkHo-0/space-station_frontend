import 'package:flutter/material.dart';

import './forum_pages/forum.dart';
import './home_pages/home.dart';
import 'profile_pages/profile.dart';
import './toolbox_pages/toolbox.dart';
import 'package:localization/localization.dart';

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
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: pageIndex,
          onDestinationSelected: onDestinationClicked,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home), label: 'home_page'.i18n()),
            NavigationDestination(icon: const Icon(Icons.forum), label: 'forum_page'.i18n()),
            NavigationDestination(icon: const Icon(Icons.home_repair_service), label: 'toolbox_page'.i18n()),
            NavigationDestination(icon: const Icon(Icons.people), label: 'profile_page'.i18n()),
          ],
        ),
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
