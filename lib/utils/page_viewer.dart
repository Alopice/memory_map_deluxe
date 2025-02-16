import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/pages/home_page.dart';
import 'package:memory_map/pages/map_page.dart';
import 'package:memory_map/pages/marker_list_page.dart';
import 'package:memory_map/pages/settings_page.dart';

class PageViewer extends StatelessWidget {
  PageViewer({super.key});

  final PageController _pageController = PageController(initialPage: 0);

  int selectedIndex = 0;

  final GlobalKey<ConvexAppBarState> _convexAppBarKey = GlobalKey<ConvexAppBarState>();

  @override
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          HomePage(),
          MarkerListPage(),
          MapPage(),
          SettingsPage()
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        key: _convexAppBarKey,
        initialActiveIndex: selectedIndex, // Ensuring it starts with the correct index
        onTap: (index) {
        
            selectedIndex = index;
        
          _pageController.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.linear,
          );
        },
        items: const [
          TabItem(icon: Icons.home_outlined),
          TabItem(icon: Icons.list_outlined),
          TabItem(icon: Icons.map_outlined),
          TabItem(icon: Icons.settings_outlined),
        ],
      ),
    );
  }
}
