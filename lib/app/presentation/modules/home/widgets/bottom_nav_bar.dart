import 'package:border_bottom_navigation_bar/border_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../../../config/color_config.dart';
import '../controller/home_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.onTap,
    required this.controller,
  });

  final Function(int) onTap;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return BorderBottomNavigationBar(
      height: 53,
      borderRadiusValue: 8,
      selectedLabelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      selectedBackgroundColor: ColorConfig.primary,
      unselectedBackgroundColor: Colors.white,
      unselectedIconColor: Colors.black54,
      selectedIconColor: Colors.white,
      onTap: onTap,
      currentIndex: controller.currentIndex,
      customBottomNavItems: [
        BorderBottomNavigationItems(
          icon: Icons.home,
        ),
        BorderBottomNavigationItems(
          icon: Icons.perm_contact_calendar,
        ),
        BorderBottomNavigationItems(
          icon: Icons.people,
        ),
      ],
    );
  }
}
