import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/theme/app_colors.dart';

/// Bottom navigation bar widget for main app navigation
/// Shared component used across multiple features
/// Follows KISS principle with simple, clear navigation
/// Uses AppColors for consistent theming
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.navSelected,
        unselectedItemColor: AppColors.navUnselected,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.home, size: 26),
            activeIcon: Icon(FeatherIcons.home, size: 26),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.package, size: 26),
            activeIcon: Icon(FeatherIcons.package, size: 26),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.barChart2, size: 26),
            activeIcon: Icon(FeatherIcons.barChart2, size: 26),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.settings, size: 26),
            activeIcon: Icon(FeatherIcons.settings, size: 26),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

