import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ExploreScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const ExploreScreen({super.key, this.onNavigateTab});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Gender Filter: 0 = All Athletes, 1 = Men Focus, 2 = Women Focus
  int _selectedGenderIndex = 0;

  // Selected Goal Filter: 'all', 'mass', 'shred', 'sculpt', 'strength'
  String _selectedGoal = 'all';

  // Search query
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Goals List
  final List<Map<String, dynamic>> _goals = [
    {'id': 'all', 'title': 'All Goals'},
    {'id': 'mass', 'title': 'Hypertrophy'},
    {'id': 'shred', 'title': 'Fat Loss'},
    {'id': 'sculpt', 'title': 'Toning & Shape'},
    {'id': 'strength', 'title': 'Max Strength'},
  ];

  // Comprehensive Programs Database
  final List<Map<String, dynamic>> _programs = [
    // 1. MEN - Mass
    {
      'id': 'pro_mass_hypertrophy',
      'title': 'Pro Mass & Chest Blueprint',
      'subtitle': 'Heavy barbell & dumbbell volume for extreme upper-body mass & chest density',
      'gender': 'men',
      'genderLabel': 'Men Focus 👨',
      'goal': 'mass',
      'goalLabel': 'Hypertrophy',
      'coach': 'Coach Bilal',
      'coachRole': 'Elite Strength Director',
      'coachAvatar': 'assets/images/user_avatar.jpg',
      'rating': '4.9',
      'reviews': '3.4k',
      'duration': '8 Weeks',
      'frequency': '5 Days / Wk',
      'level': 'Advanced',
      'levelColor': Color(0xFFFF5252),
      'calories': '580 kcal',
      'image': 'assets/images/workout_back.jpg',
      'tags': ['Chest Overload', 'Lats Width', 'Heavy Barbell'],
      'description':
          'Engineered for maximum hypertrophic stimulus. Combines heavy mechanical tension compound lifts with high-metabolic pump finishers.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Heavy Chest & Triceps Blitz',
          'focus': 'Pectorals Major & Lateral Tricep',
          'exercises': [
            {'name': 'Barbell Flat Bench Press', 'sets': '4 Sets × 8 Reps', 'target': 'Mid/Lower Chest', 'image': 'assets/images/workout_back.jpg'},
            {'name': 'Incline Dumbbell Press', 'sets': '4 Sets × 10 Reps', 'target': 'Upper Clavicular Head', 'image': 'assets/images/onboarding_athlete.jpg'},
            {'name': 'Cable Crossover Fly', 'sets': '3 Sets × 15 Reps', 'target': 'Inner Pec Squeeze', 'image': 'assets/images/card_gym_full.png'},
            {'name': 'Tricep Rope Pushdown', 'sets': '4 Sets × 12 Reps', 'target': 'Lateral Tricep Head', 'image': 'assets/images/male_fitness_banner.jpg'},
          ]
        },
        {
          'dayNumber': '2',
          'dayTitle': 'Wide Back & V-Taper Lats',
          'focus': 'Lats, Rhomboids & Biceps',
          'exercises': [
            {'name': 'Wide-Grip Weighted Pull Ups', 'sets': '4 Sets × Max Reps', 'target': 'Latissimus Dorsi', 'image': 'assets/images/pullup_figure.jpg'},
            {'name': 'Seated Lat Pulldown', 'sets': '4 Sets × 10 Reps', 'target': 'Upper Lat Width', 'image': 'assets/images/pullup_figure.jpg'},
            {'name': 'Standing Dumbbell Curl', 'sets': '4 Sets × 12 Reps', 'target': 'Biceps Brachii', 'image': 'assets/images/splash_athlete.jpg'},
          ]
        },
        {
          'dayNumber': '3',
          'dayTitle': 'Rest & Recovery',
          'focus': 'Hydration, Protein & Sleep',
          'exercises': []
        },
        {
          'dayNumber': '4',
          'dayTitle': 'Quad & Glute Demolition',
          'focus': 'Squat Overload',
          'exercises': [
            {'name': 'Barbell Back Squat', 'sets': '4 Sets × 8-10 Reps', 'target': 'Quads & Glutes', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': '45-Degree Leg Press', 'sets': '4 Sets × 12 Reps', 'target': 'Leg Thickness', 'image': 'assets/images/female_fitness_banner.jpg'},
          ]
        },
        {
          'dayNumber': '5',
          'dayTitle': '3D Boulder Shoulders & Abs',
          'focus': 'Front, Side & Rear Delts',
          'exercises': [
            {'name': 'Overhead Barbell Military Press', 'sets': '4 Sets × 10 Reps', 'target': 'Deltoid Complex', 'image': 'assets/images/male_fitness_banner.jpg'},
            {'name': 'Dumbbell Lateral Raise', 'sets': '4 Sets × 15 Reps', 'target': 'Side Delts', 'image': 'assets/images/male_fitness_banner.jpg'},
          ]
        },
      ]
    },

    // 2. WOMEN - Sculpt & Glutes
    {
      'id': 'women_hourglass_glutes',
      'title': 'Hourglass, Glutes & Waist Sculpt',
      'subtitle': 'Targeted glute growth, slim waist cinching & aesthetic posture alignment',
      'gender': 'women',
      'genderLabel': 'Women Focus 👩',
      'goal': 'sculpt',
      'goalLabel': 'Glutes & Waist',
      'coach': 'Sarah Jenkins',
      'coachRole': 'Physique & Glute Specialist',
      'coachAvatar': 'assets/images/user_avatar.jpg',
      'rating': '5.0',
      'reviews': '2.6k',
      'duration': '6 Weeks',
      'frequency': '4 Days / Wk',
      'level': 'All Levels',
      'levelColor': Color(0xFFE91E63),
      'calories': '460 kcal',
      'image': 'assets/images/female_fitness_banner.jpg',
      'tags': ['Glute Max', 'Waist Cinch', 'Firm Legs'],
      'description':
          'Designed to isolate and lift glutes, shape the upper hip shelf, and trim waistline with zero unnecessary bulk in unwanted areas.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Glute Isolation & Hip Drive',
          'focus': 'Glute Max & Upper Shelf Growth',
          'exercises': [
            {'name': 'Barbell Hip Thrust', 'sets': '4 Sets × 12-15 Reps', 'target': 'Gluteus Maximus Focus', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': 'Bulgarian Split Squat', 'sets': '3 Sets × 12 Reps', 'target': 'Single Leg Glute Depth', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': 'Romanian Deadlift', 'sets': '4 Sets × 12 Reps', 'target': 'Hamstrings & Glute Tie-In', 'image': 'assets/images/workout_back.jpg'},
          ]
        },
        {
          'dayNumber': '2',
          'dayTitle': 'Upper Body Tone & Core Cinch',
          'focus': 'Sculpted Back & Flat Stomach',
          'exercises': [
            {'name': 'Lat Pulldown', 'sets': '4 Sets × 12 Reps', 'target': 'V-Taper Waist Definition', 'image': 'assets/images/pullup_figure.jpg'},
            {'name': 'Dumbbell Lateral Raise', 'sets': '3 Sets × 15 Reps', 'target': 'Shoulder Tone', 'image': 'assets/images/male_fitness_banner.jpg'},
            {'name': 'Plank Core Stabilization', 'sets': '3 Sets × 45 Sec', 'target': 'Deep Transverse Abs', 'image': 'assets/images/posture_dark_3d.jpg'},
          ]
        },
        {
          'dayNumber': '3',
          'dayTitle': 'Active Rest & Recovery',
          'focus': 'Mobility, Walking & Hydration',
          'exercises': []
        },
        {
          'dayNumber': '4',
          'dayTitle': 'Glute Pump & Hamstring Burn',
          'focus': 'Posterior Chain Hypertrophy',
          'exercises': [
            {'name': 'Sumo Squat with Dumbbell', 'sets': '4 Sets × 12 Reps', 'target': 'Inner Thighs & Glutes', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': 'Cable Kickbacks', 'sets': '3 Sets × 15 Reps', 'target': 'Glute Isolation', 'image': 'assets/images/card_gym_full.png'},
          ]
        },
      ]
    },

    // 3. MEN - V-Taper Shred
    {
      'id': 'men_v_taper_shred',
      'title': 'V-Taper Shred & Capped Arms',
      'subtitle': 'High-density supersets to carve broad shoulders, sharp lats & striated arms',
      'gender': 'men',
      'genderLabel': 'Men Focus 👨',
      'goal': 'shred',
      'goalLabel': 'Shred & Cut',
      'coach': 'Marcus Cole',
      'coachRole': 'Conditioning Master Coach',
      'coachAvatar': 'assets/images/user_avatar.jpg',
      'rating': '4.9',
      'reviews': '1.9k',
      'duration': '6 Weeks',
      'frequency': '4 Days / Wk',
      'level': 'Intermediate',
      'levelColor': Color(0xFFFF9100),
      'calories': '530 kcal',
      'image': 'assets/images/male_fitness_banner.jpg',
      'tags': ['V-Taper', 'Arm Hypertrophy', 'Shoulders'],
      'description':
          'Designed to burn visceral fat while carving an aesthetic V-taper physique with boulder deltoids and vascular arm definition.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Shoulders & Arms Blitz',
          'focus': 'Deltoids & Biceps/Triceps Supersets',
          'exercises': [
            {'name': 'Overhead Barbell Press', 'sets': '4 Sets × 10 Reps', 'target': 'Front & Mid Delts', 'image': 'assets/images/male_fitness_banner.jpg'},
            {'name': 'Dumbbell Lateral Raise', 'sets': '4 Sets × 15 Reps', 'target': 'Side Delts', 'image': 'assets/images/male_fitness_banner.jpg'},
            {'name': 'Incline Dumbbell Curl', 'sets': '4 Sets × 12 Reps', 'target': 'Bicep Peak', 'image': 'assets/images/splash_athlete.jpg'},
            {'name': 'Tricep Rope Pushdown', 'sets': '4 Sets × 15 Reps', 'target': 'Triceps Cut', 'image': 'assets/images/male_fitness_banner.jpg'},
          ]
        },
        {
          'dayNumber': '2',
          'dayTitle': 'Back Width & Lower Abs',
          'focus': 'Lats & V-Line',
          'exercises': [
            {'name': 'Wide-Grip Lat Pulldown', 'sets': '4 Sets × 12 Reps', 'target': 'Lats', 'image': 'assets/images/pullup_figure.jpg'},
            {'name': 'Hanging Knee Raise', 'sets': '4 Sets × 20 Reps', 'target': 'Lower Abs', 'image': 'assets/images/posture_dark_3d.jpg'},
          ]
        },
      ]
    },

    // 4. ALL ATHLETES - Fat Loss & Metabolic Cut
    {
      'id': 'all_metabolic_cut',
      'title': 'High-Intensity Calorie Blitz',
      'subtitle': 'Full body metabolic supersets to incinerate fat while preserving lean muscle',
      'gender': 'all',
      'genderLabel': 'All Athletes ⚡',
      'goal': 'shred',
      'goalLabel': 'Fat Loss',
      'coach': 'Coach Bilal',
      'coachRole': 'Lead Performance Coach',
      'coachAvatar': 'assets/images/user_avatar.jpg',
      'rating': '4.9',
      'reviews': '4.2k',
      'duration': '6 Weeks',
      'frequency': '5 Days / Wk',
      'level': 'Intermediate',
      'levelColor': Color(0xFFFF5252),
      'calories': '650 kcal',
      'image': 'assets/images/card_gym_full.png',
      'tags': ['High Calorie', 'Full Body Burn', 'Lean Cut'],
      'description':
          'Combines compound strength lifts with short rest intervals and cardio supersets to maximize post-exercise oxygen consumption (EPOC).',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Full Body Torso Shred',
          'focus': 'Chest, Core & Cardio Blitz',
          'exercises': [
            {'name': 'Incline Dumbbell Press', 'sets': '4 Sets × 12 Reps', 'target': 'Upper Chest', 'image': 'assets/images/onboarding_athlete.jpg'},
            {'name': 'Hanging Leg Raise', 'sets': '4 Sets × 15 Reps', 'target': 'Lower Abs', 'image': 'assets/images/posture_dark_3d.jpg'},
            {'name': 'Cable Chest Fly', 'sets': '3 Sets × 15 Reps', 'target': 'Pecs', 'image': 'assets/images/workout_back.jpg'},
          ]
        },
      ]
    },

    // 5. WOMEN - Toned Legs & Pilates Core
    {
      'id': 'women_toned_legs_core',
      'title': 'Toned Legs, Abs & Posture Flow',
      'subtitle': 'Sculpt long, lean muscle lines in legs with deep abdominal transverse bracing',
      'gender': 'women',
      'genderLabel': 'Women Focus 👩',
      'goal': 'sculpt',
      'goalLabel': 'Tone & Shape',
      'coach': 'Elena Rostova',
      'coachRole': 'Mobility & Tone Specialist',
      'coachAvatar': 'assets/images/user_avatar.jpg',
      'rating': '4.9',
      'reviews': '1.8k',
      'duration': '4 Weeks',
      'frequency': '3 Days / Wk',
      'level': 'Beginner',
      'levelColor': Color(0xFF00BFA5),
      'calories': '400 kcal',
      'image': 'assets/images/onboarding_athlete.jpg',
      'tags': ['Inner Thighs', 'Flat Stomach', 'Posture'],
      'description':
          'Targeted resistance movements that elongate and tone leg muscles without adding bulky muscle volume, paired with posture correction.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Leg Definition & Inner Thighs',
          'focus': 'Hamstrings & Adductors',
          'exercises': [
            {'name': 'Bulgarian Split Squat', 'sets': '3 Sets × 12 Reps', 'target': 'Glute & Quads', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': 'Romanian Deadlift', 'sets': '3 Sets × 12 Reps', 'target': 'Hamstrings', 'image': 'assets/images/workout_back.jpg'},
          ]
        },
      ]
    },

    // 6. ALL ATHLETES - Pure Strength
    {
      'id': 'pure_strength_foundations',
      'title': 'Powerlifting & Heavy Compound Strength',
      'subtitle': 'Develop massive compound numbers in squat, bench press & deadlift',
      'gender': 'all',
      'genderLabel': 'All Athletes ⚡',
      'goal': 'strength',
      'goalLabel': 'Max Strength',
      'coach': 'Coach Bilal',
      'coachRole': 'Powerlifting Specialist',
      'coachAvatar': 'assets/images/user_avatar.jpg',
      'rating': '5.0',
      'reviews': '2.3k',
      'duration': '8 Weeks',
      'frequency': '4 Days / Wk',
      'level': 'Advanced',
      'levelColor': Color(0xFF2979FF),
      'calories': '600 kcal',
      'image': 'assets/images/pullup_figure.jpg',
      'tags': ['Squat & Bench', 'Pure Power', 'Strength Waves'],
      'description':
          'Linear and undulating periodization targeting explosive neural recruitment, tendon strength, and personal best PRs in the big three lifts.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Heavy Bench & Pressing Mechanics',
          'focus': 'Max Upper Kinetic Force',
          'exercises': [
            {'name': 'Barbell Flat Bench Press', 'sets': '5 Sets × 5 Reps', 'target': 'Chest Strength', 'image': 'assets/images/workout_back.jpg'},
            {'name': 'Overhead Shoulder Press', 'sets': '4 Sets × 6 Reps', 'target': 'Deltoids', 'image': 'assets/images/male_fitness_banner.jpg'},
          ]
        },
      ]
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered Programs
  List<Map<String, dynamic>> get _filteredPrograms {
    return _programs.where((p) {
      // 1. Gender Filter
      if (_selectedGenderIndex == 1) {
        if (p['gender'] != 'men' && p['gender'] != 'all') return false;
      } else if (_selectedGenderIndex == 2) {
        if (p['gender'] != 'women' && p['gender'] != 'all') return false;
      }

      // 2. Goal Filter
      if (_selectedGoal != 'all' && p['goal'] != _selectedGoal) {
        return false;
      }

      // 3. Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final title = p['title'].toString().toLowerCase();
        final subtitle = p['subtitle'].toString().toLowerCase();
        final coach = p['coach'].toString().toLowerCase();
        if (!title.contains(q) && !subtitle.contains(q) && !coach.contains(q)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Open Program Schedule Modal
  void _openProgramDetails(Map<String, dynamic> program) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProgramDetailModal(
        program: program,
        onActivateProgram: () {
          Navigator.pop(context);
          widget.onNavigateTab?.call(2); // Jump to central Workout tab
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF131519),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.primary, width: 1.2),
              ),
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${program['title']} activated in your Workout Hub!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            // 1. Sleek Modern Header
            _buildHeader(),

            const SizedBox(height: 12),

            // 2. Search Bar with glass border
            _buildSearchBar(),

            const SizedBox(height: 12),

            // 3. Gender Segmented Switcher (All / Men / Women)
            _buildGenderSegmentedBar(),

            const SizedBox(height: 12),

            // 4. Goal Filter Chips
            _buildGoalFilterChips(),

            const SizedBox(height: 16),

            // 5. Section Header & Dynamic Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedGenderIndex == 1
                        ? 'Men Blueprint Routines'
                        : _selectedGenderIndex == 2
                            ? 'Women Sculpt Routines'
                            : 'All Training Blueprints',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF131519),
                      letterSpacing: -0.4,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_filteredPrograms.length} Programs',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A4E5A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 6. Immersive High-End Program Cards
            if (_filteredPrograms.isEmpty)
              Container(
                margin: const EdgeInsets.all(40),
                alignment: Alignment.center,
                child: const Text(
                  'No programs match your filter.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              )
            else
              ..._filteredPrograms.map((prog) => _buildUltraModernCard(prog)),
          ],
        ),
      ),
    );
  }

  // --- 1. Top Header ---
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Training Blueprints',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF131519),
                letterSpacing: -0.6,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Curated multi-week routines calibrated for your goals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF757A86),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. Clean Minimal Search Bar ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EBF0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: const TextStyle(fontSize: 13, color: Color(0xFF131519)),
          decoration: InputDecoration(
            hintText: 'Search by routine, muscle, or coach...',
            hintStyle: const TextStyle(color: Color(0xFF9EA3AE), fontSize: 12.5),
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9EA3AE), size: 19),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  // --- 3. Gender Segmented Switcher ---
  Widget _buildGenderSegmentedBar() {
    final items = [
      {'title': 'All Athletes ⚡', 'idx': 0},
      {'title': 'Men Focus 👨', 'idx': 1},
      {'title': 'Women Focus 👩', 'idx': 2},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EBF0)),
      ),
      child: Row(
        children: items.map((item) {
          final isSelected = _selectedGenderIndex == item['idx'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGenderIndex = item['idx'] as int;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF131519) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF676E7D),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- 4. Goal Filter Chips (Clean Typography, No Clutter Icons) ---
  Widget _buildGoalFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _goals.length,
        itemBuilder: (context, index) {
          final goal = _goals[index];
          final isSelected = _selectedGoal == goal['id'];

          return GestureDetector(
            onTap: () => setState(() => _selectedGoal = goal['id']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFE8EBF0),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  goal['title'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF4A4E5A),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 5. Ultra-Modern Cinematic Card ---
  Widget _buildUltraModernCard(Map<String, dynamic> prog) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 255,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1),
        image: DecorationImage(
          image: AssetImage(prog['image']),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: () => _openProgramDetails(prog),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.94),
                ],
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top floating badges: Gender on Left, Level & Rating on Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Gender Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        prog['genderLabel'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Level & Rating Pill
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (prog['levelColor'] as Color).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            (prog['level'] as String).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 13),
                              const SizedBox(width: 3),
                              Text(
                                '${prog['rating']} (${prog['reviews']})',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Bottom Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Goal Category Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        (prog['goalLabel'] as String).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Program Title
                    Text(
                      prog['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Coach Info Row with Avatar
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 9,
                          backgroundImage: AssetImage(prog['coachAvatar']),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${prog['coach']} • ${prog['coachRole']}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Stats & Action Button Row
                    Row(
                      children: [
                        _buildGlassPill(Icons.date_range_rounded, prog['duration']),
                        const SizedBox(width: 6),
                        _buildGlassPill(Icons.repeat_rounded, prog['frequency']),
                        const SizedBox(width: 6),
                        _buildGlassPill(Icons.local_fire_department_rounded, prog['calories']),
                        const Spacer(),

                        // High-End Start Action Button
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Split',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 11),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MODAL: Program Details & Day Schedule Modal
// ============================================================================
class _ProgramDetailModal extends StatefulWidget {
  final Map<String, dynamic> program;
  final VoidCallback onActivateProgram;

  const _ProgramDetailModal({
    required this.program,
    required this.onActivateProgram,
  });

  @override
  State<_ProgramDetailModal> createState() => _ProgramDetailModalState();
}

class _ProgramDetailModalState extends State<_ProgramDetailModal> {
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final schedule = (widget.program['schedule'] as List? ?? []);
    final currentDay = schedule.isNotEmpty ? schedule[_selectedDayIndex] : null;
    final exercises = (currentDay?['exercises'] as List? ?? []);

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E5EA),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              children: [
                // Hero Banner
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        widget.program['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.program['genderLabel'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  widget.program['title'],
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF131519),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: AssetImage(widget.program['coachAvatar']),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Created by ${widget.program['coach']} (${widget.program['coachRole']})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF676E7D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Overview
                Text(
                  widget.program['description'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF525763),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),

                // Specs Grid Row
                Row(
                  children: [
                    _buildSpecTile(Icons.timer_outlined, 'Duration', widget.program['duration']),
                    const SizedBox(width: 8),
                    _buildSpecTile(Icons.calendar_today_rounded, 'Split', widget.program['frequency']),
                    const SizedBox(width: 8),
                    _buildSpecTile(Icons.local_fire_department_rounded, 'Burn', widget.program['calories']),
                  ],
                ),

                const SizedBox(height: 22),
                const Divider(height: 1, color: Color(0xFFEDF0F4)),
                const SizedBox(height: 18),

                // Day Selector Tabs
                const Text(
                  'Weekly Workout Schedule',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF131519),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: schedule.length,
                    itemBuilder: (context, idx) {
                      final isSelected = _selectedDayIndex == idx;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF131519) : const Color(0xFFF4F6F8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'Day ${idx + 1}',
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF33373F),
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Active Day Focus Box
                if (currentDay != null) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentDay['dayTitle'] ?? '',
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentDay['focus'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF676E7D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (exercises.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(28),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.bedtime_rounded, size: 40, color: Color(0xFF90A4AE)),
                          SizedBox(height: 10),
                          Text(
                            'Active Rest & Recovery Day',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Hydrate, hit your protein goals, and let muscle fibers repair.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF676E7D), fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                  // Exercises list
                  ...exercises.map((ex) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE9ECF0)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              ex['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13.5,
                                    color: Color(0xFF131519),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  ex['target'],
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  ex['sets'],
                                  style: const TextStyle(
                                    color: Color(0xFF676E7D),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 24),

                // Activate Button
                ElevatedButton.icon(
                  onPressed: widget.onActivateProgram,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.flash_on_rounded, size: 20),
                  label: const Text(
                    'Activate Routine & Start Workout',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
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

  Widget _buildSpecTile(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9ECF0)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Color(0xFF757A86), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF131519)),
            ),
          ],
        ),
      ),
    );
  }
}
