import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // Navigation / View mode: 0 = My Course (کۆرسەکەم), 1 = All Exercises (هەموو یارییەکان)
  int _activeViewMode = 0;

  // Selected Muscle Category for All Exercises tab
  int _selectedMuscleIndex = 0;
  final List<String> _muscles = [
    'هەموو بەشەکان',
    'سنگ (Chest)',
    'پشت (Back)',
    'شان (Shoulders)',
    'باڵ و بازوو (Arms)',
    'قاچ و سمت (Legs)',
    'سک و ناوەند (Core)',
  ];

  // Rest Timer State
  int _selectedTimerDuration = 45;
  int _currentTimerSeconds = 45;
  bool _isTimerRunning = false;
  Timer? _timer;

  // Search Query
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Comprehensive Master Exercises Database
  final List<Map<String, dynamic>> _masterExercises = [
    {
      'id': 'bench_press',
      'title': 'Barbell Bench Press',
      'kurdish': 'بێنچ پرێس بە باربێڵ',
      'muscle': 'سنگ (Chest)',
      'muscleCategory': 'سنگ (Chest)',
      'sets': '4 Sets × 10-12 Reps',
      'level': 'مامناوەند',
      'burn': '140 kcal',
      'equipment': 'Barbell & Flat Bench',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'لەسەر بێنچەکە پاڵبکەوە، باربێڵەکە بە فراوانی شانت بگرە. بە هێواشی بیهێنە خوارەوە بۆ سەر سنگت و دواتر بە هێزەوە بیبە سەرەوە بەبێ قفڵکردنی تەواوی ئەنیشک.',
      'mistake': 'بەرزکردنەوەی کەمەر لەسەر بێنچ یان کێشانی بەهێز لە سنگ.',
      'keywords': ['bench', 'press', 'بێنچ', 'پرێس', 'سنگ', 'باربێڵ', 'chest'],
    },
    {
      'id': 'incline_dumbbell_press',
      'title': 'Incline Dumbbell Press',
      'kurdish': 'پرێسی سنگ بە دەمبڵی لار',
      'muscle': 'بەشی سەرەوەی سنگ',
      'muscleCategory': 'سنگ (Chest)',
      'sets': '4 Sets × 12 Reps',
      'level': 'پێشکەوتوو',
      'burn': '125 kcal',
      'equipment': 'Incline Bench & Dumbbells',
      'image': 'assets/images/onboarding_athlete.jpg',
      'instructions':
          'بێنچەکە لەسەر گۆشەی ٣٠ بۆ ٤٥ پلە دابنێ. دەمبڵەکان بەرەو سەر سنگ بەرز بکەرەوە و لە سەرەوە کەمێک فشار بخەرە سەر سنگت.',
      'mistake': 'دانانی گۆشەی زۆر بەرز کە فشار بخاتە سەر شانەکان.',
      'keywords': ['incline', 'dumbbell', 'دەمبڵ', 'لار', 'سنگ', 'سەرەوە'],
    },
    {
      'id': 'cable_fly',
      'title': 'Cable Chest Fly',
      'kurdish': 'کەیبڵ فلای بۆ سنگ',
      'muscle': 'ناوەڕاست و خوارەوەی سنگ',
      'muscleCategory': 'سنگ (Chest)',
      'sets': '3 Sets × 15 Reps',
      'level': 'سەرەتایی / مامناوەند',
      'burn': '95 kcal',
      'equipment': 'Cable Crossover Machine',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'دەستەکان بە کەوانەیی بەرەو پێشەوە بهێنە، سنگت کەمێک بەرەو پێشەوە بدە و ئەنیشکەکان کەمێک چەماوە ڕابگرە.',
      'mistake': 'ڕاستکردنەوەی تەواوی قۆڵ و فشار خستنە سەر مەچەک.',
      'keywords': ['cable', 'fly', 'کەیبڵ', 'فلای', 'تەلبەند', 'سنگ'],
    },
    {
      'id': 'pull_ups',
      'title': 'Wide-Grip Pull Ups',
      'kurdish': 'پول ئەپس بە گرتنی پان',
      'muscle': 'پشت و باڵەکان (Back & Lats)',
      'muscleCategory': 'پشت (Back)',
      'sets': '4 Sets × To Failure',
      'level': 'مامناوەند',
      'burn': '160 kcal',
      'equipment': 'Pull-Up Bar',
      'image': 'assets/images/pullup_figure.jpg',
      'instructions':
          'بارەکە پانتر لە شانت بگرە. سنگت بەرز بکەرەوە بەرەو بارەکە تا چەناگەت دەگاتە سەرووی بار، پاشان بە کۆنترۆڵ بگەڕێوە خوارەوە.',
      'mistake': 'جوڵاندنی زۆری لەش و بەکارهێنانی زەبری پێیەکان.',
      'keywords': ['pull', 'up', 'پول', 'ئەپ', 'پشت', 'باڵ', 'تەناف', 'back'],
    },
    {
      'id': 'lat_pulldown',
      'title': 'Lat Pulldown',
      'kurdish': 'لات پولداون بە دانیشتن',
      'muscle': 'پشت و فراوانکردنی باڵ',
      'muscleCategory': 'پشت (Back)',
      'sets': '4 Sets × 12 Reps',
      'level': 'سەرەتایی',
      'burn': '110 kcal',
      'equipment': 'Cable Pulldown Machine',
      'image': 'assets/images/pullup_figure.jpg',
      'instructions':
          'بارەکە بگرە و کەمێک پشتت لار بکەرەوە بەرەو دواوە. بارەکە بهێنە خوارەوە بۆ سەرووی سنگت و ماسولکەی پشتت توند بکە.',
      'mistake': 'هێنانە خوارەوەی بار بۆ پشتی مل.',
      'keywords': ['lat', 'pulldown', 'پولداون', 'لات', 'پشت', 'کێشان'],
    },
    {
      'id': 'seated_cable_row',
      'title': 'Seated Cable Row',
      'kurdish': 'سیتد کەیبڵ ڕەو بە دانیشتن',
      'muscle': 'ناوەڕاستی پشت و تەرەپیز',
      'muscleCategory': 'پشت (Back)',
      'sets': '3 Sets × 12 Reps',
      'level': 'مامناوەند',
      'burn': '105 kcal',
      'equipment': 'Low Row Cable Machine',
      'image': 'assets/images/pullup_figure.jpg',
      'instructions':
          'دەسکەکە بە هەردوو دەست بەرەو سک کێش بکە، سنگت بەرز ڕاگرە و لە دواوە هەردوو بەشی پشتت بە یەک بگەیەنە.',
      'mistake': 'چەمانەوەی کەمەر بەرەو پێشەوە لە کاتی هێنانەوە.',
      'keywords': ['row', 'seated', 'ڕەو', 'پشت', 'دانیشتن', 'کەیبڵ'],
    },
    {
      'id': 'bicep_curls',
      'title': 'Standing Dumbbell Bicep Curls',
      'kurdish': 'کێرڵی دەمبڵ بۆ بایسێپس',
      'muscle': 'پێشەوەی قۆڵ (Biceps)',
      'muscleCategory': 'باڵ و بازوو (Arms)',
      'sets': '3 Sets × 12-15 Reps',
      'level': 'سەرەتایی',
      'burn': '85 kcal',
      'equipment': 'Dumbbells',
      'image': 'assets/images/splash_athlete.jpg',
      'instructions':
          'بە پێوە بوەستە، ئەنیشکەکانت لە تەنیشت کەمەرت جێگیر بکە. بەبێ جوڵاندنی شان دەمبڵەکان بەرەو سەرەوە بەرز بکەرەوە.',
      'mistake': 'هاوێشتنی دەمبڵ بە زەبری پشت.',
      'keywords': ['bicep', 'curl', 'بایسێپس', 'کێرڵ', 'قۆڵ', 'دەمبڵ', 'بازوو'],
    },
    {
      'id': 'tricep_rope_pushdown',
      'title': 'Tricep Rope Pushdown',
      'kurdish': 'تڕایسێپس پوشداون بە حەبل',
      'muscle': 'پشتی قۆڵ (Triceps)',
      'muscleCategory': 'باڵ و بازوو (Arms)',
      'sets': '4 Sets × 15 Reps',
      'level': 'سەرەتایی / مامناوەند',
      'burn': '90 kcal',
      'equipment': 'Cable & Rope Attachment',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'حەبلەکە بگرە و بەرەو خوارەوە ڕایبکێشە، لە کۆتایی جوڵەکە دەستەکان لە یەک جیا بکەرەوە بۆ تەواوی گرژبوونی تڕایسێپس.',
      'mistake': 'جوڵاندنی ئەنیشک بەرەو پێش و پاش.',
      'keywords': ['tricep', 'rope', 'حەبل', 'تڕایسێپس', 'پوشداون', 'قۆڵ'],
    },
    {
      'id': 'dumbbell_lateral_raise',
      'title': 'Dumbbell Lateral Raise',
      'kurdish': 'بەرزکردنەوەی دەمبڵ بۆ تەنیشت (شان)',
      'muscle': 'تەنیشتی شان (Side Delts)',
      'muscleCategory': 'شان (Shoulders)',
      'sets': '4 Sets × 15 Reps',
      'level': 'سەرەتایی',
      'burn': '75 kcal',
      'equipment': 'Pair of Dumbbells',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'دەمبڵەکان بۆ تەنیشت بەرز بکەرەوە تا هاوتای ئاستی شانت، ئەنیشکت کەمێک چەماوە بێت.',
      'mistake': 'هەڵگرتنی کێشی زۆر قورس و هاوێشتن بە لەش.',
      'keywords': ['lateral', 'raise', 'شان', 'دەمبڵ', 'تەنیشت', 'delts'],
    },
    {
      'id': 'barbell_shoulder_press',
      'title': 'Overhead Barbell Shoulder Press',
      'kurdish': 'پرێسی شان بە باربێڵ',
      'muscle': 'تەواوی شان و هێزی سەرەوە',
      'muscleCategory': 'شان (Shoulders)',
      'sets': '4 Sets × 10 Reps',
      'level': 'مامناوەند',
      'burn': '130 kcal',
      'equipment': 'Barbell',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'باربێڵ لە ئاستی سەرووی سنگەوە بەرەو سەرووی سەر بەرز بکەرەوە بە بەهێزی ناوەند و قاچەکان.',
      'mistake': 'کەوانەکردنی زۆری بڕبڕەی پشت.',
      'keywords': ['shoulder', 'press', 'شان', 'پرێس', 'باربێڵ', 'سەروو'],
    },
    {
      'id': 'barbell_squat',
      'title': 'Barbell Back Squat',
      'kurdish': 'سکوات بە باربێڵ بۆ تەواوی قاچ',
      'muscle': 'چوارسەرەی قاچ و سمت (Quads & Glutes)',
      'muscleCategory': 'قاچ و سمت (Legs)',
      'sets': '4 Sets × 10-12 Reps',
      'level': 'پێشکەوتوو',
      'burn': '190 kcal',
      'equipment': 'Squat Rack & Barbell',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'پێیەکان بە فراوانی شان دابنێ، سنگت بەرز ڕاگرە، وەک دانیشتن لەسەر کورسی داببەزە تا ڕانەکان هاوتەریبی زەوی دەبن.',
      'mistake': 'تێپەڕاندنی زۆری ئەژنۆ بەرەو ناوەوە یان چەمانەوەی پشت.',
      'keywords': ['squat', 'سکوات', 'قاچ', 'ڕان', 'سمت', 'باربێڵ', 'legs'],
    },
    {
      'id': 'barbell_hip_thrust',
      'title': 'Barbell Hip Thrust',
      'kurdish': 'هیپ ترەست بە باربێڵ بۆ سمت',
      'muscle': 'سمت و پشتی ڕان (Glutes)',
      'muscleCategory': 'قاچ و سمت (Legs)',
      'sets': '4 Sets × 12-15 Reps',
      'level': 'مامناوەند',
      'burn': '170 kcal',
      'equipment': 'Barbell & Bench',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'پشتی سەرەوە لەسەر بێنچەکە دابنێ، بە پاژنەی پێ حەوزت بەرز بکەرەوە تا ڕان و لەشت ڕێک دەبن و لە سەرەوە ٢ چرکە بیگرە.',
      'mistake': 'زۆر کێشانی کەمەر بەرەو سەرەوە.',
      'keywords': ['hip', 'thrust', 'هیپ', 'ترەست', 'سمت', 'ڕان', 'glutes'],
    },
    {
      'id': 'leg_press',
      'title': '45-Degree Leg Press',
      'kurdish': 'پرێسی قاچ بە ئامێر',
      'muscle': 'تەواوی ماسولکەکانی قاچ',
      'muscleCategory': 'قاچ و سمت (Legs)',
      'sets': '4 Sets × 12 Reps',
      'level': 'سەرەتایی / مامناوەند',
      'burn': '155 kcal',
      'equipment': 'Leg Press Machine',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'پێیەکانت لەسەر تەختەکە جێگیر بکە بە ئەندازەی شانت، کێشەکە بهێنە خوارەوە تا ئەژنۆ ٩٠ پلە دەچەمێتەوە و دواتر پاڵی پێوە بنێ.',
      'mistake': 'قفڵکردنی توندی ئەژنۆ لە کاتی پاڵنان.',
      'keywords': ['leg', 'press', 'پرێس', 'قاچ', 'ئامێر', 'مەشق'],
    },
    {
      'id': 'plank_core',
      'title': 'Plank Core Stabilization',
      'kurdish': 'پلانک بۆ پتەوی سک و ناوەند',
      'muscle': 'سک، کەمەر و ناوەند (Core)',
      'muscleCategory': 'سک و ناوەند (Core)',
      'sets': '3 Sets × 60 Secs',
      'level': 'سەرەتایی',
      'burn': '80 kcal',
      'equipment': 'Exercise Mat',
      'image': 'assets/images/posture_dark_3d.jpg',
      'instructions':
          'لەسەر پێشەوەی قۆڵ و نووکی پێیەکان بوەستە، تەواوی لەشت ڕێک ڕابگرە بەبێ دابەزینی کەمەر.',
      'mistake': 'دابەزینی کەمەر بەرەو زەوی یان زۆر بەرزکردنەوەی سمت.',
      'keywords': ['plank', 'پلانک', 'سک', 'ناوەند', 'کەمەر', 'core', 'abs'],
    },
    {
      'id': 'hanging_knee_raise',
      'title': 'Hanging Knee / Leg Raise',
      'kurdish': 'بەرزکردنەوەی ئەژنۆ بە هەڵواسین',
      'muscle': 'خوارەوەی سک (Lower Abs)',
      'muscleCategory': 'سک و ناوەند (Core)',
      'sets': '3 Sets × 15 Reps',
      'level': 'مامناوەند',
      'burn': '90 kcal',
      'equipment': 'Pull-Up Bar / Captain Chair',
      'image': 'assets/images/posture_dark_3d.jpg',
      'instructions':
          'بە بارەکەوە هەڵبواسە، ئەژنۆکانت کۆبکەرەوە و بە ماسولکەی سک بەرەو سنگت بەرز بکەرەوە بەبێ لەرزین.',
      'mistake': 'هاوێشتنی قاچەکان بە شێوەی پاندۆڵ.',
      'keywords': ['hanging', 'knee', 'raise', 'سک', 'خوارەوە', 'ئەژنۆ', 'abs'],
    },
  ];

  // Active Custom Course State
  bool _hasCustomCourse = true;
  String _customCourseTitle = 'کۆرسی ڕاهێنانی من (سنگ و قۆڵ)';
  String _customCourseSource = 'وێنەی خشتەی ڕاهێنان (Scanned Course)';
  List<Map<String, dynamic>> _myCourseExercises = [];
  final Map<String, List<bool>> _exerciseSetsCompleted = {};

  @override
  void initState() {
    super.initState();
    _initializeDefaultCourse();
  }

  void _initializeDefaultCourse() {
    // Default initial loaded course from coach
    _myCourseExercises = [
      Map<String, dynamic>.from(_masterExercises[0]), // Bench Press
      Map<String, dynamic>.from(_masterExercises[1]), // Incline Press
      Map<String, dynamic>.from(_masterExercises[2]), // Cable Fly
      Map<String, dynamic>.from(_masterExercises[6]), // Bicep Curls
      Map<String, dynamic>.from(_masterExercises[7]), // Tricep Pushdown
    ];

    for (var ex in _myCourseExercises) {
      _exerciseSetsCompleted[ex['id']] = [true, true, false, false];
    }
  }

  // Rest Timer Logic
  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _currentTimerSeconds = _selectedTimerDuration;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimerSeconds > 0) {
        setState(() {
          _currentTimerSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerRunning = false;
        });
        _showTimerCompleteNotification();
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _currentTimerSeconds = _selectedTimerDuration;
    });
  }

  void _showTimerCompleteNotification() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: const Row(
          children: [
            Icon(Icons.timer_off_rounded, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'کاتی پشوودان تەواو بوو! کاتی دەستپێکردنی سێتی داهاتووە 💪',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Total Completed Sets in Course
  int get _totalCourseSets {
    int total = 0;
    for (var sets in _exerciseSetsCompleted.values) {
      total += sets.length;
    }
    return total;
  }

  int get _completedCourseSets {
    int count = 0;
    for (var sets in _exerciseSetsCompleted.values) {
      count += sets.where((c) => c).length;
    }
    return count;
  }

  // --- MODAL: Add / Import Course Sheet ---
  void _openCourseImportDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CourseImportBottomSheet(
        masterExercises: _masterExercises,
        onCourseGenerated: (title, source, exercises) {
          setState(() {
            _hasCustomCourse = true;
            _customCourseTitle = title;
            _customCourseSource = source;
            _myCourseExercises = exercises;
            _exerciseSetsCompleted.clear();
            for (var ex in exercises) {
              _exerciseSetsCompleted[ex['id']] = [false, false, false, false];
            }
            _activeViewMode = 0; // Switch to My Course view
          });

          // Show celebration toast
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1B873F),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '🎉 پیرۆزە! کۆرسەکەت بە سەرکەوتوویی دروستکرا (${exercises.length} یاری ئامادەیە)',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
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

  // Open Exercise Details Bottom Sheet
  void _openExerciseDetails(Map<String, dynamic> exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ExerciseDetailModal(
        exercise: exercise,
        onStartTimer: () {
          Navigator.pop(context);
          _startTimer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          // 1. HERO BANNER: The prominent Course Upload & Manual Builder
          _buildCourseHeroCard(),

          const SizedBox(height: 14),

          // 2. Interactive Rest Timer Hub
          _buildRestTimerCard(),

          const SizedBox(height: 18),

          // 3. Dual Tabs: "کۆرسەکەم (ئەمانە یاریەکانتن)" vs "هەموو یارییەکان"
          _buildViewModeToggle(),

          const SizedBox(height: 14),

          // 4. Content Switcher
          if (_activeViewMode == 0)
            _buildMyCourseSection()
          else
            _buildAllExercisesSection(),
        ],
      ),
    );
  }

  // --- App Bar ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'یارییەکان و ڕاهێنان (Workout Hub)',
            style: TextStyle(
              color: AppColors.lightTextPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _hasCustomCourse
                ? 'کۆرسی چالاک: $_customCourseTitle'
                : 'پلانی ڕۆژانە و کۆرسی ڕاهێنانەکانت',
            style: const TextStyle(
              color: AppColors.lightTextSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'زیادکردنی کۆرس',
          onPressed: _openCourseImportDialog,
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_photo_alternate_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // --- 1. HERO BANNER: The Course Action Trigger ---
  Widget _buildCourseHeroCard() {
    final progress = _totalCourseSets > 0
        ? (_completedCourseSets / _totalCourseSets).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E2127),
            Color(0xFF121316),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Glow / Watermark
          Positioned(
            right: -25,
            bottom: -25,
            child: Icon(
              Icons.fitness_center_rounded,
              size: 160,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag & Sparkle
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome,
                              color: AppColors.primary, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'زیرەکی دەستکرد & کۆرسی تایبەت',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (_hasCustomCourse)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: Color(0xFF10B981), size: 13),
                            const SizedBox(width: 4),
                            Text(
                              _customCourseSource.contains('وێنە')
                                  ? 'سکانکراو لە وێنە 📸'
                                  : 'دەستنووسی کەسی ✍️',
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),

                // Main Title
                const Text(
                  'کۆرسی ڕاهێنانی تایبەت بە خۆت دابنێ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'وێنەی وەرەقەی کۆرسەکەت دابنێ یاخود ناوی یارییەکان بە دەست بنووسە بۆ ئەوەی ڕاهێنانەکانت بە تەواوی ڕێکبخات!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),

                // Progress Bar if course exists
                if (_hasCustomCourse && _totalCourseSets > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ئاستی بەرەوپێشچوونی ئەمڕۆ: $_completedCourseSets لە $_totalCourseSets سێت',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // Action Buttons: 1. Upload Photo, 2. Write Manually
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: ElevatedButton.icon(
                        onPressed: _openCourseImportDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.add_a_photo_rounded, size: 18),
                        label: const Text(
                          'دانان یان نوسینی کۆرس',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _activeViewMode = 0;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.play_circle_fill_rounded,
                            size: 18, color: AppColors.accentGold),
                        label: const Text(
                          'یارییەکانم',
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
    );
  }

  // --- 2. Interactive Rest Timer Card ---
  Widget _buildRestTimerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            children: [
              // Circle Clock Display
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: AppColors.darkCardGradient,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isTimerRunning
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${_currentTimerSeconds}s',
                    style: TextStyle(
                      color:
                          _isTimerRunning ? AppColors.primary : Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_rounded,
                            color: AppColors.primary, size: 15),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'تایمەری پشووی نێوان سێتەکان',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.lightTextPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _isTimerRunning
                          ? 'پشوو وەربگرە و هەناسەی قووڵ هەڵمژە...'
                          : 'کاتەکەت هەڵبژێرە و سێتەکەت تەواو بکە',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Play/Pause Action
              ElevatedButton(
                onPressed: _isTimerRunning ? _resetTimer : _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTimerRunning
                      ? Colors.redAccent
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isTimerRunning
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isTimerRunning ? 'وەستاندن' : 'دەستپێکردن',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quick Seconds Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [30, 45, 60, 90, 120].map((seconds) {
              final isSelected = _selectedTimerDuration == seconds;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimerDuration = seconds;
                    if (!_isTimerRunning) {
                      _currentTimerSeconds = seconds;
                    }
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    '${seconds}s',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.lightTextSecondary,
                      fontSize: 11.5,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- 3. View Mode Toggle: My Course vs All Exercises ---
  Widget _buildViewModeToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Tab 0: My Course
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeViewMode = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      _activeViewMode == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _activeViewMode == 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      size: 18,
                      color: _activeViewMode == 0
                          ? AppColors.primary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'کۆرسەکەم (یارییەکانت)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: _activeViewMode == 0
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: _activeViewMode == 0
                            ? AppColors.lightTextPrimary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    if (_myCourseExercises.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _activeViewMode == 0
                              ? AppColors.primary
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_myCourseExercises.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // Tab 1: All Gym Exercises
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeViewMode = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      _activeViewMode == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _activeViewMode == 1
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.explore_rounded,
                      size: 18,
                      color: _activeViewMode == 1
                          ? AppColors.primary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'هەموو یارییەکان',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: _activeViewMode == 1
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: _activeViewMode == 1
                            ? AppColors.lightTextPrimary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4A. My Course Section: "ئەمانە یاریەکانتن!" ---
  Widget _buildMyCourseSection() {
    if (_myCourseExercises.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'هێشتا کۆرسی تایبەتت دانەناوە!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'وێنەی وەرەقەی کۆرسەکەت دابنێ یان بە دەست ناوی یارییەکان بنووسە بۆ ئەوەی ڕاستەوخۆ لێرە پیشانت بدات.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.lightTextSecondary,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _openCourseImportDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('دانانی کۆرس ئێستا'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Bar with "ئەمانە یاریەکانتن!"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFFD97706), size: 18),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ئەمانە یاریەکانتن! (Your Workout Course)',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'هەر سێتێک ئەنجام دەدەیت تیکی بکە بۆ تۆمارکردن',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: _openCourseImportDialog,
                icon: const Icon(Icons.edit_note_rounded, size: 16),
                label: const Text(
                  'گۆڕین',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Course Exercises List with interactive set checkmarks
        ..._myCourseExercises.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildMyCourseExerciseCard(index, item);
        }),

        // Add more exercise button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _activeViewMode = 1; // Go to All Exercises
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Center(
              child: Text(
                'زیادکردنی یارییەکی تر بۆ کۆرسەکەم',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Card for My Active Course with Checkmarks
  Widget _buildMyCourseExerciseCard(int index, Map<String, dynamic> item) {
    final setsCompleted =
        _exerciseSetsCompleted[item['id']] ?? [false, false, false, false];
    final allDone = setsCompleted.every((c) => c);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: allDone
              ? const Color(0xFF10B981).withValues(alpha: 0.5)
              : Colors.grey.shade200,
          width: allDone ? 1.5 : 1,
        ),
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
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openExerciseDetails(item),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise Image with numbering badge
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            item['image'] ?? 'assets/images/workout_back.jpg',
                            width: 78,
                            height: 78,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 78,
                              height: 78,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.fitness_center),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: allDone
                                  ? const Color(0xFF10B981)
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: allDone
                                  ? const Icon(Icons.check,
                                      size: 13, color: Colors.white)
                                  : Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Exercise Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.tagCardio,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['muscle'] ?? '',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                item['burn'] ?? '120 kcal',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['kurdish'] ?? item['title'],
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.repeat_rounded,
                                  size: 13, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                item['sets'] ?? '4 Sets × 12 Reps',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Quick Delete or Menu
                    IconButton(
                      icon: Icon(Icons.close_rounded,
                          size: 18, color: Colors.grey.shade400),
                      onPressed: () {
                        setState(() {
                          _myCourseExercises.removeAt(index);
                          _exerciseSetsCompleted.remove(item['id']);
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // Set Completion Interactive Checklist (Set 1, Set 2, Set 3, Set 4)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'تۆمارکردنی سێتەکان:',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: List.generate(setsCompleted.length, (sIdx) {
                        final isDone = setsCompleted[sIdx];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              setsCompleted[sIdx] = !setsCompleted[sIdx];
                              _exerciseSetsCompleted[item['id']] =
                                  setsCompleted;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? const Color(0xFF10B981)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDone
                                    ? const Color(0xFF10B981)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isDone) ...[
                                  const Icon(Icons.check,
                                      size: 11, color: Colors.white),
                                  const SizedBox(width: 3),
                                ],
                                Text(
                                  'سێتی ${sIdx + 1}',
                                  style: TextStyle(
                                    color: isDone
                                        ? Colors.white
                                        : AppColors.lightTextPrimary,
                                    fontSize: 10,
                                    fontWeight: isDone
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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

  // --- 4B. All Exercises Section ---
  Widget _buildAllExercisesSection() {
    final filtered = _masterExercises.where((item) {
      final matchesCategory = _selectedMuscleIndex == 0 ||
          item['muscleCategory'] == _muscles[_selectedMuscleIndex];
      final matchesSearch = _searchQuery.isEmpty ||
          item['title']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item['kurdish']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'گەڕان بەناو ناوی یارییەکان (سنگ، قاچ، دەمبڵ...)...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.primary, size: 20),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal Muscle Category Filters
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _muscles.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedMuscleIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMuscleIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.primary : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _muscles[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Result count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'لیستی هەموو یارییەکان (${filtered.length} ڕاهێنان)',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),

        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            child: const Text(
              'هیچ یارییەک نەدۆزرایەوە!',
              style: TextStyle(color: Colors.grey),
            ),
          ),

        ...filtered.map((item) => _buildLibraryExerciseCard(item)),
      ],
    );
  }

  // Card for All Gym Exercises with "+ زیادکردن بۆ کۆرس"
  Widget _buildLibraryExerciseCard(Map<String, dynamic> item) {
    final isInCourse = _myCourseExercises.any((ex) => ex['id'] == item['id']);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _openExerciseDetails(item),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                item['image'] ?? 'assets/images/workout_back.jpg',
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 76,
                  height: 76,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.fitness_center),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              onTap: () => _openExerciseDetails(item),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.tagCardio,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['muscle'] ?? '',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['kurdish'] ?? item['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['sets'] ?? '4 Sets × 12 Reps',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip:
                isInCourse ? 'لە ناو کۆرسەکەت دایە' : 'زیادکردن بۆ کۆرسەکەم',
            onPressed: () {
              setState(() {
                if (isInCourse) {
                  _myCourseExercises.removeWhere((ex) => ex['id'] == item['id']);
                  _exerciseSetsCompleted.remove(item['id']);
                } else {
                  _myCourseExercises.add(Map<String, dynamic>.from(item));
                  _exerciseSetsCompleted[item['id']] = [
                    false,
                    false,
                    false,
                    false
                  ];
                }
              });
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isInCourse
                    ? const Color(0xFF10B981)
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isInCourse ? Icons.check_rounded : Icons.add_rounded,
                color: isInCourse ? Colors.white : AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MODAL: Course Importer (Photo Scan & Manual Exercise Typing)
// ============================================================================
class _CourseImportBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> masterExercises;
  final Function(String title, String source,
      List<Map<String, dynamic>> exercises) onCourseGenerated;

  const _CourseImportBottomSheet({
    required this.masterExercises,
    required this.onCourseGenerated,
  });

  @override
  State<_CourseImportBottomSheet> createState() =>
      _CourseImportBottomSheetState();
}

class _CourseImportBottomSheetState extends State<_CourseImportBottomSheet>
    with SingleTickerProviderStateMixin {
  int _selectedMethodTab = 0; // 0 = Photo Upload, 1 = Manual Typing

  // Photo Scan State
  int _selectedSampleImageIndex = 0;
  bool _isScanning = false;
  String _scanStatusText = '';

  final List<Map<String, dynamic>> _sampleCourseSheets = [
    {
      'title': 'خشتەی کۆرسی سنگ و قۆڵ (کۆرسی دیاریکراو)',
      'coach': 'ڕاهێنەر بیلال',
      'image': 'assets/images/workout_back.jpg',
      'detected': [
        'Barbell Bench Press',
        'Incline Dumbbell Press',
        'Cable Chest Fly',
        'Standing Dumbbell Bicep Curls',
        'Tricep Rope Pushdown',
      ],
    },
    {
      'title': 'کۆرسی قاچ، سمت و سک (شێپین)',
      'coach': 'ڕاهێنەر لانە',
      'image': 'assets/images/female_fitness_banner.jpg',
      'detected': [
        'Barbell Back Squat',
        'Barbell Hip Thrust',
        '45-Degree Leg Press',
        'Plank Core Stabilization',
        'Hanging Knee / Leg Raise',
      ],
    },
    {
      'title': 'کۆرسی پشت و شان (فول ستڕێنگس)',
      'coach': 'ڕاهێنەر شوان',
      'image': 'assets/images/pullup_figure.jpg',
      'detected': [
        'Wide-Grip Pull Ups',
        'Lat Pulldown',
        'Seated Cable Row',
        'Overhead Barbell Shoulder Press',
        'Dumbbell Lateral Raise',
      ],
    },
  ];

  // Manual Typing State
  final TextEditingController _courseNameController =
      TextEditingController(text: 'کۆرسی نوێی من');
  final TextEditingController _customExerciseController =
      TextEditingController();
  final List<String> _manualExerciseList = [];

  final List<String> _quickSuggestions = [
    'بێنچ پرێس بە باربێڵ',
    'پرێسی سنگ بە دەمبڵی لار',
    'کەیبڵ فلای بۆ سنگ',
    'سکوات بە باربێڵ',
    'هیپ ترەست بە باربێڵ',
    'پول ئەپس بە گرتنی پان',
    'لات پولداون',
    'کێرڵی دەمبڵ بۆ بایسێپس',
    'تڕایسێپس بە حەبل',
    'پرێسی شان بە باربێڵ',
    'پلانک بۆ سک',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate manual list with 2 popular suggestions
    _manualExerciseList.add('بێنچ پرێس بە باربێڵ');
    _manualExerciseList.add('پرێسی سنگ بە دەمبڵی لار');
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _customExerciseController.dispose();
    super.dispose();
  }

  // AI Photo Scanning Simulation
  void _startPhotoScan() async {
    setState(() {
      _isScanning = true;
      _scanStatusText = 'خوێندنەوە و سکانکردنی وێنەی وەرەقەی کۆرسەکەت... 🔍';
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _scanStatusText =
          'ناسینەوەی خشتەی ڕاهێنان و ناوی یارییەکان بە ژیری دەستکرد... ⚡';
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    final selectedSheet = _sampleCourseSheets[_selectedSampleImageIndex];
    final detectedNames = selectedSheet['detected'] as List<String>;

    // Match detected names with master exercises
    final List<Map<String, dynamic>> matchedExercises = [];
    for (var name in detectedNames) {
      final found = widget.masterExercises.firstWhere(
        (ex) => ex['title'] == name,
        orElse: () => widget.masterExercises.first,
      );
      matchedExercises.add(Map<String, dynamic>.from(found));
    }

    setState(() {
      _isScanning = false;
    });

    Navigator.pop(context);
    widget.onCourseGenerated(
      selectedSheet['title'],
      'وێنەی کۆرس (سکانکراو)',
      matchedExercises,
    );
  }

  // Manual Typing Generator
  void _submitManualExercises() {
    if (_manualExerciseList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تکایە لانیکەم ناوی یەک یاری بنووسە یان هەڵبژێرە')),
      );
      return;
    }

    final List<Map<String, dynamic>> matchedExercises = [];
    for (var typed in _manualExerciseList) {
      // Find closest match or create custom entry
      final found = widget.masterExercises.firstWhere(
        (ex) {
          final kurdish = ex['kurdish'].toString().toLowerCase();
          final title = ex['title'].toString().toLowerCase();
          final q = typed.toLowerCase();
          return kurdish.contains(q) ||
              title.contains(q) ||
              q.contains(kurdish);
        },
        orElse: () => {
          'id': 'custom_${DateTime.now().millisecondsSinceEpoch}_${typed.hashCode}',
          'title': typed,
          'kurdish': typed,
          'muscle': 'ڕاهێنانی کەسی',
          'muscleCategory': 'هەموو بەشەکان',
          'sets': '4 Sets × 12 Reps',
          'burn': '120 kcal',
          'image': 'assets/images/workout_back.jpg',
          'instructions': 'ئەم یارییە لەلایەن خۆتەوە بە دەستنووس زیادکراوە.',
        },
      );
      matchedExercises.add(Map<String, dynamic>.from(found));
    }

    Navigator.pop(context);
    widget.onCourseGenerated(
      _courseNameController.text.trim().isEmpty
          ? 'کۆرسی کەسی من'
          : _courseNameController.text.trim(),
      'دەستنووسی کەسی (Manual Input)',
      matchedExercises,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Top drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_task_rounded,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'دانانی کۆرسی ڕاهێنانەکەت',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'وێنەی خشتەکەت دابنێ یان بە دەست یارییەکان بنووسە',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.lightTextSecondary,
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
          ),
          const Divider(height: 1),

          // Two Method Segment Switcher
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Option 1: Course Picture
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMethodTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedMethodTab == 0
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedMethodTab == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 6,
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: 17,
                            color: _selectedMethodTab == 0
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'دانانی وێنەی کۆرس',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: _selectedMethodTab == 0
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _selectedMethodTab == 0
                                  ? AppColors.lightTextPrimary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Option 2: Write Manually
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMethodTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedMethodTab == 1
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedMethodTab == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 6,
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            size: 19,
                            color: _selectedMethodTab == 1
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'نوسینی یارییەکان بە دەست',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: _selectedMethodTab == 1
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _selectedMethodTab == 1
                                  ? AppColors.lightTextPrimary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content body
          Expanded(
            child: _selectedMethodTab == 0
                ? _buildPhotoScanView()
                : _buildManualTypingView(),
          ),
        ],
      ),
    );
  }

  // --- VIEW 1: Photo Upload & AI Scan ---
  Widget _buildPhotoScanView() {
    final current = _sampleCourseSheets[_selectedSampleImageIndex];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Camera / Upload Action Box
        GestureDetector(
          onTap: () {
            // Cycle sample course image or trigger scan
            setState(() {
              _selectedSampleImageIndex =
                  (_selectedSampleImageIndex + 1) % _sampleCourseSheets.length;
            });
          },
          child: Container(
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 1.5,
              ),
              image: DecorationImage(
                image: AssetImage(current['image']),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.45),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Scan animation beam if scanning
                if (_isScanning)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                    ),
                  ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.photo_camera_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        current['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'کلیک لێرە بکە بۆ هەڵبژاردنی وێنەی تر 🔄',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Detected Preview
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.document_scanner_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  const Text(
                    'یارییە ناسراوەکانی ناو ئەم وێنەیە:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(current['detected'] as List).length} یاری',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: (current['detected'] as List<String>).map((name) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      '• $name',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        if (_isScanning) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                _scanStatusText,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 24),

        // Action Button: Extract & Set Course
        ElevatedButton.icon(
          onPressed: _isScanning ? null : _startPhotoScan,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.bolt_rounded),
          label: const Text(
            'دەرهێنانی یارییەکان لە وێنەکە & دانانی کۆرس',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // --- VIEW 2: Manual Exercise Names Typing ---
  Widget _buildManualTypingView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // 1. Course Name Input
        const Text(
          'ناوی کۆرسەکەت (Course Title):',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _courseNameController,
          decoration: InputDecoration(
            hintText: 'نموونە: کۆرسی ڕۆژی پێنجشەممە (سنگ و تڕای)',
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 2. Type Exercise Name & Add button
        const Text(
          'ناوی یارییەکەت بنووسە و زەختی لەسەر بکە:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customExerciseController,
                decoration: InputDecoration(
                  hintText: 'ناوی یاری (بێنچ، سکوات، دەمبڵ، حەبل...)',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    setState(() {
                      _manualExerciseList.add(val.trim());
                      _customExerciseController.clear();
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final text = _customExerciseController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _manualExerciseList.add(text);
                    _customExerciseController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('زیادکردن',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Quick Suggestion Chips
        const Text(
          'یان لەم یارییە باوانە دەستنیشان بکە:',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _quickSuggestions.map((sug) {
            return ActionChip(
              label: Text(sug, style: const TextStyle(fontSize: 11)),
              backgroundColor: Colors.grey.shade100,
              side: BorderSide(color: Colors.grey.shade300),
              onPressed: () {
                if (!_manualExerciseList.contains(sug)) {
                  setState(() {
                    _manualExerciseList.add(sug);
                  });
                }
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // List of manually selected exercises
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'یارییە تۆمارکراوەکانی کۆرسەکەت:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                  Text(
                    '${_manualExerciseList.length} یاری',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_manualExerciseList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'هیچ یارییەک زیاد نەکراوە. ناوی یارییەک بنووسە لە سەرەوە.',
                    style: TextStyle(color: Colors.grey, fontSize: 11.5),
                  ),
                ),
              ..._manualExerciseList.asMap().entries.map((entry) {
                final idx = entry.key;
                final name = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${idx + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            size: 18, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _manualExerciseList.removeAt(idx);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Confirm & Show "ئەمانە یاریەکانتن!"
        ElevatedButton.icon(
          onPressed: _submitManualExercises,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: const Text(
            'ئامادەکردنی کۆرس و دەرهێنانی یارییەکان',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ============================================================================
// MODAL: Exercise Detail & Guide Sheet
// ============================================================================
class _ExerciseDetailModal extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onStartTimer;

  const _ExerciseDetailModal({
    required this.exercise,
    required this.onStartTimer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                // Exercise Image Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    exercise['image'] ?? 'assets/images/workout_back.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // Title & Kurdish Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.tagCardio,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              exercise['muscle'] ?? '',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            exercise['kurdish'] ?? exercise['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            exercise['title'],
                            style: TextStyle(
                              fontSize: 13,
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

                const SizedBox(height: 16),

                // Stat Cards
                Row(
                  children: [
                    _buildStatPill(
                      Icons.repeat_rounded,
                      'سێت و دووبارە',
                      exercise['sets'] ?? '4 Sets × 12',
                    ),
                    const SizedBox(width: 10),
                    _buildStatPill(
                      Icons.local_fire_department_rounded,
                      'سووتاندنی کالۆری',
                      exercise['burn'] ?? '120 kcal',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Instructions in Kurdish
                const Text(
                  'ڕێنمایی و چۆنیەتی ئەنجامدان:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    exercise['instructions'] ??
                        'ئەم یارییە بە تەکنیکی دروست و هێواش ئەنجام بدە بۆ بەدەستهێنانی باشترین ئەنجام.',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ),

                if (exercise['mistake'] != null) ...[
                  const SizedBox(height: 14),
                  const Text(
                    'هەڵە باوەکان کە دەبێت لێیان دووربکەویتەوە:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            exercise['mistake'],
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Bottom CTA: Start Rest Timer
                ElevatedButton.icon(
                  onPressed: onStartTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.timer_rounded),
                  label: const Text(
                    'تەواوم کرد! کاتی پشوودان لێبدە',
                    style: TextStyle(
                      fontSize: 14,
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

  Widget _buildStatPill(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
}
