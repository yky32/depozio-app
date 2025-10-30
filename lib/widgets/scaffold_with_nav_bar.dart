import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:depozio/widgets/nav_bar/nav_bar_members_widget.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Extend body behind bottom navigation
      backgroundColor: Colors.white, // Set to match page background
      body: Stack(
        children: [
          // Main content - let it extend fully
          navigationShell,

          // Floating navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: -15, // Move it lower by 15 pixels
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                color: Colors.transparent,
                child: SafeArea(
                  top: false,
                  child: NavBarMembersWidget(
                    selectedIndex: navigationShell.currentIndex,
                    onItemTapped: navigationShell.goBranch,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
