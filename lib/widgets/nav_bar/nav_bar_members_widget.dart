import 'package:depozio/router/app_page.dart';
import 'package:depozio/widgets/buttons/nav_bar_action_button.dart';
import 'package:depozio/widgets/global/global_action_bottom_sheet.dart';
import 'package:flutter/material.dart';

class NavBarMembersWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NavBarMembersWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20), // No top margin
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Left side navigation items (first 2)
          ..._getSortedNavigationPages().take(2).map((page) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: __buildNavBarMember(
                    icon: page.icon,
                    index: page.navBarMemberIndex,
                  ),
                ),
              )),
          // Center action button
          NavBarActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                isDismissible: true,
                enableDrag: true,
                builder: (context) => const ActionBottomSheet(
                  maxHeightPercentage: 0.9,
                ),
              );
            },
          ),
          // Right side navigation items (last 2)
          ..._getSortedNavigationPages().skip(2).map((page) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: __buildNavBarMember(
                    icon: page.icon,
                    index: page.navBarMemberIndex,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  /// Get navigation pages sorted by navBarMemberIndex in ascending order
  List<AppPage> _getSortedNavigationPages() {
    return AppPage.values
        .where(
            (page) => page.navBarMemberIndex != 99) // Filter out non-nav pages
        .toList()
      ..sort((a, b) => a.navBarMemberIndex
          .compareTo(b.navBarMemberIndex)); // Sort by navBarMemberIndex ASC;
  }

  Widget __buildNavBarMember({
    required IconData icon,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFC107) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.black : Colors.grey[600],
            size: 20,
          ),
        ),
      ),
    );
  }
}
