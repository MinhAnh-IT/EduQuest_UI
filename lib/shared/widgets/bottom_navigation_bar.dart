import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap; // Optional custom handler
  final Map<int, String>? customRoutes; // Optional custom routes

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    this.onTap, // Optional custom handler
    this.customRoutes, // Optional custom routes
  }) : super(key: key);

  // Default routes mapping
  static const Map<int, String> _defaultRoutes = {
    0: '/home',
    1: '/profile',
  };

  void _handleNavigation(BuildContext context, int index) {
    // If custom onTap is provided, use it
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Use custom routes if provided, otherwise use default
    final routes = customRoutes ?? _defaultRoutes;
    final route = routes[index];

    if (route != null) {
      // For home page, clear the navigation stack
      if (index == 0) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (route) => false,
        );
      } else {
        Navigator.pushNamed(context, route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Hồ sơ',
        ),
      ],
    );
  }
}