import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ExploreScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const ExploreScreen({super.key, this.onNavigateTab});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // 0: All Athletes, 1: Men Focus, 2: Women Focus
  int _selectedGenderIndex = 0;

  // Selected Goal Filter: 'all', 'hypertrophy', 'fatloss', 'toning', 'strength'
  String _selectedGoal = 'all';

  // Search query
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Goals List
  final List<Map<String, dynamic>> _goals = [
    {'id': 'all', 'title': 'All Goals', 'icon': Icons.tune_rounded},
    {'id': 'hypertrophy', 'title': 'Muscle Mass', 'icon': Icons.fitness_center_rounded},
    {'id': 'fatloss', 'title': 'Fat Loss', 'icon': Icons.local_fire_department_rounded},
    {'id': 'toning', 'title': 'Toning & Shape', 'icon': Icons.auto_awesome_rounded},
    {'id': 'strength', 'title': 'Pure Strength', 'icon': Icons.bolt_rounded},
  ];

  // Rich Database of Programs calibrated by Gender & Goal
  final List<Map<String, dynamic>> _programs = [
    // 1. MEN FOCUS - Muscle Mass
    {
      'id': 'pro_mass_hypertrophy',
      'title': 'Pro Mass & Chest Blueprint',
      'subtitle': 'Heavy compound overload for maximum chest, shoulders & back mass',
      'gender': 'men',
      'genderLabel': 'Men Focus 👨',
      'goal': 'hypertrophy',
      'goalLabel': 'Hypertrophy',
      'coach': 'Coach Bilal',
      'coachRole': 'Elite Strength Director',
      'rating': '4.9',
      'reviews': '3.2k',
      'duration': '8 Weeks',
      'frequency': '5 Days/Wk',
      'level': 'Advanced',
      'calories': '580 kcal',
      'image': 'assets/images/workout_back.jpg',
      'accentColor': AppColors.primary,
      'description':
          'A scientifically calibrated 5-day split engineered for rapid hypertrophy, dense upper-body mass, and progressive barbell overload.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Heavy Chest & Triceps Blitz',
          'focus': 'Pec Major & Anterior Delts',
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
          'dayTitle': 'Recovery & Mobility',
          'focus': 'Rest & Hydration',
          'exercises': []
        },
        {
          'dayNumber': '4',
          'dayTitle': 'Quad & Hamstring Power',
          'focus': 'Squat Overload',
          'exercises': [
            {'name': 'Barbell Back Squat', 'sets': '4 Sets × 8-10 Reps', 'target': 'Quads & Glutes', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': '45-Degree Leg Press', 'sets': '4 Sets × 12 Reps', 'target': 'Leg Thickness', 'image': 'assets/images/female_fitness_banner.jpg'},
          ]
        },
        {
          'dayNumber': '5',
          'dayTitle': 'Boulder Shoulders & Core',
          'focus': '3D Delts & Abs',
          'exercises': [
            {'name': 'Overhead Barbell Military Press', 'sets': '4 Sets × 10 Reps', 'target': 'Deltoid Complex', 'image': 'assets/images/male_fitness_banner.jpg'},
            {'name': 'Dumbbell Lateral Raise', 'sets': '4 Sets × 15 Reps', 'target': 'Side Delts', 'image': 'assets/images/male_fitness_banner.jpg'},
          ]
        },
      ]
    },

    // 2. WOMEN FOCUS - Toning & Glutes
    {
      'id': 'women_hourglass_glutes',
      'title': 'Hourglass, Glutes & Waist Sculpt',
      'subtitle': 'Targeted glute isolation, slim waist cinching & aesthetic curves',
      'gender': 'women',
      'genderLabel': 'Women Focus 👩',
      'goal': 'toning',
      'goalLabel': 'Toning & Shape',
      'coach': 'Sarah Jenkins',
      'coachRole': 'Physique & Glute Specialist',
      'rating': '5.0',
      'reviews': '2.4k',
      'duration': '6 Weeks',
      'frequency': '4 Days/Wk',
      'level': 'All Levels',
      'calories': '450 kcal',
      'image': 'assets/images/female_fitness_banner.jpg',
      'accentColor': const Color(0xFFFF4081),
      'description':
          'Specifically programmed to lift, tone, and grow glutes while maintaining a tight, athletic waistline and defined posture.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Glute Isolation & Hip Drive',
          'focus': 'Glute Max & Upper Shelf',
          'exercises': [
            {'name': 'Barbell Hip Thrust', 'sets': '4 Sets × 12-15 Reps', 'target': 'Gluteus Maximus', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': 'Bulgarian Split Squat', 'sets': '3 Sets × 12 Reps', 'target': 'Glute & Quads', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': 'Romanian Deadlift', 'sets': '4 Sets × 12 Reps', 'target': 'Hamstrings & Glutes', 'image': 'assets/images/workout_back.jpg'},
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
          'focus': 'Mobility & Stretching',
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

    // 3. MEN FOCUS - Shred & V-Taper
    {
      'id': 'men_v_taper_shred',
      'title': 'V-Taper Shred & Arm Definition',
      'subtitle': 'High-density supersets to carve broad shoulders, sharp lats & arms',
      'gender': 'men',
      'genderLabel': 'Men Focus 👨',
      'goal': 'fatloss',
      'goalLabel': 'Fat Loss',
      'coach': 'Marcus Vance',
      'coachRole': 'Conditioning Coach',
      'rating': '4.8',
      'reviews': '1.8k',
      'duration': '6 Weeks',
      'frequency': '4 Days/Wk',
      'level': 'Intermediate',
      'calories': '520 kcal',
      'image': 'assets/images/male_fitness_banner.jpg',
      'accentColor': const Color(0xFFFF6D00),
      'description':
          'Designed to melt body fat while chiseling an athletic aesthetic V-taper frame with capped deltoids and striated arms.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Shoulders & Arms Gunsmith',
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
      'title': 'High-Intensity Shred & Cut',
      'subtitle': 'Rapid fat reduction with heavy lifting & metabolic circuits',
      'gender': 'all',
      'genderLabel': 'All Athletes ⚡',
      'goal': 'fatloss',
      'goalLabel': 'Fat Loss',
      'coach': 'Coach Bilal',
      'coachRole': 'Lead Head Coach',
      'rating': '4.9',
      'reviews': '4.1k',
      'duration': '6 Weeks',
      'frequency': '5 Days/Wk',
      'level': 'Intermediate',
      'calories': '650 kcal',
      'image': 'assets/images/card_gym_full.png',
      'accentColor': const Color(0xFFFF3D00),
      'description':
          'High work capacity training combining compound resistance lifts with metabolic burners to strip body fat down fast.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Full Body Torso Shred',
          'focus': 'Chest, Core & High Calorie',
          'exercises': [
            {'name': 'Incline Dumbbell Press', 'sets': '4 Sets × 12 Reps', 'target': 'Upper Chest', 'image': 'assets/images/onboarding_athlete.jpg'},
            {'name': 'Hanging Leg Raise', 'sets': '4 Sets × 15 Reps', 'target': 'Lower Abs', 'image': 'assets/images/posture_dark_3d.jpg'},
            {'name': 'Cable Chest Fly', 'sets': '3 Sets × 15 Reps', 'target': 'Pecs', 'image': 'assets/images/workout_back.jpg'},
          ]
        },
        {
          'dayNumber': '2',
          'dayTitle': 'Legs & Caloric Blitz',
          'focus': 'Quads & Heart Rate Peak',
          'exercises': [
            {'name': 'Barbell Squat', 'sets': '4 Sets × 12 Reps', 'target': 'Quads', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': 'Leg Press', 'sets': '4 Sets × 15 Reps', 'target': 'Legs', 'image': 'assets/images/female_fitness_banner.jpg'},
          ]
        },
      ]
    },

    // 5. WOMEN FOCUS - Tone & Lean Legs
    {
      'id': 'women_lean_legs_pilates',
      'title': 'Toned Legs, Core & Posture',
      'subtitle': 'Firm inner thighs, calves, and strong lower back alignment',
      'gender': 'women',
      'genderLabel': 'Women Focus 👩',
      'goal': 'toning',
      'goalLabel': 'Toning & Shape',
      'coach': 'Elena Rostova',
      'coachRole': 'Mobility & Tone Coach',
      'rating': '4.9',
      'reviews': '1.5k',
      'duration': '4 Weeks',
      'frequency': '3 Days/Wk',
      'level': 'Beginner',
      'calories': '380 kcal',
      'image': 'assets/images/onboarding_athlete.jpg',
      'accentColor': const Color(0xFF9C27B0),
      'description':
          'Low-impact, high-frequency sculpting targeting long, lean leg muscles, posture symmetry, and a tight waist.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Lower Body Firm & Lift',
          'focus': 'Hamstrings & Glute Medius',
          'exercises': [
            {'name': 'Bulgarian Split Squat', 'sets': '3 Sets × 12 Reps', 'target': 'Glute & Quads', 'image': 'assets/images/female_fitness_banner.jpg'},
            {'name': 'Romanian Deadlift', 'sets': '3 Sets × 12 Reps', 'target': 'Hamstrings', 'image': 'assets/images/workout_back.jpg'},
          ]
        },
      ]
    },

    // 6. ALL ATHLETES - Strength
    {
      'id': 'pure_strength_foundations',
      'title': 'Powerlifting & Raw Strength',
      'subtitle': 'Develop massive compound numbers in squat, bench & deadlift',
      'gender': 'all',
      'genderLabel': 'All Athletes ⚡',
      'goal': 'strength',
      'goalLabel': 'Pure Strength',
      'coach': 'Coach Bilal',
      'coachRole': 'Powerlifting Specialist',
      'rating': '5.0',
      'reviews': '2.1k',
      'duration': '8 Weeks',
      'frequency': '4 Days/Wk',
      'level': 'Advanced',
      'calories': '600 kcal',
      'image': 'assets/images/pullup_figure.jpg',
      'accentColor': const Color(0xFF2979FF),
      'description':
          'Built on periodized strength waves. Lift heavier, build bone density, and unlock your absolute maximum kinetic output.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Heavy Bench & Pressing Mechanics',
          'focus': 'Max Upper Force',
          'exercises': [
            {'name': 'Barbell Flat Bench Press', 'sets': '5 Sets × 5 Reps', 'target': 'Chest Strength', 'image': 'assets/images/workout_back.jpg'},
            {'name': 'Overhead Shoulder Press', 'sets': '4 Sets × 6 Reps', 'target': 'Shoulders', 'image': 'assets/images/male_fitness_banner.jpg'},
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

  // Filtered Programs list by Gender, Goal, and Search
  List<Map<String, dynamic>> get _filteredPrograms {
    return _programs.where((p) {
      // 1. Gender Filter
      if (_selectedGenderIndex == 1) {
        // Men Focus selected
        if (p['gender'] != 'men' && p['gender'] != 'all') return false;
      } else if (_selectedGenderIndex == 2) {
        // Women Focus selected
        if (p['gender'] != 'women' && p['gender'] != 'all') return false;
      }

      // 2. Goal Filter
      if (_selectedGoal != 'all' && p['goal'] != _selectedGoal) {
        return false;
      }

      // 3. Search Query
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
                      '${program['title']} is now active in your Workout Hub!',
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
            const SizedBox(height: 12),

            // 1. Header (Title, Subtitle & Active Shortcut)
            _buildHeader(),

            const SizedBox(height: 14),

            // 2. Search Bar
            _buildSearchBar(),

            const SizedBox(height: 14),

            // 3. THE GENDER TOGGLE (All Athletes / Men Focus / Women Focus)
            _buildGenderSegmentedControl(),

            const SizedBox(height: 14),

            // 4. Horizontal Goal Filter Chips
            _buildGoalFilterChips(),

            const SizedBox(height: 18),

            // 5. Section Counter
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
                            : 'All Workout Blueprints',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF131519),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    '${_filteredPrograms.length} Programs',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 6. Immersive Full-Bleed Program Cards
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
              ..._filteredPrograms.map((prog) => _buildImmersiveCard(prog)),
          ],
        ),
      ),
    );
  }

  // --- 1. Top Header ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Training Blueprints',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF131519),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Targeted workout routines by certified coaches',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF757A86),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => widget.onNavigateTab?.call(2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flash_on_rounded, color: Colors.white, size: 15),
                  SizedBox(width: 4),
                  Text(
                    'Workout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  // --- 2. Minimalist Search Bar ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
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
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF131519)),
          decoration: InputDecoration(
            hintText: 'Search by routine, muscle, or coach...',
            hintStyle: const TextStyle(color: Color(0xFF9EA3AE), fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9EA3AE), size: 20),
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
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }

  // --- 3. GENDER SEGMENTED CONTROL (All Athletes / Men Focus / Women Focus) ---
  Widget _buildGenderSegmentedControl() {
    final segments = [
      {'title': 'All Athletes ⚡', 'index': 0},
      {'title': 'Men Focus 👨', 'index': 1},
      {'title': 'Women Focus 👩', 'index': 2},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EBF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: segments.map((seg) {
          final isSelected = _selectedGenderIndex == seg['index'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGenderIndex = seg['index'] as int;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF131519) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    seg['title'] as String,
                    style: TextStyle(
                      fontSize: 12,
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

  // --- 4. Goal Filter Chips ---
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFE8EBF0),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    goal['icon'] as IconData,
                    size: 13,
                    color: isSelected ? Colors.white : const Color(0xFF757A86),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    goal['title'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF33373F),
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
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

  // --- 5. Immersive Full-Bleed Cinematic Card ---
  Widget _buildImmersiveCard(Map<String, dynamic> prog) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
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
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.88),
                ],
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Badges Row
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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${prog['rating']} (${prog['reviews']})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bottom Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Goal Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (prog['goalLabel'] as String).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      prog['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Coach
                    Text(
                      'By ${prog['coach']} • ${prog['coachRole']}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Specs & Action Pill
                    Row(
                      children: [
                        _buildGlassPill(Icons.date_range_rounded, prog['duration']),
                        const SizedBox(width: 6),
                        _buildGlassPill(Icons.repeat_rounded, prog['frequency']),
                        const SizedBox(width: 6),
                        _buildGlassPill(Icons.local_fire_department_rounded, prog['calories']),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF131519),
                            size: 16,
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
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
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
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MODAL: High-End Program Details & Day-by-Day Schedule (100% English)
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
                Text(
                  'Created by ${widget.program['coach']} (${widget.program['coachRole']})',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF676E7D),
                    fontWeight: FontWeight.w500,
                  ),
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
