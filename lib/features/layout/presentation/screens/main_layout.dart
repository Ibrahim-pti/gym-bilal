import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/explore/presentation/screens/explore_screen.dart';
import 'package:gym_base/features/home/presentation/screens/home_screen.dart';
import 'package:gym_base/features/workout/presentation/screens/workout_screen.dart';
import 'package:gym_base/features/calorie/presentation/screens/calorie_screen.dart';
import 'package:gym_base/features/profile/presentation/screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onNavigateTab: _onTabSelected),
      ExploreScreen(onNavigateTab: _onTabSelected),
      const WorkoutScreen(),
      const CalorieScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          // Current Page
          IndexedStack(index: _currentIndex, children: pages),

          // Floating Bottom Navigation Bar (Matching Screen 3)
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 1. Home
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'Home',
                  ),

                  // 2. Programs / کۆرسەکان
                  _buildNavItem(
                    index: 1,
                    icon: Icons.layers_rounded,
                    label: 'Programs',
                  ),

                  // 3. Center Elevated Workout Button
                  GestureDetector(
                    onTap: () => _onTabSelected(2),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),

                  // 4. Calories
                  _buildNavItem(
                    index: 3,
                    icon: Icons.pie_chart_outline_rounded,
                    label: 'Calorie',
                  ),

                  // 5. Profile
                  _buildNavItem(
                    index: 4,
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
