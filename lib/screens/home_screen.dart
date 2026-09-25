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
  bool _isChallengeJoined = false;

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

              const SizedBox(height: 24),

              // 2. Headline with orange underline brush
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'One Step Closer To',
                      style: TextStyle(
                        fontSize: 26,
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
                            fontSize: 28,
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
                            height: 4,
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

              const SizedBox(height: 18),

              // Featured Card: Full Body Workout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 206,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
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
                        width: 185,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(24),
                            bottomRight: Radius.circular(24),
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
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Workout Badge + See All Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Workout',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
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
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'See All',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Card Title with Orange Highlight
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Full Body\n',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      height: 1.15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Workout',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      height: 1.15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Subtitle description
                            Text(
                              'Build Strength, Boost Endurance,\nAnd Challenge Every Muscle.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 10.5,
                                height: 1.25,
                              ),
                            ),
                            const Spacer(),

                            // Row: Time & Start Workout Button
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 13,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '30 Minutes',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    widget.onNavigateTab?.call(2);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 15,
                                  ),
                                  label: const Text(
                                    'Start Workout',
                                    style: TextStyle(
                                      fontSize: 11.5,
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

              const SizedBox(height: 14),

              // Carousel Dots under Featured Card
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

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
  // SECTION 1: Gym Challenges (Soft Glassy Modern Card) 🏆
  // ----------------------------------------------------
  Widget _buildChallengesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'Gym Challenges',
                    style: TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightTextPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('🏆', style: TextStyle(fontSize: 16)),
                ],
              ),
              GestureDetector(
                onTap: () => _showLeaderboardBottomSheet(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🥇', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 4),
                      Text(
                        'Leaderboard',
                        style: TextStyle(
                          fontSize: 11.5,
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
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Glassy Modern Challenge Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF222630), Color(0xFF14171E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF14171E).withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag & Timer & Leaderboard Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Monthly Challenge',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
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
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 11,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '12 Days Left',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Title + 3D Trophy Graphic Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '30-Day Beast Mode',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Daily 100 Push-ups + 30 Mins Workout',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Athletes Joined stack
                          Row(
                            children: [
                              SizedBox(
                                width: 54,
                                height: 22,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 1.2),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/user_avatar.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 14,
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 1.2),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/workout_back.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 28,
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 1.2),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/pullup_figure.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '🔥 1.4k+ Joined',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // 3D Trophy Graphic
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.accentGold.withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGold.withValues(alpha: 0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/challenge_trophy_3d.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Bottom row: Progress + Join Button
                Row(
                  children: [
                    // Progress text pill
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Day 18 / 30',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '60%',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Join Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isChallengeJoined = !_isChallengeJoined;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: _isChallengeJoined
                                ? const Color(0xFF1E824C)
                                : Colors.grey.shade800,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: Text(
                              _isChallengeJoined
                                  ? '🎉 Awesome! You joined Beast Mode Challenge!'
                                  : 'Left challenge.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isChallengeJoined
                              ? const Color(0xFF1E3A28)
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                          border: _isChallengeJoined
                              ? Border.all(
                                  color: const Color(0xFF4CAF50), width: 1.2)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: (_isChallengeJoined
                                      ? const Color(0xFF4CAF50)
                                      : AppColors.primary)
                                  .withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isChallengeJoined
                                  ? Icons.check_circle_rounded
                                  : Icons.flash_on_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isChallengeJoined ? 'Active ✓' : 'Join Now',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
  // SECTION 2: 3D Form Correction Card (Glassy & Clean with Button) 💡
  // ----------------------------------------------------
  Widget _buildFormTipsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Row(
            children: [
              Text(
                'Exercise Posture',
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(width: 6),
              Text('💡', style: TextStyle(fontSize: 16)),
            ],
          ),

          const SizedBox(height: 12),

          // Glassy Compact 3D Form Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1F2E2B), Color(0xFF131D1B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF64FFDA).withValues(alpha: 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF64FFDA).withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left Column: Info & Action Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF00E676).withValues(alpha: 0.35),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.view_in_ar_rounded,
                              size: 12,
                              color: Color(0xFF00E676),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '3D AI Form Correction',
                              style: TextStyle(
                                color: Color(0xFF00E676),
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Card Headline
                      const Text(
                        'Master Your Form',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Real-time joint angle analysis & injury prevention guide.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 11.5,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Clean Action Button to Open Form Guide Modal
                      GestureDetector(
                        onTap: () => _showFormGuideBottomSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E676)
                                    .withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Form Guide',
                                style: TextStyle(
                                  color: Color(0xFF0A1F18),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: Color(0xFF0A1F18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Right 3D Visual with soft neon border
                Container(
                  width: 105,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF64FFDA).withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF64FFDA).withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/form_correction_3d.jpg',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                        Positioned(
                          bottom: 6,
                          left: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 0.8,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.threed_rotation_rounded,
                                  size: 11,
                                  color: Color(0xFF64FFDA),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '3D Form',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

