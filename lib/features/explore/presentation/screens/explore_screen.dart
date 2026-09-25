import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ExploreScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const ExploreScreen({super.key, this.onNavigateTab});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Selected Program Category filter: 'all', 'bulk', 'shred', 'women', 'beginner'
  String _selectedCategory = 'all';

  // Search query
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Programs Categories List
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'all',
      'name': 'هەموو کۆرسەکان',
      'english': 'All Programs',
      'icon': Icons.grid_view_rounded,
    },
    {
      'id': 'bulk',
      'name': 'زەخامەت و ماسولکە',
      'english': 'Hypertrophy',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'id': 'shred',
      'name': 'چەوری سووتاندن',
      'english': 'Fat Loss & Shred',
      'icon': Icons.local_fire_department_rounded,
    },
    {
      'id': 'women',
      'name': 'تایبەت بە کچان',
      'english': 'Women Sculpt',
      'icon': Icons.accessibility_new_rounded,
    },
    {
      'id': 'beginner',
      'name': 'سەرەتایی و دەستپێک',
      'english': 'Beginner 30-Day',
      'icon': Icons.flag_rounded,
    },
  ];

  // Comprehensive Programs Database
  final List<Map<String, dynamic>> _programs = [
    {
      'id': 'hypertrophy_pro',
      'title': 'کۆرسی زەخامەت و دروستکردنی ماسولکە',
      'english': 'Pro Hypertrophy & Muscle Mass',
      'category': 'bulk',
      'coach': 'ڕاهێنەر بیلال',
      'rating': '4.9 ⭐ (2.4k)',
      'weeks': '8 هەفتە',
      'daysPerWeek': '5 ڕۆژ لە هەفتەیەکدا',
      'level': 'مامناوەند / پێشکەوتوو',
      'image': 'assets/images/workout_back.jpg',
      'description':
          'پرۆگرامێکی زانستی و توند بۆ گەورەکردنی قەبارەی ماسولکە و دەمار بە تەکنیکی فرە-سێت و کێشی مامناوەند بۆ قورس.',
      'tagColor': AppColors.primary,
      'schedule': [
        {
          'day': 'ڕۆژی ١: سنگ و بەشی پێشەوە',
          'focus': 'سنگ و تڕایسێپس (Chest & Triceps)',
          'exercises': [
            {
              'name': 'Barbell Bench Press',
              'kurdish': 'بێنچ پرێس بە باربێڵ',
              'sets': '4 Sets × 10 Reps',
              'image': 'assets/images/workout_back.jpg',
            },
            {
              'name': 'Incline Dumbbell Press',
              'kurdish': 'پرێسی سنگ بە دەمبڵی لار',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/onboarding_athlete.jpg',
            },
            {
              'name': 'Cable Chest Fly',
              'kurdish': 'کەیبڵ فلای بۆ سنگ',
              'sets': '3 Sets × 15 Reps',
              'image': 'assets/images/workout_back.jpg',
            },
            {
              'name': 'Tricep Rope Pushdown',
              'kurdish': 'تڕایسێپس بە حەبل',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/male_fitness_banner.jpg',
            },
          ]
        },
        {
          'day': 'ڕۆژی ٢: پشت و باڵەکان',
          'focus': 'پشت و بایسێپس (Back & Biceps)',
          'exercises': [
            {
              'name': 'Wide-Grip Pull Ups',
              'kurdish': 'پول ئەپس بە گرتنی پان',
              'sets': '4 Sets × 10 Reps',
              'image': 'assets/images/pullup_figure.jpg',
            },
            {
              'name': 'Lat Pulldown',
              'kurdish': 'لات پولداون بە دانیشتن',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/pullup_figure.jpg',
            },
            {
              'name': 'Standing Dumbbell Bicep Curl',
              'kurdish': 'کێرڵی دەمبڵ بۆ بازوو',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/splash_athlete.jpg',
            },
          ]
        },
        {
          'day': 'ڕۆژی ٣: پشوودان',
          'focus': 'پشووی ماسولکە و خۆراک (Active Recovery)',
          'exercises': []
        },
        {
          'day': 'ڕۆژی ٤: قاچ و سمت',
          'focus': 'تەواوی ماسولکەکانی قاچ (Legs Power)',
          'exercises': [
            {
              'name': 'Barbell Squat',
              'kurdish': 'سکوات بە باربێڵ',
              'sets': '4 Sets × 10 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
            {
              'name': '45-Degree Leg Press',
              'kurdish': 'پرێسی قاچ بە ئامێر',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
          ]
        },
        {
          'day': 'ڕۆژی ٥: شان و سک',
          'focus': 'شان و کەمەر (Shoulders & Core)',
          'exercises': [
            {
              'name': 'Overhead Shoulder Press',
              'kurdish': 'پرێسی شان بە باربێڵ',
              'sets': '4 Sets × 10 Reps',
              'image': 'assets/images/male_fitness_banner.jpg',
            },
            {
              'name': 'Dumbbell Lateral Raise',
              'kurdish': 'بەرزکردنەوەی دەمبڵ بۆ تەنیشت',
              'sets': '4 Sets × 15 Reps',
              'image': 'assets/images/male_fitness_banner.jpg',
            },
          ]
        },
      ],
    },
    {
      'id': 'women_glutes_tone',
      'title': 'کۆرسی شێپین و قاچ و کەمەر (تایبەت بە خانمان)',
      'english': 'Hourglass & Glute Sculpt Program',
      'category': 'women',
      'coach': 'ڕاهێنەر سارە',
      'rating': '5.0 ⭐ (1.9k)',
      'weeks': '6 هەفتە',
      'daysPerWeek': '4 ڕۆژ لە هەفتەیەکدا',
      'level': 'هەموو ئاستەکان',
      'image': 'assets/images/female_fitness_banner.jpg',
      'description':
          'دیزاینکراو بە تایبەت بۆ بەهێزکردنی سمت، ڕان، تەنگکردنی کەمەر و شێوەیەکی ڕێک و وەرزشی بۆ تەواوی جەستە.',
      'tagColor': const Color(0xFFE91E63),
      'schedule': [
        {
          'day': 'ڕۆژی ١: بەهێزکردنی سمت و ڕان',
          'focus': 'Glutes & Hamstrings',
          'exercises': [
            {
              'name': 'Barbell Hip Thrust',
              'kurdish': 'هیپ ترەست بە باربێڵ',
              'sets': '4 Sets × 15 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
            {
              'name': 'Bulgarian Split Squat',
              'kurdish': 'بولگاریان سکوات بە دەمبڵ',
              'sets': '3 Sets × 12 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
          ]
        },
        {
          'day': 'ڕۆژی ٢: بەشی سەرەوە و کەمەر',
          'focus': 'Back, Shoulders & Waist',
          'exercises': [
            {
              'name': 'Lat Pulldown',
              'kurdish': 'لات پولداون',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/pullup_figure.jpg',
            },
            {
              'name': 'Plank Core Stabilization',
              'kurdish': 'پلانک بۆ توندکردنی سک',
              'sets': '3 Sets × 45 Sec',
              'image': 'assets/images/posture_dark_3d.jpg',
            },
          ]
        },
        {
          'day': 'ڕۆژی ٣: پشوودان',
          'focus': 'Rest & Stretch',
          'exercises': []
        },
        {
          'day': 'ڕۆژی ٤: سوتاندنی چەوری و قاچ',
          'focus': 'Legs Definition & Cardio Burn',
          'exercises': [
            {
              'name': 'Barbell Squat',
              'kurdish': 'سکوات بە باربێڵ',
              'sets': '4 Sets × 12 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
          ]
        },
      ],
    },
    {
      'id': 'fat_loss_shred',
      'title': 'کۆرسی چەوری سووتاندن و وشککردنەوە',
      'english': 'Maximum Fat Shred & High Intensity',
      'category': 'shred',
      'coach': 'ڕاهێنەر ئاراس',
      'rating': '4.8 ⭐ (3.1k)',
      'weeks': '6 هەفتە',
      'daysPerWeek': '5 ڕۆژ لە هەفتەیەکدا',
      'level': 'مامناوەند',
      'image': 'assets/images/card_gym_full.png',
      'description':
          'تێکەڵەیەک لە یاری قورس بە دووبارەی بەرز و کاردیۆی چڕ بۆ تواندنەوەی چەوری ژێر پێست و دەرخستنی هێڵەکانی ماسولکە.',
      'tagColor': const Color(0xFFFF5722),
      'schedule': [
        {
          'day': 'ڕۆژی ١: سنگ، سک و کاردیۆ',
          'focus': 'Chest & Core Burn',
          'exercises': [
            {
              'name': 'High-to-Low Cable Fly',
              'kurdish': 'کەیبڵ فلای خێرا',
              'sets': '4 Sets × 15 Reps',
              'image': 'assets/images/workout_back.jpg',
            },
            {
              'name': 'Hanging Knee Raise',
              'kurdish': 'هەڵواسینی ئەژنۆ بۆ خوارەوەی سک',
              'sets': '4 Sets × 20 Reps',
              'image': 'assets/images/posture_dark_3d.jpg',
            },
          ]
        },
        {
          'day': 'ڕۆژی ٢: بازنەیی قاچ و کەمەر',
          'focus': 'Legs & Calorie Blitz',
          'exercises': [
            {
              'name': 'Barbell Squat',
              'kurdish': 'سکوات بە باربێڵ',
              'sets': '4 Sets × 15 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
          ]
        },
      ],
    },
    {
      'id': 'beginner_foundations',
      'title': 'کۆرسی سەرەتایی و فێربوونی هەنگاو بە هەنگاو',
      'english': '30-Day Beginner Gym Blueprint',
      'category': 'beginner',
      'coach': 'تیمی ڕاهێنەرانی جیم بیلال',
      'rating': '4.9 ⭐ (4.5k)',
      'weeks': '4 هەفتە',
      'daysPerWeek': '3 ڕۆژ لە هەفتەیەکدا',
      'level': 'سەرەتایی تەواو',
      'image': 'assets/images/onboarding_athlete.jpg',
      'description':
          'باشترین کۆرس بۆ ئەوانەی یەکەم مانگیانە دێنە هۆڵی جیم. فێربوونی تەکنیکی دروستی جوڵەکان بەبێ پێکان و دروستکردنی بنەمایەکی پتەو.',
      'tagColor': const Color(0xFF009688),
      'schedule': [
        {
          'day': 'ڕۆژی ١: هەموو بەشەکانی سەرەوە (Upper Body)',
          'focus': 'Upper Body Mechanics',
          'exercises': [
            {
              'name': 'Incline Dumbbell Press',
              'kurdish': 'پرێسی سنگ بە دەمبڵ',
              'sets': '3 Sets × 12 Reps',
              'image': 'assets/images/onboarding_athlete.jpg',
            },
            {
              'name': 'Lat Pulldown',
              'kurdish': 'لات پولداون',
              'sets': '3 Sets × 12 Reps',
              'image': 'assets/images/pullup_figure.jpg',
            },
          ]
        },
        {
          'day': 'ڕۆژی ٢: پشوودان',
          'focus': 'Rest & Recovery',
          'exercises': []
        },
        {
          'day': 'ڕۆژی ٣: بەشی خوارەوە و ناوەند (Lower Body & Core)',
          'focus': 'Legs & Posture',
          'exercises': [
            {
              'name': 'Leg Press',
              'kurdish': 'پرێسی قاچ بە ئامێر',
              'sets': '3 Sets × 12 Reps',
              'image': 'assets/images/female_fitness_banner.jpg',
            },
            {
              'name': 'Plank',
              'kurdish': 'پلانک بۆ ڕاگرتنی کەمەر',
              'sets': '3 Sets × 30 Sec',
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
          p['english'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
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
          // Navigate to central Workout tab (index 2)
          widget.onNavigateTab?.call(2);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.primaryDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Row(
                children: [
                  const Icon(Icons.rocket_launch_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '🔥 کۆرسی "${program['title']}" بوو بە کۆرسی چالاکت!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            const SizedBox(height: 12),

            // 1. Header (Title + Subtitle + Workout tab shortcut)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'کۆرس و بەرنامەکان (Programs)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightTextPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'پلانی زانستی ئامادەکراو بۆ گەیشتن بە ئامانجەکەت',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onNavigateTab?.call(2); // Go to Workout Hub
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.fitness_center_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'ڕاهێنانم',
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
            ),

            const SizedBox(height: 14),

            // 2. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
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
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'گەڕان بەناو ناوی کۆرسەکان (زەخامەت، کچان، سووتاندن)...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12.5,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
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
            ),

            const SizedBox(height: 16),

            // 3. Featured Hero Card: Captain Bilal Masterclass
            _buildFeaturedProgramHero(),

            const SizedBox(height: 18),

            // 4. Category Filter Chips
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat['id'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat['id'];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade200,
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
                            cat['icon'],
                            size: 15,
                            color: isSelected
                                ? Colors.white
                                : AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat['name'],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.lightTextPrimary,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // 5. Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'کۆرسە فەرمییەکان',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_filteredPrograms.length} بەرنامە',
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

            // 6. Programs List Cards
            ..._filteredPrograms.map((prog) => _buildProgramCard(prog)),
          ],
        ),
      ),
    );
  }

  // --- Featured Hero Card ---
  Widget _buildFeaturedProgramHero() {
    final featured = _programs[0];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(featured['image']),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.55),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _openProgramDetails(featured),
          child: Padding(
            padding: const EdgeInsets.all(18),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'کۆرسی هەڵبژێردراو 🔥',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        featured['rating'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      featured['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${featured['weeks']} • ${featured['daysPerWeek']} • ${featured['coach']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'بینینی خشتە و یارییەکان',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.primary,
                          size: 11,
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

  // --- Program Card Item ---
  Widget _buildProgramCard(Map<String, dynamic> program) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _openProgramDetails(program),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Image with Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(22)),
                    child: Image.asset(
                      program['image'],
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        program['level'],
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        program['rating'],
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

              // Info & Details
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program['title'],
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      program['english'],
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Badges row: duration, days, coach
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.date_range_rounded,
                          program['weeks'],
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.repeat_rounded,
                          program['daysPerWeek'],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _openProgramDetails(program),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(Icons.play_circle_outline, size: 16),
                            label: const Text(
                              'دەستپێکردن و خشتە',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
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
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MODAL: Program Details & Day Schedule
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
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              children: [
                // Banner Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    widget.program['image'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),

                // Title & Coach
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
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ڕاهێنەر: ${widget.program['coach']} • ${widget.program['rating']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  widget.program['description'],
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // Day Selector Tabs
                const Text(
                  'خشتەی هەفتانەی کۆرسەکە:',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: schedule.length,
                    itemBuilder: (context, idx) {
                      final isSelected = _selectedDayIndex == idx;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = idx),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'ڕۆژی ${idx + 1}',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.lightTextPrimary,
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

                const SizedBox(height: 14),

                // Day Focus Details
                if (currentDay != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.tagCardio,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.flash_on_rounded,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            currentDay['focus'] ?? '',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (exercises.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.bedtime_rounded,
                              size: 40, color: Colors.blue.shade300),
                          const SizedBox(height: 8),
                          const Text(
                            'ئەمڕۆ پشووی ماسولکەکانە (Rest Day)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'خۆراکی پڕ پڕۆتین بخۆ و ئاوی پێویست بنۆشە بۆ نوێبوونەوەی خانەکان.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Exercises list for this day
                  ...exercises.map((ex) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              ex['image'],
                              width: 58,
                              height: 58,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex['kurdish'] ?? ex['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ex['sets'] ?? '4 Sets × 12 Reps',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.check_circle_outline,
                              color: AppColors.primary, size: 20),
                        ],
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 20),

                // Activate Program Action Button
                ElevatedButton.icon(
                  onPressed: widget.onActivateProgram,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.bolt_rounded, size: 20),
                  label: const Text(
                    'چالاککردنی ئەم کۆرسە و دەستپێکردنی ڕاهێنان 🚀',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
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
}
