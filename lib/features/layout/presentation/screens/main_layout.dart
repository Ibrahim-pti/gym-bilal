import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/explore/presentation/screens/explore_screen.dart';
import 'package:gym_base/features/home/presentation/screens/home_screen.dart';
import 'package:gym_base/features/workout/presentation/screens/workout_screen.dart';
import 'package:gym_base/features/community/presentation/screens/community_screen.dart';
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
      const CommunityScreen(),
      const CalorieScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          // Current Active Page
          IndexedStack(index: _currentIndex, children: pages),

          // Glassmorphic Floating Bottom Navigation Bar
          Positioned(
            left: 12,
            right: 12,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.85),
                        Colors.white.withValues(alpha: 0.65),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 28,
                        spreadRadius: 0,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        blurRadius: 16,
                        spreadRadius: -2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 1. Home
                      _buildNavItem(
                        index: 0,
                        icon: Icons.home_rounded,
                        label: 'Home',
                      ),

                      // 2. Programs
                      _buildNavItem(
                        index: 1,
                        icon: Icons.layers_rounded,
                        label: 'Programs',
                      ),

                      // 3. Workout
                      _buildNavItem(
                        index: 2,
                        icon: Icons.fitness_center_rounded,
                        label: 'Workout',
                      ),

                      // 4. Reels
                      _buildNavItem(
                        index: 3,
                        icon: Icons.movie_filter_rounded,
                        label: 'Reels',
                      ),

                      // 5. Calorie
                      _buildNavItem(
                        index: 4,
                        icon: Icons.pie_chart_outline_rounded,
                        label: 'Calorie',
                      ),

                      // 6. Profile
                      _buildNavItem(
                        index: 5,
                        icon: Icons.person_outline_rounded,
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
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

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: isSelected
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.grey.shade500,
                size: isSelected ? 21.5 : 20,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.grey.shade600,
                  fontSize: 9.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
