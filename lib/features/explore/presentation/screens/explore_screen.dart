import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // 0: All, 1: Men, 2: Women
  int _selectedGenderIndex = 0;

  // Selected Muscle Category ('all', 'chest', 'back', 'legs', 'arms', 'core', 'full')
  String _selectedMuscleCategory = 'all';

  // Selected Goal ('all', 'build', 'fatloss', 'strength', 'toning')
  String _selectedGoal = 'all';

  // Search Query
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Muscle Groups / Body Part Categories
  final List<Map<String, dynamic>> _muscleCategories = [
    {
      'id': 'all',
      'name': 'All Parts',
      'kurdish': 'هەموو بەشەکان',
      'icon': Icons.grid_view_rounded,
      'image': 'assets/images/card_gym_full.png',
      'count': 18,
    },
    {
      'id': 'legs',
      'name': 'Legs & Glutes',
      'kurdish': 'قاچ و سمت',
      'icon': Icons.directions_run_rounded,
      'image': 'assets/images/female_fitness_banner.jpg',
      'count': 6,
    },
    {
      'id': 'chest',
      'name': 'Chest & Pecs',
      'kurdish': 'سنگ و پێشەوە',
      'icon': Icons.fitness_center_rounded,
      'image': 'assets/images/workout_back.jpg',
      'count': 4,
    },
    {
      'id': 'back',
      'name': 'Back & Lats',
      'kurdish': 'پشت و باڵەکان',
      'icon': Icons.accessibility_new_rounded,
      'image': 'assets/images/pullup_figure.jpg',
      'count': 4,
    },
    {
      'id': 'arms',
      'name': 'Shoulders & Arms',
      'kurdish': 'شان و بازوو',
      'icon': Icons.sports_gymnastics_rounded,
      'image': 'assets/images/male_fitness_banner.jpg',
      'count': 5,
    },
    {
      'id': 'core',
      'name': 'Core & Waist',
      'kurdish': 'سک و کەمەر',
      'icon': Icons.shield_rounded,
      'image': 'assets/images/posture_dark_3d.jpg',
      'count': 4,
    },
  ];

  // Fitness Goals List
  final List<Map<String, dynamic>> _goals = [
    {'id': 'all', 'name': 'All Goals', 'kurdish': 'هەموو ئامانجەکان', 'icon': '🎯'},
    {'id': 'toning', 'name': 'Toning & Shape', 'kurdish': 'ڕێکی و تەڕحی لەش', 'icon': '✨'},
    {'id': 'build', 'name': 'Muscle Mass', 'kurdish': 'زیادکردنی ماسولکە', 'icon': '💪'},
    {'id': 'fatloss', 'name': 'Fat Loss', 'kurdish': 'چەوری سووتاندن', 'icon': '🔥'},
    {'id': 'strength', 'name': 'Pure Strength', 'kurdish': 'هێزی جەستەیی', 'icon': '⚡'},
  ];

  // Exercises Database
  final List<Map<String, dynamic>> _exercises = [
    // LEGS & GLUTES (Popular for Women & Men)
    {
      'id': 'hip_thrust',
      'name': 'Barbell Hip Thrust',
      'kurdish': 'هیپ ترەست بە باربێڵ',
      'muscleCategory': 'legs',
      'muscleTag': 'Glutes & Hamstrings',
      'gender': 'women', // Highly favored for women
      'genderDisplay': 'Women Focus 👩',
      'goal': 'toning',
      'difficulty': 'Intermediate',
      'equipment': 'Barbell & Bench',
      'setsReps': '4 Sets × 12-15 Reps',
      'image': 'assets/images/female_fitness_banner.jpg',
      'calories': '180 kcal',
      'description': 'The ultimate movement to isolate, tone, and build powerful glute muscle fibers.',
      'instructions': [
        'Place upper back on the bench, feet flat on the floor shoulder-width apart.',
        'Drive through your heels to raise hips until thighs and torso align horizontally.',
        'Squeeze glutes hard at the top lockout for 2 seconds.',
        'Lower hips under strict control without touching the floor.',
      ],
      'mistakes': 'Hyperextending lower spine or pushing through toes.',
      'proTip': 'Keep your chin tucked forward toward your chest throughout the lift.',
    },
    {
      'id': 'bulgarian_split_squat',
      'name': 'Bulgarian Split Squat',
      'kurdish': 'بولگاریان سکوات بە دەمبڵ',
      'muscleCategory': 'legs',
      'muscleTag': 'Quads, Glutes & Balance',
      'gender': 'all',
      'genderDisplay': 'Men & Women ⚡',
      'goal': 'toning',
      'difficulty': 'Intermediate',
      'equipment': 'Dumbbells & Bench',
      'setsReps': '3 Sets × 10 Reps / Leg',
      'image': 'assets/images/female_fitness_banner.jpg',
      'calories': '210 kcal',
      'description': 'Unilateral powerhouse exercise to tone legs and build symmetry.',
      'instructions': [
        'Rest one rear foot on the bench behind you, front foot planted 2-3 feet ahead.',
        'Descend until rear knee touches near the floor, front thigh parallel.',
        'Drive through front heel back to starting stance.',
      ],
      'mistakes': 'Front knee collapsing inwards or leaning excessively forward.',
      'proTip': 'Lean slightly forward at the hips to place max tension on the glutes.',
    },
    {
      'id': 'romanian_deadlift',
      'name': 'Dumbbell Romanian Deadlift',
      'kurdish': 'ڕۆمانیان دێدلیفت بۆ پشت و قاچ',
      'muscleCategory': 'legs',
      'muscleTag': 'Hamstrings & Glute Fold',
      'gender': 'all',
      'genderDisplay': 'Men & Women ⚡',
      'goal': 'toning',
      'difficulty': 'Beginner',
      'equipment': 'Dumbbells',
      'setsReps': '4 Sets × 12 Reps',
      'image': 'assets/images/female_fitness_banner.jpg',
      'calories': '160 kcal',
      'description': 'Tones the back of thighs, lifts glutes, and strengthens posterior chain.',
      'instructions': [
        'Hold dumbbells in front of thighs, feet hip-width with slight knee bend.',
        'Hinge hips back while keeping spine perfectly neutral.',
        'Lower weights along shins until you feel deep stretch in hamstrings.',
        'Engage glutes to push hips forward to return.',
      ],
      'mistakes': 'Rounding lower back or squatting down with knees.',
      'proTip': 'Imagine trying to touch a wall behind you with your glutes.',
    },
    {
      'id': 'barbell_back_squat',
      'name': 'Heavy Barbell Squat',
      'kurdish': 'سکواتی قورس بە باربێڵ',
      'muscleCategory': 'legs',
      'muscleTag': 'Quads & Leg Power',
      'gender': 'men',
      'genderDisplay': 'Men Focus 👨',
      'goal': 'build',
      'difficulty': 'Advanced',
      'equipment': 'Barbell & Squat Rack',
      'setsReps': '4 Sets × 8 Reps',
      'image': 'assets/images/workout_back.jpg',
      'calories': '250 kcal',
      'description': 'The king of all leg movements for maximum quad thickness and raw strength.',
      'instructions': [
        'Rack barbell across upper traps, brace core with deep diaphragmatic breath.',
        'Descend by breaking at hips and knees until hips break parallel.',
        'Drive forcefully through mid-foot to stand up.',
      ],
      'mistakes': 'Heels lifting off ground or knees caving inward.',
      'proTip': 'Squeeze lats into the bar to create unbreakable spinal rigidity.',
    },

    // CHEST & PECS
    {
      'id': 'incline_db_press',
      'name': 'Incline Dumbbell Press',
      'kurdish': 'سنگی سەرەوە بە دەمبڵ',
      'muscleCategory': 'chest',
      'muscleTag': 'Upper Pectorals',
      'gender': 'men',
      'genderDisplay': 'Men Focus 👨',
      'goal': 'build',
      'difficulty': 'Intermediate',
      'equipment': 'Incline Bench & Dumbbells',
      'setsReps': '4 Sets × 10 Reps',
      'image': 'assets/images/male_fitness_banner.jpg',
      'calories': '190 kcal',
      'description': 'Target the upper chest collarbone fibers for full 3D chest development.',
      'instructions': [
        'Set bench to 30° angle. Press dumbbells straight up over upper chest.',
        'Lower slowly over 3 seconds until you feel a deep pec stretch.',
        'Contract chest to press weights upward without banging dumbbells.',
      ],
      'mistakes': 'Setting bench too high (causes front shoulder takeover).',
      'proTip': 'Retract shoulder blades back and down before pressing.',
    },
    {
      'id': 'flat_bench_press',
      'name': 'Barbell Flat Bench Press',
      'kurdish': 'سنگی خوارەوە بە باربێڵ',
      'muscleCategory': 'chest',
      'muscleTag': 'Mid & Lower Pectorals',
      'gender': 'men',
      'genderDisplay': 'Men Focus 👨',
      'goal': 'strength',
      'difficulty': 'Intermediate',
      'equipment': 'Barbell & Bench',
      'setsReps': '4 Sets × 8 Reps',
      'image': 'assets/images/workout_back.jpg',
      'calories': '220 kcal',
      'description': 'The benchmark for pushing strength and chest hypertrophy.',
      'instructions': [
        'Lie flat, grip bar slightly wider than shoulder width.',
        'Lower bar with control to lower chest nipple line.',
        'Drive bar upward explosively locking out elbows.',
      ],
      'mistakes': 'Flaring elbows out to 90 degrees.',
      'proTip': 'Tuck elbows at 45 degrees to protect rotator cuff tendons.',
    },
    {
      'id': 'cable_chest_fly',
      'name': 'High-to-Low Cable Fly',
      'kurdish': 'فڕین بە کەیبڵ بۆ سنگ',
      'muscleCategory': 'chest',
      'muscleTag': 'Lower Chest & Definition',
      'gender': 'all',
      'genderDisplay': 'Men & Women ⚡',
      'goal': 'fatloss',
      'difficulty': 'Beginner',
      'equipment': 'Cable Crossover Machine',
      'setsReps': '3 Sets × 15 Reps',
      'image': 'assets/images/card_gym_full.png',
      'calories': '130 kcal',
      'description': 'Continuous cable tension that carves sharp chest lines and inner definition.',
      'instructions': [
        'Set pulleys high, step forward with staggered stance.',
        'Bring hands forward and down in wide hugging arc.',
        'Cross hands slightly at bottom and hold squeeze for 2 seconds.',
      ],
      'mistakes': 'Bending elbows into a pressing motion.',
      'proTip': 'Maintain a slight micro-bend in elbows from start to finish.',
    },

    // BACK & LATS
    {
      'id': 'lat_pulldown',
      'name': 'Wide Grip Lat Pulldown',
      'kurdish': 'داکێشانی لات بە دەسکی پان',
      'muscleCategory': 'back',
      'muscleTag': 'Lats & V-Taper',
      'gender': 'all',
      'genderDisplay': 'Men & Women ⚡',
      'goal': 'build',
      'difficulty': 'Beginner',
      'equipment': 'Lat Pulldown Machine',
      'setsReps': '4 Sets × 10-12 Reps',
      'image': 'assets/images/pullup_figure.jpg',
      'calories': '170 kcal',
      'description': 'Builds the coveted V-taper silhouette that makes waist look slimmer.',
      'instructions': [
        'Grip wide bar, sit down with thighs secured under pads.',
        'Pull bar down to upper chest while arching upper spine slightly.',
        'Squeeze armpits down and slowly return to full lat stretch.',
      ],
      'mistakes': 'Swinging torso excessively backward.',
      'proTip': 'Think of pulling your elbows down into your back pockets.',
    },
    {
      'id': 'bent_over_row',
      'name': 'Barbell Bent Over Row',
      'kurdish': 'ڕاکێشانی باربێڵ بە دانەواندنەوە',
      'muscleCategory': 'back',
      'muscleTag': 'Mid Back, Rhomboids & Thickness',
      'gender': 'men',
      'genderDisplay': 'Men Focus 👨',
      'goal': 'strength',
      'difficulty': 'Intermediate',
      'equipment': 'Barbell',
      'setsReps': '4 Sets × 8 Reps',
      'image': 'assets/images/workout_back.jpg',
      'calories': '210 kcal',
      'description': 'Creates dense muscular back thickness and strong spinal erectors.',
      'instructions': [
        'Hinge at 45 degree angle holding barbell, core locked.',
        'Pull bar towards belly button keeping elbows close to torso.',
        'Squeeze shoulder blades together forcefully at the peak.',
      ],
      'mistakes': 'Standing upright or jerking weights with hips.',
      'proTip': 'Keep neck neutral looking 5 feet ahead on the floor.',
    },

    // SHOULDERS & ARMS
    {
      'id': 'lateral_raise',
      'name': 'Dumbbell Lateral Raise',
      'kurdish': 'شان بە دەمبڵ بۆ تەنیشت',
      'muscleCategory': 'arms',
      'muscleTag': 'Side Deltoids & Capped Shoulders',
      'gender': 'all',
      'genderDisplay': 'Men & Women ⚡',
      'goal': 'toning',
      'difficulty': 'Beginner',
      'equipment': 'Dumbbells',
      'setsReps': '4 Sets × 15 Reps',
      'image': 'assets/images/male_fitness_banner.jpg',
      'calories': '110 kcal',
      'description': 'Widens shoulders to create an athletic frame and hourglass figure.',
      'instructions': [
        'Stand tall with dumbbells by sides, palms facing inward.',
        'Raise arms out to sides leading with elbows until parallel to floor.',
        'Control the descent slowly over 2 seconds.',
      ],
      'mistakes': 'Shrugging traps or using momentum to swing.',
      'proTip': 'Tilt dumbbells slightly as if pouring water from a pitcher.',
    },
    {
      'id': 'bicep_dumbbell_curl',
      'name': 'Incline Dumbbell Bicep Curl',
      'kurdish': 'بازوو بە دەمبڵ لەسەر قەنەفە',
      'muscleCategory': 'arms',
      'muscleTag': 'Bicep Peak & Long Head',
      'gender': 'men',
      'genderDisplay': 'Men Focus 👨',
      'goal': 'build',
      'difficulty': 'Beginner',
      'equipment': 'Incline Bench & Dumbbells',
      'setsReps': '3 Sets × 12 Reps',
      'image': 'assets/images/male_fitness_banner.jpg',
      'calories': '120 kcal',
      'description': 'Unmatched bicep stretch that forces maximum peak growth.',
      'instructions': [
        'Sit on 60° incline bench, arms hanging straight down.',
        'Curl dumbbells up while supinating wrists outward at top.',
        'Lower with full control to full arm extension.',
      ],
      'mistakes': 'Swinging elbows forward during curl.',
      'proTip': 'Keep upper arms strictly perpendicular to the floor.',
    },
    {
      'id': 'tricep_rope_pushdown',
      'name': 'Cable Rope Triceps Pushdown',
      'kurdish': 'پشت بازوو بە پەتی کەیبڵ',
      'muscleCategory': 'arms',
      'muscleTag': 'Triceps Lateral & Medial Head',
      'gender': 'all',
      'genderDisplay': 'Men & Women ⚡',
      'goal': 'toning',
      'difficulty': 'Beginner',
      'equipment': 'Cable Pulley & Rope',
      'setsReps': '3 Sets × 15 Reps',
      'image': 'assets/images/male_fitness_banner.jpg',
      'calories': '115 kcal',
      'description': 'Tones and tightens back of arms, eliminating arm flab.',
      'instructions': [
        'Hold rope attachment with elbows pinned to ribs.',
        'Push rope straight down and spread ends apart at bottom.',
        'Hold contraction for 1 second then return to 90 degrees.',
      ],
      'mistakes': 'Letting elbows flare or travel forward.',
      'proTip': 'Spread the rope apart at the bottom to maximize lateral head peak.',
    },

    // CORE & ABS
    {
      'id': 'plank_reach',
      'name': 'Core Plank & Shoulder Tap',
      'kurdish': 'پلانکی توندوتۆڵ بۆ کەمەر',
      'muscleCategory': 'core',
      'muscleTag': 'Transverse Abdominis & Deep Core',
      'gender': 'all',
      'genderDisplay': 'Men & Women ⚡',
      'goal': 'toning',
      'difficulty': 'Intermediate',
      'equipment': 'Yoga Mat',
      'setsReps': '3 Sets × 45 Seconds',
      'image': 'assets/images/posture_dark_3d.jpg',
      'calories': '140 kcal',
      'description': 'Cinches waistline, tightens abdominal wall, and supports lower back posture.',
      'instructions': [
        'Hold push-up plank position with feet shoulder-width.',
        'Tap left shoulder with right hand without rocking hips.',
        'Alternate sides with steady rhythmic breathing.',
      ],
      'mistakes': 'Sagging lower hips or swiveling pelvis.',
      'proTip': 'Squeeze glutes and brace belly as if about to be punched.',
    },
    {
      'id': 'hanging_leg_raise',
      'name': 'Hanging Knee / Leg Raise',
      'kurdish': 'هەڵواسینی ئەژنۆ بۆ سکی خوارەوە',
      'muscleCategory': 'core',
      'muscleTag': 'Lower Abs & Hip Flexors',
      'gender': 'all',
      'genderDisplay': 'Men & Women ⚡',
      'goal': 'fatloss',
      'difficulty': 'Intermediate',
      'equipment': 'Pull-Up Bar',
      'setsReps': '3 Sets × 15 Reps',
      'image': 'assets/images/posture_dark_3d.jpg',
      'calories': '150 kcal',
      'description': 'Direct stimulus to flatten and define the lower abdominal V-cut.',
      'instructions': [
        'Hang from bar with overhand grip, shoulders engaged.',
        'Raise knees up towards chest curling pelvis upward.',
        'Slowly lower legs without swinging body like pendulum.',
      ],
      'mistakes': 'Kicking legs with momentum instead of abdominal curl.',
      'proTip': 'Roll your pelvis forward and up to activate lower abs, not just hips.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered Exercises Getter
  List<Map<String, dynamic>> get _filteredExercises {
    return _exercises.where((item) {
      // 1. Gender Filter
      if (_selectedGenderIndex == 1 && item['gender'] == 'women') {
        return false; // Men selected, exclude women-only
      }
      if (_selectedGenderIndex == 2 && item['gender'] == 'men') {
        return false; // Women selected, exclude men-only
      }

      // 2. Muscle Category Filter
      if (_selectedMuscleCategory != 'all' &&
          item['muscleCategory'] != _selectedMuscleCategory) {
        return false;
      }

      // 3. Goal Filter
      if (_selectedGoal != 'all' && item['goal'] != _selectedGoal) {
        return false;
      }

      // 4. Search Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final name = (item['name'] as String).toLowerCase();
        final kurdish = (item['kurdish'] as String).toLowerCase();
        final muscle = (item['muscleTag'] as String).toLowerCase();
        if (!name.contains(query) &&
            !kurdish.contains(query) &&
            !muscle.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. Page Header (Title + Subtitle)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Exercise Explorer',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Targeted workouts for every body & goal',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sports_gymnastics_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search exercises, muscles (e.g. Squat, Chest)...',
                      hintStyle: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3. Gender Segment Switcher (Men 👨 / Women 👩 / All ⚡)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      _buildGenderPill(0, 'All Athletes ⚡', 'گشت'),
                      _buildGenderPill(1, 'Men Focus 👨', 'پیاوان'),
                      _buildGenderPill(2, 'Women Focus 👩', 'ئافرەتان'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 4. Hero Gender Showcase Banner
              _buildDynamicHeroBanner(),

              const SizedBox(height: 18),

              // 5. Goals Filter Chips (ئامانجەکان)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Training Goals',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '🎯',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _goals.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    final isSel = _selectedGoal == goal['id'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGoal = goal['id'] as String;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSel ? AppColors.primary : Colors.grey.shade200,
                            width: 1,
                          ),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.28),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Text(goal['icon'] as String,
                                style: const TextStyle(fontSize: 13)),
                            const SizedBox(width: 5),
                            Text(
                              goal['name'] as String,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight:
                                    isSel ? FontWeight.w800 : FontWeight.w600,
                                color: isSel
                                    ? Colors.white
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 6. Muscle / Body Parts Visual Carousel (وێنەی بەشی شوێنی یارییەکان)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Target Muscle Areas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text('🧬', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Text(
                      '${_muscleCategories.length} Zones',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Visual Category Cards Horizontal List
              SizedBox(
                height: 124,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _muscleCategories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final cat = _muscleCategories[index];
                    final isSel = _selectedMuscleCategory == cat['id'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMuscleCategory = cat['id'] as String;
                        });
                      },
                      child: Container(
                        width: 135,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSel
                                ? AppColors.primary
                                : Colors.grey.shade200,
                            width: isSel ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSel
                                  ? AppColors.primary.withValues(alpha: 0.22)
                                  : Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Background Photo
                              Image.asset(
                                cat['image'] as String,
                                fit: BoxFit.cover,
                              ),
                              // Dark Overlay Gradient
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.85),
                                    ],
                                    stops: const [0.2, 0.95],
                                  ),
                                ),
                              ),
                              // Content
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: isSel
                                              ? AppColors.primary
                                              : Colors.black.withValues(alpha: 0.4),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          cat['icon'] as IconData,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cat['name'] as String,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w800,
                                            height: 1.1,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          cat['kurdish'] as String,
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.7),
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w500,
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
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              // 7. Exercises Header & List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Exercises & Workouts',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_filteredExercises.length}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedMuscleCategory != 'all' ||
                        _selectedGoal != 'all' ||
                        _selectedGenderIndex != 0)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGenderIndex = 0;
                            _selectedMuscleCategory = 'all';
                            _selectedGoal = 'all';
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        child: const Text(
                          'Reset Filters',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // List of Exercises
              if (_filteredExercises.isEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        const Text(
                          'No exercises match your filters',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightTextPrimary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try clearing your search or switching categories',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredExercises.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _filteredExercises[index];
                    return _buildExerciseCard(item);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Gender Switcher Pill
  Widget _buildGenderPill(int index, String label, String kurdish) {
    final isSel = _selectedGenderIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGenderIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSel ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isSel
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                  color:
                      isSel ? AppColors.lightTextPrimary : Colors.grey.shade600,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 1),
              Text(
                kurdish,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: isSel ? AppColors.primary : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dynamic Hero Banner
  Widget _buildDynamicHeroBanner() {
    String title;
    String subtitle;
    String imagePath;
    Color accentColor;

    if (_selectedGenderIndex == 2) {
      // Women
      title = "Women's Sculpt & Tone";
      subtitle = "Specialized programs for Glutes, Abs & Posture";
      imagePath = 'assets/images/female_fitness_banner.jpg';
      accentColor = const Color(0xFF10B981);
    } else if (_selectedGenderIndex == 1) {
      // Men
      title = "Men's Power & Hypertrophy";
      subtitle = "Build peak chest, thick back & arm mass";
      imagePath = 'assets/images/male_fitness_banner.jpg';
      accentColor = AppColors.primary;
    } else {
      // All
      title = "Complete Fitness Blueprint";
      subtitle = "Scientific movements calibrated for every goal";
      imagePath = 'assets/images/workout_back.jpg';
      accentColor = AppColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              // Gradient Shade
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.88),
                      Colors.black.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.6),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _selectedGenderIndex == 2
                            ? 'WOMEN ATHLETICS 👩'
                            : (_selectedGenderIndex == 1
                                ? 'MEN HYPERTROPHY 👨'
                                : 'ALL ATHLETES ⚡'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Exercise Card Item
  Widget _buildExerciseCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _showExerciseDetailSheet(context, item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 78,
                height: 78,
                child: Image.asset(
                  item['image'] as String,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Exercise Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Tags Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['muscleTag'] as String,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['genderDisplay'] as String,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Name
                  Text(
                    item['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    item['kurdish'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Sets, Reps & Difficulty
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item['setsReps'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: Colors.grey.shade400)),
                      const SizedBox(width: 8),
                      Text(
                        item['equipment'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow button
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3D Exercise Detail Bottom Sheet
  void _showExerciseDetailSheet(
      BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final instructions = List<String>.from(item['instructions'] as List);

        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
              // Drag Handle
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),

              // Sheet Content Scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Visual Banner
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 190,
                              width: double.infinity,
                              child: Image.asset(
                                item['image'] as String,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: 190,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  item['genderDisplay'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 14,
                              right: 14,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    item['kurdish'] as String,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Quick Stats Badges Row
                      Row(
                        children: [
                          _buildDetailStatPill(
                            'Target Muscle',
                            item['muscleTag'] as String,
                            Icons.accessibility_new_rounded,
                          ),
                          const SizedBox(width: 8),
                          _buildDetailStatPill(
                            'Equipment',
                            item['equipment'] as String,
                            Icons.fitness_center_rounded,
                          ),
                          const SizedBox(width: 8),
                          _buildDetailStatPill(
                            'Calories',
                            item['calories'] as String,
                            Icons.local_fire_department_rounded,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'Movement Overview',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['description'] as String,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Step-by-Step Execution Guide
                      const Text(
                        'Step-by-Step Technique (ڕێگای دروست)',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...instructions.asMap().entries.map((entry) {
                        final stepNumber = entry.key + 1;
                        final text = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$stepNumber',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.lightTextPrimary,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 14),

                      // Common Mistakes (Avoid)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFFCA5A5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('⚠️', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Common Mistake to Avoid:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: Color(0xFFB91C1C),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['mistakes'] as String,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF991B1B),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Pro Coach Tip
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF6EE7B7),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pro Coach Tip:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: Color(0xFF047857),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['proTip'] as String,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF065F46),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailStatPill(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 15, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.lightTextPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 1),
            Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
