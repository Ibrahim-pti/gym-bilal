import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ExploreScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const ExploreScreen({super.key, this.onNavigateTab});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Selected category filter: 'all', 'hypertrophy', 'shred', 'women', 'strength', 'beginner'
  String _selectedCategory = 'all';

  // Search query
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Categories Filter
  final List<Map<String, dynamic>> _categories = [
    {'id': 'all', 'title': 'All Programs', 'icon': Icons.flash_on_rounded},
    {'id': 'hypertrophy', 'title': 'Hypertrophy', 'icon': Icons.fitness_center_rounded},
    {'id': 'shred', 'title': 'Fat Shred', 'icon': Icons.local_fire_department_rounded},
    {'id': 'women', 'title': 'Women Sculpt', 'icon': Icons.auto_awesome_rounded},
    {'id': 'strength', 'title': 'Pure Strength', 'icon': Icons.bolt_rounded},
    {'id': 'beginner', 'title': 'Beginner 30D', 'icon': Icons.flag_rounded},
  ];

  // Programs Database (100% English)
  final List<Map<String, dynamic>> _programs = [
    {
      'id': 'hypertrophy_pro',
      'title': 'Pro Hypertrophy & Muscle Mass',
      'subtitle': 'Maximum size & density program calibrated for advanced lifters',
      'category': 'hypertrophy',
      'coach': 'Coach Bilal',
      'coachTitle': 'Head Fitness Director',
      'rating': '4.9',
      'reviews': '2.8k',
      'duration': '8 Weeks',
      'frequency': '5 Days / Wk',
      'level': 'Advanced',
      'intensity': 'High Intensity',
      'calories': '550 kcal / session',
      'image': 'assets/images/workout_back.jpg',
      'featured': true,
      'tags': ['Chest & Back', 'Heavy Barbells', 'Mass Builder'],
      'overview':
          'A scientifically structured 8-week routine focusing on progressive overload, mechanical tension, and hypertrophic volume to pack on lean muscle mass.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Chest & Triceps Power',
          'split': 'Push Day • Heavy Compound',
          'exercises': [
            {
              'name': 'Barbell Flat Bench Press',
              'target': 'Pectorals & Anterior Delts',
              'sets': '4 Sets × 8-10 Reps',
              'image': 'assets/images/workout_back.jpg',
            },
            {
              'name': 'Incline Dumbbell Press',
              'target': 'Upper Clavicular Head',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/onboarding_athlete.jpg',
            },
            {
              'name': 'Cable Crossover Fly',
              'target': 'Sternal Pec Isolation',
              'sets': '3 Sets × 15 Reps',
              'image': 'assets/images/workout_back.jpg',
            },
            {
              'name': 'Tricep Rope Pushdown',
              'target': 'Lateral & Long Tricep Head',
              'sets': '4 Sets × 12-15 Reps',
              'image': 'assets/images/male_fitness_banner.jpg',
            },
          ]
        },
        {
          'dayNumber': '2',
          'dayTitle': 'Back & Biceps Thickness',
          'split': 'Pull Day • Upper Lat & Rhomboid',
          'exercises': [
            {
              'name': 'Wide-Grip Pull Ups',
              'target': 'Latissimus Dorsi',
              'sets': '4 Sets × Max Reps',
              'image': 'assets/images/pullup_figure.jpg',
            },
            {
              'name': 'Seated Lat Pulldown',
              'target': 'Upper & Mid Back',
              'sets': '4 Sets × 10-12 Reps',
              'image': 'assets/images/pullup_figure.jpg',
            },
            {
              'name': 'Standing Dumbbell Curl',
              'target': 'Biceps Brachii',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/splash_athlete.jpg',
            },
          ]
        },
        {
          'dayNumber': '3',
          'dayTitle': 'Active Recovery & Core',
          'split': 'Rest & Mobility Day',
          'exercises': []
        },
        {
          'dayNumber': '4',
          'dayTitle': 'Legs & Glutes Overload',
          'split': 'Leg Day • Quad Dominant',
          'exercises': [
            {
              'name': 'Barbell Back Squat',
              'target': 'Quadriceps & Glute Max',
              'sets': '4 Sets × 8-10 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
            {
              'name': '45-Degree Leg Press',
              'target': 'Leg Hypertrophy',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
          ]
        },
        {
          'dayNumber': '5',
          'dayTitle': 'Shoulders & Core Stabilization',
          'split': 'Shoulder Silhouette',
          'exercises': [
            {
              'name': 'Overhead Barbell Military Press',
              'target': 'Total Deltoid Complex',
              'sets': '4 Sets × 10 Reps',
              'image': 'assets/images/male_fitness_banner.jpg',
            },
            {
              'name': 'Dumbbell Lateral Raise',
              'target': 'Medial Deltoid Head',
              'sets': '4 Sets × 15 Reps',
              'image': 'assets/images/male_fitness_banner.jpg',
            },
          ]
        },
      ],
    },
    {
      'id': 'women_hourglass',
      'title': 'Hourglass & Glute Sculpt',
      'subtitle': 'Aesthetic glute isolation and waist tightening blueprint',
      'category': 'women',
      'coach': 'Sarah Jenkins',
      'coachTitle': 'Women Specialist Coach',
      'rating': '5.0',
      'reviews': '1.9k',
      'duration': '6 Weeks',
      'frequency': '4 Days / Wk',
      'level': 'All Levels',
      'intensity': 'Toning & Shape',
      'calories': '420 kcal / session',
      'image': 'assets/images/female_fitness_banner.jpg',
      'featured': false,
      'tags': ['Glutes & Hamstrings', 'Waist Toning', 'Lower Body'],
      'overview':
          'Designed to shape, firm, and sculpt glute muscles while trimming the midsection with focused resistance training and high-metabolic circuits.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Glute & Posterior Chain Hypertrophy',
          'split': 'Glute Isolation',
          'exercises': [
            {
              'name': 'Barbell Hip Thrust',
              'target': 'Gluteus Maximus Focus',
              'sets': '4 Sets × 12-15 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
            {
              'name': 'Bulgarian Split Squat',
              'target': 'Single Leg Balance & Glute',
              'sets': '3 Sets × 12 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
          ]
        },
        {
          'dayNumber': '2',
          'dayTitle': 'Upper Body Toning & Core',
          'split': 'Toned Arms & Flat Waist',
          'exercises': [
            {
              'name': 'Lat Pulldown',
              'target': 'V-Taper Back Line',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/pullup_figure.jpg',
            },
            {
              'name': 'Plank Core Stabilization',
              'target': 'Transverse Abdominis',
              'sets': '3 Sets × 45 Sec',
              'image': 'assets/images/posture_dark_3d.jpg',
            },
          ]
        },
        {
          'dayNumber': '3',
          'dayTitle': 'Full Rest & Stretch',
          'split': 'Recovery & Hydration',
          'exercises': []
        },
        {
          'dayNumber': '4',
          'dayTitle': 'Hamstrings, Quads & Glute Burn',
          'split': 'Lower Body Definition',
          'exercises': [
            {
              'name': 'Barbell Squat',
              'target': 'Quads & Glutes',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
          ]
        },
      ],
    },
    {
      'id': 'fat_loss_shred',
      'title': 'High-Intensity Shred & Cut',
      'subtitle': 'Drop body fat fast while safeguarding hard-earned muscle',
      'category': 'shred',
      'coach': 'Marcus Cole',
      'coachTitle': 'Conditioning Coach',
      'rating': '4.8',
      'reviews': '3.2k',
      'duration': '6 Weeks',
      'frequency': '5 Days / Wk',
      'level': 'Intermediate',
      'intensity': 'Extreme Burn',
      'calories': '650 kcal / session',
      'image': 'assets/images/card_gym_full.png',
      'featured': false,
      'tags': ['Fat Loss', 'Metabolic Circuit', 'Lean Definition'],
      'overview':
          'Combines compound resistance movements with supersets and metabolic burn conditioning to maximize caloric deficit and muscular definition.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Upper Body Torso Blitz',
          'split': 'Chest, Core & Cardio',
          'exercises': [
            {
              'name': 'High-to-Low Cable Fly',
              'target': 'Lower Chest Cut',
              'sets': '4 Sets × 15 Reps',
              'image': 'assets/images/workout_back.jpg',
            },
            {
              'name': 'Hanging Knee Raise',
              'target': 'Lower Abdominal V-Line',
              'sets': '4 Sets × 20 Reps',
              'image': 'assets/images/posture_dark_3d.jpg',
            },
          ]
        },
        {
          'dayNumber': '2',
          'dayTitle': 'Legs & Calorie Surge',
          'split': 'Lower Body Supersets',
          'exercises': [
            {
              'name': 'Barbell Squat',
              'target': 'Quads & High Heart Rate',
              'sets': '4 Sets × 15 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
          ]
        },
      ],
    },
    {
      'id': 'beginner_blueprint',
      'title': '30-Day Complete Foundation',
      'subtitle': 'Step-by-step master plan for gym newcomers & rebooters',
      'category': 'beginner',
      'coach': 'Bilal Performance Team',
      'coachTitle': 'Certified Master Trainers',
      'rating': '4.9',
      'reviews': '4.5k',
      'duration': '4 Weeks',
      'frequency': '3 Days / Wk',
      'level': 'Beginner',
      'intensity': 'Foundational',
      'calories': '380 kcal / session',
      'image': 'assets/images/onboarding_athlete.jpg',
      'featured': false,
      'tags': ['Form & Posture', 'No Experience Needed', 'Full Body'],
      'overview':
          'The ultimate starting point. Learn pristine exercise form, build tendon resilience, and establish consistent workout habits with zero intimidation.',
      'schedule': [
        {
          'dayNumber': '1',
          'dayTitle': 'Upper Body Foundations',
          'split': 'Chest, Back & Arms',
          'exercises': [
            {
              'name': 'Incline Dumbbell Press',
              'target': 'Chest Strength',
              'sets': '3 Sets × 12 Reps',
              'image': 'assets/images/onboarding_athlete.jpg',
            },
            {
              'name': 'Seated Lat Pulldown',
              'target': 'Back Posture',
              'sets': '3 Sets × 12 Reps',
              'image': 'assets/images/pullup_figure.jpg',
            },
          ]
        },
        {
          'dayNumber': '2',
          'dayTitle': 'Active Recovery',
          'split': 'Walking & Mobility',
          'exercises': []
        },
        {
          'dayNumber': '3',
          'dayTitle': 'Lower Body & Core Health',
          'split': 'Quads & Stability',
          'exercises': [
            {
              'name': 'Leg Press Machine',
              'target': 'Safe Quad Strength',
              'sets': '3 Sets × 12 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
            {
              'name': 'Plank Hold',
              'target': 'Spinal Brace',
              'sets': '3 Sets × 30 Seconds',
              'image': 'assets/images/posture_dark_3d.jpg',
            },
          ]
        },
      ],
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
      final matchesCategory =
          _selectedCategory == 'all' || p['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          p['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p['subtitle'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p['coach'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
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
              backgroundColor: const Color(0xFF15171B),
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
                      'Routine "${program['title']}" is now active in Workout Hub!',
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
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            const SizedBox(height: 12),

            // 1. Ultra-clean Header
            _buildHeader(),

            const SizedBox(height: 14),

            // 2. Search & Filter Bar
            _buildSearchBar(),

            const SizedBox(height: 18),

            // 3. Featured Masterclass Hero (Cinematic Glassmorphism)
            _buildCinematicHero(),

            const SizedBox(height: 22),

            // 4. Horizontal Category Filter Pills
            _buildCategorySelector(),

            const SizedBox(height: 20),

            // 5. Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Training Blueprints',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF131519),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    '${_filteredPrograms.length} Routines',
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

            // 6. Programs Cards Feed
            ..._filteredPrograms.map((prog) => _buildModernProgramCard(prog)),
          ],
        ),
      ),
    );
  }

  // --- 1. Clean Top Header ---
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
                'Training Programs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF131519),
                  letterSpacing: -0.6,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Curated routines for every physique goal',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF757A86),
                ),
              ),
            ],
          ),
          // Quick shortcut to Active Session
          GestureDetector(
            onTap: () => widget.onNavigateTab?.call(2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF131519),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  SizedBox(width: 5),
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

  // --- 2. Minimal Search Bar ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9ECF0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF131519)),
          decoration: InputDecoration(
            hintText: 'Search programs, goals, or coaches...',
            hintStyle: const TextStyle(
              color: Color(0xFF9EA3AE),
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF9EA3AE),
              size: 20,
            ),
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

  // --- 3. Cinematic Hero Banner ---
  Widget _buildCinematicHero() {
    final hero = _programs[0];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        image: DecorationImage(
          image: AssetImage(hero['image']),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.black.withValues(alpha: 0.2),
              Colors.black.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () => _openProgramDetails(hero),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                color: Colors.white, size: 13),
                            SizedBox(width: 4),
                            Text(
                              'FEATURED BLUEPRINT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.accentGold, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              '${hero['rating']} (${hero['reviews']})',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hero['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${hero['duration']} • ${hero['frequency']} • By ${hero['coach']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'View Full Split & Schedule',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.primary,
                            size: 14,
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
      ),
    );
  }

  // --- 4. Category Filter Pills ---
  Widget _buildCategorySelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat['id'];

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['id']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF131519) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF131519)
                      : const Color(0xFFE9ECF0),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat['icon'],
                    size: 14,
                    color: isSelected ? AppColors.primary : const Color(0xFF757A86),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['title'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF33373F),
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
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

  // --- 5. Modern Editorial Program Card ---
  Widget _buildModernProgramCard(Map<String, dynamic> program) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9ECF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _openProgramDetails(program),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with gradient and badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.asset(
                      program['image'],
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        program['level'].toString().toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.accentGold, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            program['rating'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                          program['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Coach ${program['coach']}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Bottom Info & Spec Badges
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program['subtitle'],
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF676E7D),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Quick Specs
                    Row(
                      children: [
                        _buildSpecPill(
                          Icons.date_range_rounded,
                          program['duration'],
                        ),
                        const SizedBox(width: 8),
                        _buildSpecPill(
                          Icons.repeat_rounded,
                          program['frequency'],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.primary,
                            size: 16,
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
  }

  Widget _buildSpecPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF676E7D)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF33373F),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MODAL: Modern Program Details & Day Schedule (100% English)
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
              width: 44,
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
                // Top Hero
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
                          child: const Icon(Icons.close_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title & Subtitle
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.program['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF131519),
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Guided by ${widget.program['coach']} (${widget.program['coachTitle']})',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF676E7D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Overview
                Text(
                  widget.program['overview'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF525763),
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 18),

                // Stat Cards Row
                Row(
                  children: [
                    _buildStatCard(
                      Icons.timer_outlined,
                      'Duration',
                      widget.program['duration'],
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      Icons.calendar_today_rounded,
                      'Split',
                      widget.program['frequency'],
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      Icons.fitness_center_rounded,
                      'Level',
                      widget.program['level'],
                    ),
                  ],
                ),

                const SizedBox(height: 22),
                const Divider(height: 1, color: Color(0xFFEDF0F4)),
                const SizedBox(height: 18),

                // Weekly Split Day Tabs
                const Text(
                  'Weekly Schedule & Exercises',
                  style: TextStyle(
                    fontSize: 15,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF131519)
                                : const Color(0xFFF4F6F8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'Day ${idx + 1}',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF33373F),
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentDay['split'] ?? '',
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
                          Icon(Icons.bedtime_rounded,
                              size: 40, color: Color(0xFF90A4AE)),
                          SizedBox(height: 10),
                          Text(
                            'Active Rest & Muscle Recovery',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Hydrate, rest, and hit your protein target for protein synthesis.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF676E7D),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Exercises List
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
                              width: 62,
                              height: 62,
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

                // Primary CTA: Activate Routine
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

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF757A86),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF131519),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
