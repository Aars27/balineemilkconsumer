import 'package:consumerbalinee/Features/ViewScreens/CartScreen/CartController.dart';
import 'package:consumerbalinee/Features/ViewScreens/DailyOrderScreen/DailyOrderScreen.dart';
import 'package:consumerbalinee/Features/ViewScreens/ProfileScreen/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Constant/app_colors.dart';
import '../ViewScreens/CartScreen/CartScreen.dart';
import '../ViewScreens/DashBoardScreen/DashboardScreeen.dart';
import '../ViewScreens/OrderHistoryScreen/OrderHistoryScreen.dart';
import 'MainNavigator.dart';

class MainWrapperScreen extends StatelessWidget {
  MainWrapperScreen({super.key});

  final List<Widget> _screens = [
    DashboardView(), // Your dashboard screen
    DailyOrderView(), // Create this screen
    ChangeNotifierProvider(
      create: (_) => CartController()..loadCartAndSummary(),
      child: const CartView(),
    ),
    OrderHistoryView(), // Create this screen
    Profilescreen(), // Create this screen
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainNavigationController(),
      child: Consumer<MainNavigationController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: controller.currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: _buildModernBottomNavBar(context, controller),
          );
        },
      ),
    );
  }

  Widget _buildModernBottomNavBar(
    BuildContext context,
    MainNavigationController controller,
  ) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.gradientEnd,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          // bottomLeft: Radius.circular(12),
          // bottomRight: Radius.circular(12)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                controller,
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
              ),
              _buildNavItem(
                context,
                controller,
                index: 1,
                icon: Icons.calendar_today_rounded,
                label: 'Daily Orders',
              ),
              _buildNavItem(
                context,
                controller,
                index: 2,
                icon: Icons.shopping_cart_rounded,
                label: 'Carts',
                showBadge: true,
                // badgeCount: 3,
              ),
              _buildNavItem(
                context,
                controller,
                index: 3,
                icon: Icons.history,
                label: 'Order',
              ),
              _buildNavItem(
                context,
                controller,
                index: 4,
                icon: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    MainNavigationController controller, {
    required int index,
    required IconData icon,
    required String label,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    final isSelected = controller.currentIndex == index;

    return GestureDetector(
      onTap: () => controller.setIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white54,
                  size: 26,
                ),
                if (showBadge && badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
