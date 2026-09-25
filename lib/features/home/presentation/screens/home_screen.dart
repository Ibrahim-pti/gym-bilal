import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/community/presentation/screens/community_screen.dart';
import 'package:gym_base/features/community/presentation/screens/reels_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Daily Activity Tracker State
  double _waterLiters = 1.8;
  final double _waterTarget = 2.5;

  final int _caloriesBurned = 580;
  final int _caloriesTarget = 800;

  final int _stepsCount = 7240;
  final int _stepsTarget = 10000;

  void _addWater(double amount) {
    setState(() {
      _waterLiters = ((_waterLiters + amount) * 10).round() / 10;
      if (_waterLiters > 5.0) _waterLiters = 5.0;
    });
  }

  // Weekly Streak State
  int _selectedStreakDay = 4; // Friday is selected (today)
  final List<Map<String, dynamic>> _weekDays = [
    {'day': 'M', 'date': '21', 'status': 'done'},
    {'day': 'T', 'date': '22', 'status': 'done'},
    {'day': 'W', 'date': '23', 'status': 'done'},
    {'day': 'T', 'date': '24', 'status': 'done'},
    {'day': 'F', 'date': '25', 'status': 'today'},
    {'day': 'S', 'date': '26', 'status': 'upcoming'},
    {'day': 'S', 'date': '27', 'status': 'rest'},
  ];

  // Today's Routine Checklist State
  final List<Map<String, dynamic>> _todayExercises = [
    {
      'title': 'Incline Dumbbell Press',
      'setsReps': '4 Sets × 10 Reps',
      'weight': '28 kg',
      'done': true,
    },
    {
      'title': 'Barbell Flat Bench Press',
      'setsReps': '4 Sets × 8 Reps',
      'weight': '85 kg',
      'done': true,
    },
    {
      'title': 'Cable Pec Flyes (Low-to-High)',
      'setsReps': '3 Sets × 12 Reps',
      'weight': '15 kg',
      'done': false,
    },
    {
      'title': 'Triceps Overhead Rope Push',
      'setsReps': '3 Sets × 15 Reps',
      'weight': '22 kg',
      'done': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. Header: Avatar + User Info + Pro Badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Profile Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(
                          'assets/images/user_avatar.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // User Name & Subtitle
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aryan Rathore',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Stronger Every Day 💪',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Reels & Feed Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CommunityScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.video_collection_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Reels',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Pro Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7EB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFFD494),
                          width: 1.2,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Pro',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFC76B00),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text('👑', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Headline with orange underline brush
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'One Step Closer To',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Stack(
                      children: [
                        const Text(
                          'Your Goal',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.lightTextPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        // Hand-drawn orange underline curve
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 3.5,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Featured Card: Full Body Workout (Compact & Sleek)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 156,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B1C1E), Color(0xFF141517)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Right Image with glowing orange back muscles
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: 145,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'assets/images/workout_back.jpg',
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                              // Smooth left gradient blend to dark card bg
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF1B1C1E),
                                      Colors.transparent,
                                    ],
                                    stops: [0.0, 0.55],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Card Content
                      Padding(
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Workout Badge + See All Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Workout',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.onNavigateTab?.call(2);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'See All',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 11,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),

                            // Card Title with Orange Highlight
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Full Body\n',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      height: 1.1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Workout',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3),

                            // Subtitle description
                            Text(
                              'Build Strength & Challenge Muscle.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 9.5,
                                height: 1.15,
                              ),
                            ),
                            const Spacer(),

                            // Row: Time & Start Workout Button
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 11.5,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  '30 Min',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    widget.onNavigateTab?.call(2);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 11,
                                      vertical: 5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 13,
                                  ),
                                  label: const Text(
                                    'Start Workout',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Carousel Dots under Featured Card
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ==========================================
              // Daily Activity Rings Section ⚡ (Water, Calories, Steps)
              // ==========================================
              _buildDailyActivitySection(),

              const SizedBox(height: 16),

              // 3 Quick Action Cards: Gym Workouts, Nutrition & Calories, Progress & Analytics
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Card 1: Gym Workouts
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onNavigateTab?.call(2),
                        child: Image.asset(
                          'assets/images/card_gym_full.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Card 2: Nutrition & Calories
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onNavigateTab?.call(3),
                        child: Image.asset(
                          'assets/images/card_nutrition_full.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Card 3: Progress & Analytics
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onNavigateTab?.call(4),
                        child: Image.asset(
                          'assets/images/card_progress_full.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ==========================================
              // Trending Reels & Feed Spotlight 🎬
              // ==========================================
              _buildTrendingReelsSection(),

              const SizedBox(height: 16),

              // ==========================================
              // 1. Weekly Momentum Streak Strip 🔥
              // ==========================================
              _buildWeeklyStreakSection(),

              const SizedBox(height: 16),

              // ==========================================
              // 2. Today's Target Routine & Checklist 🏋️‍♂️
              // ==========================================
              _buildTodayRoutineSection(),

              const SizedBox(height: 16),

              // ==========================================
              // 3. Daily Fuel & Macros Breakdown 🥗
              // ==========================================
              _buildMacrosSection(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // SECTION: Daily Activity Progress Rings (Water, Calories, Steps) ⚡
  // ----------------------------------------------------
  Widget _buildDailyActivitySection() {
    final waterPercent = (_waterLiters / _waterTarget).clamp(0.0, 1.0);
    final caloriePercent = (_caloriesBurned / _caloriesTarget).clamp(0.0, 1.0);
    final stepsPercent = (_stepsCount / _stepsTarget).clamp(0.0, 1.0);
    final overallPercent =
        (((waterPercent + caloriePercent + stepsPercent) / 3) * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Daily Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 6),
              const Text('⚡', style: TextStyle(fontSize: 16)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$overallPercent% Done',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Circular Metric Cards Row
          Row(
            children: [
              // 1. Water Intake Card
              Expanded(
                child: _buildMetricCard(
                  title: 'Water',
                  icon: Icons.water_drop_rounded,
                  iconColor: const Color(0xFF0284C7),
                  iconBg: const Color(0xFFE0F2FE),
                  image3d: 'assets/images/icon_water_3d.jpg',
                  ringColor: const Color(0xFF0284C7),
                  ringBgColor: const Color(0xFFE0F2FE),
                  valueDisplay: _waterLiters.toStringAsFixed(1),
                  unit: 'L',
                  targetText: '$_waterTarget L',
                  percent: waterPercent,
                  showAddButton: true,
                  onAdd: () {
                    _addWater(0.25);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '💧 Added 250ml water! Total: ${_waterLiters.toStringAsFixed(1)} / $_waterTarget L',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        duration: const Duration(milliseconds: 1400),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF0284C7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),

              // 2. Calories Card
              Expanded(
                child: _buildMetricCard(
                  title: 'Calories',
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFFF5722),
                  iconBg: const Color(0xFFFFEBE6),
                  image3d: 'assets/images/icon_fire_3d.jpg',
                  ringColor: const Color(0xFFFF5722),
                  ringBgColor: const Color(0xFFFFEBE6),
                  valueDisplay: '$_caloriesBurned',
                  unit: 'kcal',
                  targetText: '$_caloriesTarget kcal',
                  percent: caloriePercent,
                  onTap: () => widget.onNavigateTab?.call(3),
                ),
              ),
              const SizedBox(width: 10),

              // 3. Steps Card
              Expanded(
                child: _buildMetricCard(
                  title: 'Steps',
                  icon: Icons.directions_walk_rounded,
                  iconColor: const Color(0xFF10B981),
                  iconBg: const Color(0xFFD1FAE5),
                  image3d: 'assets/images/icon_sneaker_3d.jpg',
                  ringColor: const Color(0xFF10B981),
                  ringBgColor: const Color(0xFFD1FAE5),
                  valueDisplay: _stepsCount >= 1000
                      ? '${(_stepsCount / 1000).toStringAsFixed(1)}k'
                      : '$_stepsCount',
                  unit: 'steps',
                  targetText: '${(_stepsTarget / 1000).toInt()}k steps',
                  percent: stepsPercent,
                  onTap: () => widget.onNavigateTab?.call(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String image3d,
    required Color ringColor,
    required Color ringBgColor,
    required String valueDisplay,
    required String unit,
    required String targetText,
    required double percent,
    bool showAddButton = false,
    VoidCallback? onAdd,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Row: Category icon & title + optional '+' button
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 11.5, color: iconColor),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showAddButton)
                  GestureDetector(
                    onTap: onAdd,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 12,
                        color: iconColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Circular Progress Indicator with 3D Icon inside
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 5.0,
                      strokeCap: StrokeCap.round,
                      backgroundColor: ringBgColor,
                      valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                    ),
                  ),
                  // 3D Icon inside circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: ringColor.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(image3d, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Number and Unit
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  valueDisplay,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Percentage Done Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: ringBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${(percent * 100).toInt()}% Done',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: ringColor,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Target Text
            Text(
              'Goal: $targetText',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // SECTION 1: Weekly Momentum & Streak Strip 🔥
  // ----------------------------------------------------
  Widget _buildWeeklyStreakSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Column(
          children: [
            // Top Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Momentum',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          '5-Day Streak Active 🔥',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Sep 21 - 27',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 7 Days Interactive Pills
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_weekDays.length, (index) {
                final dayData = _weekDays[index];
                final isSelected = _selectedStreakDay == index;
                final isToday = dayData['status'] == 'today';
                final isDone = dayData['status'] == 'done';
                final isRest = dayData['status'] == 'rest';

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStreakDay = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDone
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : Colors.grey.shade50),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isToday
                                  ? AppColors.primary
                                  : (isDone
                                        ? AppColors.primary.withValues(
                                            alpha: 0.25,
                                          )
                                        : Colors.grey.shade200)),
                        width: isToday || isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          dayData['day'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.85)
                                : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayData['date'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (isDone)
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 11,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          )
                        else if (isToday)
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '🔥',
                                style: TextStyle(fontSize: 8.5),
                              ),
                            ),
                          )
                        else if (isRest)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),

            // Motivation Banner Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '5 of 6 workouts completed this week. Keep it up!',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '83%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // SECTION 2: Today's Target Routine & Checklist 🏋️‍♂️
  // ----------------------------------------------------
  Widget _buildTodayRoutineSection() {
    final completedCount = _todayExercises
        .where((e) => e['done'] == true)
        .length;
    final progress = (_todayExercises.isEmpty)
        ? 0.0
        : (completedCount / _todayExercises.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    "Today's Routine",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightTextPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('🏋️‍♂️', style: TextStyle(fontSize: 16)),
                ],
              ),
              GestureDetector(
                onTap: () => widget.onNavigateTab?.call(2),
                child: const Row(
                  children: [
                    Text(
                      'All Workouts',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dark Luxury Interactive Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B1C1E), Color(0xFF141517)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.fitness_center_rounded,
                            size: 11,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'CHEST & TRICEPS FOCUS',
                            style: TextStyle(
                              color: Color(0xFFFFB038),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '⏱️ 45 Min • 340 kcal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Routine Title
                const Text(
                  'Push Power & Hypertrophy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Build strength with high tension & strict form.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 14),

                // Interactive Exercise Checklist
                Column(
                  children: List.generate(_todayExercises.length, (idx) {
                    final item = _todayExercises[idx];
                    final isDone = item['done'] as bool;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          item['done'] = !isDone;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: isDone
                              ? const Color(0xFF10B981).withValues(alpha: 0.12)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDone
                                ? const Color(0xFF10B981)
                                      .withValues(alpha: 0.35)
                                : Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Custom Animated Checkbox
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: isDone
                                    ? const Color(0xFF10B981)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: isDone
                                      ? const Color(0xFF10B981)
                                      : Colors.white.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: isDone
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),

                            // Exercise Name & Sets
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      color: isDone
                                          ? Colors.white.withValues(alpha: 0.5)
                                          : Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['setsReps'] as String,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Weight Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['weight'] as String,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 12),

                // Footer: Progress Bar + Action Button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$completedCount of ${_todayExercises.length} Completed',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Color(0xFF34D399),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.12,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    ElevatedButton.icon(
                      onPressed: () => widget.onNavigateTab?.call(2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 16),
                      label: const Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // SECTION 3: Daily Fuel & Macros Breakdown 🥗
  // ----------------------------------------------------
  Widget _buildMacrosSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'Daily Fuel & Macros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightTextPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('🥗', style: TextStyle(fontSize: 16)),
                ],
              ),
              GestureDetector(
                onTap: () => widget.onNavigateTab?.call(3),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 13,
                        color: Color(0xFF059669),
                      ),
                      SizedBox(width: 3),
                      Text(
                        'Log Food',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Macros Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100, width: 1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // 1. Protein
                    Expanded(
                      child: _buildMacroItem(
                        name: 'Protein',
                        current: 124,
                        target: 160,
                        unit: 'g',
                        percent: 0.78,
                        color: const Color(0xFF10B981),
                        icon: Icons.fitness_center_rounded,
                        subtext: 'Repair',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 70,
                      color: Colors.grey.shade200,
                    ),

                    // 2. Carbs
                    Expanded(
                      child: _buildMacroItem(
                        name: 'Carbs',
                        current: 185,
                        target: 240,
                        unit: 'g',
                        percent: 0.77,
                        color: const Color(0xFFF59E0B),
                        icon: Icons.bolt_rounded,
                        subtext: 'Energy',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 70,
                      color: Colors.grey.shade200,
                    ),

                    // 3. Fats
                    Expanded(
                      child: _buildMacroItem(
                        name: 'Fats',
                        current: 48,
                        target: 65,
                        unit: 'g',
                        percent: 0.74,
                        color: const Color(0xFFEC4899),
                        icon: Icons.opacity_rounded,
                        subtext: 'Hormones',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: Colors.grey.shade100),
                const SizedBox(height: 10),

                // Bottom Calorie Remaining Strip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '480 kcal ',
                                style: TextStyle(
                                  color: AppColors.lightTextPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(
                                text: 'remaining today',
                                style: TextStyle(
                                  color: AppColors.lightTextSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => widget.onNavigateTab?.call(3),
                      child: const Row(
                        children: [
                          Text(
                            'Calorie Details',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 9.5,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem({
    required String name,
    required int current,
    required int target,
    required String unit,
    required double percent,
    required Color color,
    required IconData icon,
    required String subtext,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$current',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                TextSpan(
                  text: ' /$target$unit',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              minHeight: 4.5,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percent * 100).toInt()}% • $subtext',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingReelsSection() {
    final sampleReels = [
      {
        'id': 'reel_1',
        'title': 'Heavy Barbell Deadlift PR 240kg Form Check',
        'author': 'Coach Bilal',
        'avatar': 'assets/images/user_avatar.jpg',
        'videoThumbnail': 'assets/images/workout_back.jpg',
        'duration': '0:34',
        'views': '48.2k',
        'likes': 3840,
        'comments': 248,
        'audioTrack': 'Gym Phonk High Voltage • 160 BPM',
        'exerciseTag': 'Barbell Deadlift',
        'caption':
            'Clean lockout, tight core, lats packed tight before pulling. Always focus on driving feet through the platform! 💪🔥',
      },
      {
        'id': 'reel_2',
        'title': 'Upper Pec Clavicular Squeeze • Incline Dumbbell Press',
        'author': 'Alex Hunter',
        'avatar': 'assets/images/male_fitness_banner.jpg',
        'videoThumbnail': 'assets/images/card_gym_full.png',
        'duration': '0:42',
        'views': '31.5k',
        'likes': 2890,
        'comments': 112,
        'audioTrack': 'Heavy Bass Workout Mix • DJ Hype',
        'exerciseTag': 'Incline Dumbbell Press',
        'caption':
            'Set bench to 30 degrees. Keep elbows tucked at 45-60 degrees for chest activation! 🔥',
      },
      {
        'id': 'reel_3',
        'title': 'Wide-Grip Pull-Up V-Taper Mastery',
        'author': 'Maya Stone',
        'avatar': 'assets/images/female_fitness_banner.jpg',
        'videoThumbnail': 'assets/images/pullup_figure.jpg',
        'duration': '0:28',
        'views': '54.1k',
        'likes': 4210,
        'comments': 310,
        'audioTrack': 'Deep Focus Instrumental • Beats',
        'exerciseTag': 'Wide-Grip Pull Up',
        'caption':
            'Engage hollow body, pull chest to bar, pause 1s at top! ⚡🧗‍♀️',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'Trending Reels & Feed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightTextPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('🎬', style: TextStyle(fontSize: 16)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CommunityScreen()),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'Explore All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sampleReels.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final reel = sampleReels[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReelsViewerScreen(
                          reels: sampleReels,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 115,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: AssetImage(reel['videoThumbnail'] as String),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                Text(
                                  reel['duration'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 8,
                          bottom: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                reel['author'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                reel['views'] as String,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 8.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
