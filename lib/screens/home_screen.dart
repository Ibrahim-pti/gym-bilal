import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Form Tips state
  int _selectedFormIndex = 0;

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

  final List<Map<String, dynamic>> _formGuides = [
    {
      'name': 'Barbell Squat',
      'muscle': 'Quads, Glutes & Core',
      'icon': Icons.accessibility_new_rounded,
      'image': 'assets/images/form_correction_3d.jpg',
      'analysisBadge': '3D Form Analysis 🔬',
      'angles': 'Knee Angle: 90° • Spine: Neutral',
      'dos': [
        'Keep spine neutral and chest lifted high',
        'Knees track outward in line with toes',
        'Keep feet planted flat and drive through heels',
      ],
      'donts': [
        'Rounding the lower back (spinal disc risk)',
        'Knees caving inwards when driving up',
        'Lifting heels off the ground at full depth',
      ],
      'proTip': 'Master full depth control with lightweight before adding heavy load.',
    },
    {
      'name': 'Deadlift',
      'muscle': 'Hamstrings, Glutes & Back',
      'icon': Icons.fitness_center_rounded,
      'image': 'assets/images/form_correction_3d.jpg',
      'analysisBadge': '3D Posture Check 🔬',
      'angles': 'Hip Hinge: 45° • Bar Path: Vertical',
      'dos': [
        'Keep barbell close to shins throughout the lift',
        'Align neck, shoulders and spine in straight line',
        'Drive through the floor with your leg power',
      ],
      'donts': [
        'Hunching or rounding the upper/lower spine',
        'Jerking the bar with arms instead of hip drive',
        'Over-extending and arching lower back at lockout',
      ],
      'proTip': 'Lock your lats tight and brace your core with a deep belly breath.',
    },
    {
      'name': 'Bench Press',
      'muscle': 'Pectorals, Triceps & Shoulders',
      'icon': Icons.sports_gymnastics_rounded,
      'image': 'assets/images/form_correction_3d.jpg',
      'analysisBadge': '3D Angle Sensor 🔬',
      'angles': 'Elbow Tuck: 45° • Scapula: Retracted',
      'dos': [
        'Plant feet firmly into the floor for leg drive',
        'Retract scapulae back and down to protect shoulders',
        'Lower bar with control to lower chest line',
      ],
      'donts': [
        'Bouncing the bar violently off the rib cage',
        'Flaring elbows out at 90° (causes shoulder pain)',
        'Lifting hips and glutes off the bench',
      ],
      'proTip': 'Tuck your elbows at a 45° to 60° angle to save your shoulder joints.',
    },
  ];

  final List<Map<String, dynamic>> _leaderboard = [
    {
      'name': 'Soran Fitness',
      'score': '3,450 XP',
      'streak': '🔥 28 Days Streak',
      'rank': 1,
      'medal': '🥇',
      'avatar': 'assets/images/user_avatar.jpg',
    },
    {
      'name': 'Alan Athlete',
      'score': '3,120 XP',
      'streak': '🔥 25 Days Streak',
      'rank': 2,
      'medal': '🥈',
      'avatar': 'assets/images/workout_back.jpg',
    },
    {
      'name': 'Diyar Kurd',
      'score': '2,980 XP',
      'streak': '🔥 22 Days Streak',
      'rank': 3,
      'medal': '🥉',
      'avatar': 'assets/images/pullup_figure.jpg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140),
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
                        backgroundImage:
                            AssetImage('assets/images/user_avatar.jpg'),
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
                          Text(
                            '👑',
                            style: TextStyle(fontSize: 12),
                          ),
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
                                      color: Colors.white.withValues(alpha: 0.12),
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

              const SizedBox(height: 28),

              // ==========================================
              // 1. Gym Challenges & Leaderboard Section 🏆
              // ==========================================
              _buildChallengesSection(),

              const SizedBox(height: 28),

              // ==========================================
              // 2. Form Tips: Do's & Don'ts Section 💡
              // ==========================================
              _buildFormTipsSection(),
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
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.2,
          ),
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
                  child: Icon(
                    icon,
                    size: 11.5,
                    color: iconColor,
                  ),
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
                      child: Image.asset(
                        image3d,
                        fit: BoxFit.cover,
                      ),
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
  // SECTION 1: Gym Challenges (Dark Luxury Banner Style) 🏆
  // ----------------------------------------------------
  Widget _buildChallengesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Gym Challenges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 6),
              const Text('🏆', style: TextStyle(fontSize: 16)),
              const Spacer(),
              GestureDetector(
                onTap: () => _showLeaderboardBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB800).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Leaderboard',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFC76B00),
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 9.5,
                        color: Color(0xFFC76B00),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dark Luxury Banner Card matching Top Banner
          GestureDetector(
            onTap: () => _showLeaderboardBottomSheet(context),
            child: Container(
              height: 156,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B1C1E), Color(0xFF141517)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Right Image with glowing victory trophy & smooth dark blend
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
                            'assets/images/challenge_trophy_3d.jpg',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
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
                        // Tag Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB800).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFFB800).withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🔥', style: TextStyle(fontSize: 10)),
                              SizedBox(width: 4),
                              Text(
                                'MONTHLY CHALLENGE',
                                style: TextStyle(
                                  color: Color(0xFFFFB800),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),

                        // Title
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '30-Day\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              TextSpan(
                                text: 'Beast Mode',
                                style: TextStyle(
                                  color: Color(0xFFFFB800),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Subtitle
                        Text(
                          '100 push-ups daily • 1.4k members',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 9.5,
                            height: 1.15,
                          ),
                        ),
                        const Spacer(),

                        // Button & Day tag
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _showLeaderboardBottomSheet(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9800),
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
                                Icons.emoji_events_rounded,
                                size: 13,
                              ),
                              label: const Text(
                                'View Challenge',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Day 18 / 30',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // SECTION 2: 3D Form Correction (Dark Luxury Banner Style) 💡
  // ----------------------------------------------------
  Widget _buildFormTipsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Exercise Posture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 6),
              const Text('💡', style: TextStyle(fontSize: 16)),
              const Spacer(),
              GestureDetector(
                onTap: () => _showFormGuideBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'AI Angles',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 9.5,
                        color: Color(0xFF059669),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dark Luxury Banner Card matching Top Banner
          GestureDetector(
            onTap: () => _showFormGuideBottomSheet(context),
            child: Container(
              height: 156,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B1C1E), Color(0xFF141517)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Right Image with glowing biomechanics posture & smooth dark blend
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
                            'assets/images/posture_dark_3d.jpg',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
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
                        // Tag Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF10B981).withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🔬', style: TextStyle(fontSize: 10)),
                              SizedBox(width: 4),
                              Text(
                                '3D POSTURE AI',
                                style: TextStyle(
                                  color: Color(0xFF34D399),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),

                        // Title
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Master Your\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              TextSpan(
                                text: 'Form & Angles',
                                style: TextStyle(
                                  color: Color(0xFF34D399),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Subtitle
                        Text(
                          'Prevent injury with 3D joint sensors.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 9.5,
                            height: 1.15,
                          ),
                        ),
                        const Spacer(),

                        // Button
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _showFormGuideBottomSheet(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
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
                                Icons.camera_alt_rounded,
                                size: 13,
                              ),
                              label: const Text(
                                'Check Form & Tips',
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
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // MODAL 1: Form Guide Bottom Sheet (On-demand details) 💡
  // ----------------------------------------------------
  void _showFormGuideBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final guide = _formGuides[_selectedFormIndex];
            final dos = List<String>.from(guide['dos'] as List);
            final donts = List<String>.from(guide['donts'] as List);

            return Container(
              height: MediaQuery.of(context).size.height * 0.84,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Drag handle
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3D Exercise Form Guide',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Accurate posture & injury prevention tips',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),

                  // Exercise Selector Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(_formGuides.length, (idx) {
                        final isSel = _selectedFormIndex == idx;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                _selectedFormIndex = idx;
                              });
                              setState(() {
                                _selectedFormIndex = idx;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color:
                                    isSel ? AppColors.primary : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSel
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _formGuides[idx]['icon'] as IconData,
                                    size: 14,
                                    color:
                                        isSel ? Colors.white : Colors.black87,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _formGuides[idx]['name'] as String,
                                    style: TextStyle(
                                      color:
                                          isSel ? Colors.white : Colors.black87,
                                      fontSize: 12,
                                      fontWeight: isSel
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Scrollable Details
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 3D Image Banner with Badges
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: const Color(0xFF1E2024),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    guide['image'] as String,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        guide['analysisBadge'] as String,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1B5E20),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        guide['angles'] as String,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Correct Form (DO)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F8F4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF81C784)
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 15,
                                      color: Color(0xFF2E7D32),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'CORRECT FORM (DO ✔️)',
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ...dos.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '• $item',
                                        style: const TextStyle(
                                          color: Color(0xFF1B5E20),
                                          fontSize: 11.5,
                                          height: 1.3,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Common Mistakes (DONT)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF2F2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE57373)
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.cancel_rounded,
                                      size: 15,
                                      color: Color(0xFFC62828),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'COMMON MISTAKES (DON\'T ❌)',
                                      style: TextStyle(
                                        color: Color(0xFFC62828),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ...donts.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '• $item',
                                        style: const TextStyle(
                                          color: Color(0xFFB71C1C),
                                          fontSize: 11.5,
                                          height: 1.3,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Pro Tip
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9E6),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFFFD54F),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb_rounded,
                                  size: 15,
                                  color: Color(0xFFF57F17),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Pro Tip: ${guide['proTip']}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF7F4F00),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ----------------------------------------------------
  // MODAL 2: Leaderboard Bottom Sheet 🏅
  // ----------------------------------------------------
  void _showLeaderboardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Weekly Leaderboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text('🎖️', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: _leaderboard.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 16, color: Colors.grey.shade100),
                  itemBuilder: (context, index) {
                    final athlete = _leaderboard[index];
                    return Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            athlete['medal'] as String,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage(athlete['avatar'] as String),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                athlete['name'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                athlete['streak'] as String,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            athlete['score'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

