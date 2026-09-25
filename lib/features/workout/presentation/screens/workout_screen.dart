import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // Navigation tabs: 0 = My Course (کۆرسەکەم), 1 = All Exercises & Videos (هەموو یارییەکان)
  int _activeTab = 0;

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

  // Master Exercise Database with Video Info & Technique
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
      'videoDuration': '0:45',
      'videoQuality': '1080p HD',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'لەسەر بێنچەکە پاڵبکەوە، باربێڵەکە بە فراوانی شانت کەمێک زیاتر بگرە. بە هێواشی بیهێنە خوارەوە تا دەگاتە سەرووی سنگت و پاشان بە تەقینەوە و هێزەوە بیبە سەرەوە بەبێ قفڵکردنی تەواوی ئەنیشک.',
      'mistake': 'بەرزکردنەوەی سمت لەسەر بێنچەکە یان خێرا بەرپەرچدانەوەی بار لەسەر سنگ.',
      'breathing': 'لەکاتی هێنانە خوارەوە هەناسە هەڵمژە، لەکاتی بردنە سەرەوە بەهێز بیدەرەوە.',
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
      'videoDuration': '0:40',
      'videoQuality': '1080p HD',
      'image': 'assets/images/onboarding_athlete.jpg',
      'instructions':
          'بێنچەکە لەسەر گۆشەی ٣٠ بۆ ٤٥ پلە ڕێکبخە. دەمبڵەکان بەرەو سەرەوە بەرز بکەرەوە و لە بەرزترین خاڵدا کەمێک فشار بخەرە سەر بەشی سەرەوەی سنگت.',
      'mistake': 'دانانی گۆشەی کورسی زۆر بەرز کە وا دەکات فشارەکە بچێتە سەر شان.',
      'breathing': 'هێنانە خوارەوە: هەڵمژین، سەرکەوتن: دانەوە.',
      'keywords': ['incline', 'dumbbell', 'دەمبڵ', 'لار', 'سنگ', 'سەرەوە'],
    },
    {
      'id': 'cable_fly',
      'title': 'Cable Chest Fly',
      'kurdish': 'کەیبڵ فلای بۆ سنگ',
      'muscle': 'ناوەڕاست و خوارەوەی سنگ',
      'muscleCategory': 'سنگ (Chest)',
      'sets': '3 Sets × 15 Reps',
      'level': 'سەرەتایی',
      'burn': '95 kcal',
      'equipment': 'Cable Crossover Machine',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/card_gym_full.png',
      'instructions':
          'دەستەکان بە شێوەی کەوانەیی بەرەو پێشەوە بهێنە. لە خاڵی کۆتاییدا بۆ ماوەی ١ چرکە سنگت توند بگرە و ئەنیشکت کەمێک چەماوە ڕابگرە.',
      'mistake': 'ڕاستکردنەوەی تەواوی دەست کە فشاری مەترسیدار دەخاتە سەر ئەنیشک.',
      'breathing': 'پێشەوە بردن: هەناسەدانەوە، گەڕانەوە: هەناسە هەڵمژین.',
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
      'videoDuration': '0:50',
      'videoQuality': '4K Ultra',
      'image': 'assets/images/pullup_figure.jpg',
      'instructions':
          'بارەکە پانتر لە شانت بگرە. سنگت بەرز بکەرەوە بەرەو بارەکە تا چەناگەت دەگاتە سەرووی بار، پاشان بە هێواشی و بە کۆنترۆڵ بگەڕێوە خوارەوە.',
      'mistake': 'شەپۆلدان و جوڵاندنی قاچەکان بۆ دروستکردنی زەبر.',
      'breathing': 'سەرکەوتن: دانەوە، دابەزین: هەڵمژین.',
      'keywords': ['pull', 'up', 'پول', 'ئەپ', 'پشت', 'باڵ', 'back'],
    },
    {
      'id': 'lat_pulldown',
      'title': 'Lat Pulldown',
      'kurdish': 'لات پولداون بە دانیشتن',
      'muscle': 'پشت و پانکردنی باڵ',
      'muscleCategory': 'پشت (Back)',
      'sets': '4 Sets × 12 Reps',
      'level': 'سەرەتایی',
      'burn': '110 kcal',
      'equipment': 'Cable Pulldown Machine',
      'videoDuration': '0:42',
      'videoQuality': '1080p HD',
      'image': 'assets/images/pullup_figure.jpg',
      'instructions':
          'بارەکە بە فراوانی بگرە و کەمێک پشتت بەرەو دواوە لار بکەرەوە. بارەکە بهێنە خوارەوە بۆ سەرووی سنگت و ماسولکەکانی پشتت تەواو توند بکە.',
      'mistake': 'ڕاکێشانی بار بۆ پشتی مل کە زۆر مەترسیدارە بۆ بڕبڕەی مل.',
      'breathing': 'ڕاکێشان: هەناسەدانەوە، سەرکەوتن: هەناسە هەڵمژین.',
      'keywords': ['lat', 'pulldown', 'پولداون', 'لات', 'پشت', 'کێشان'],
    },
    {
      'id': 'barbell_row',
      'title': 'Bent-Over Barbell Row',
      'kurdish': 'ڕاکێشانی باربێڵ بە دانەواندنەوە',
      'muscle': 'ناوەڕاستی پشت و ستوونی فەقەرات',
      'muscleCategory': 'پشت (Back)',
      'sets': '4 Sets × 10 Reps',
      'level': 'پێشکەوتوو',
      'burn': '150 kcal',
      'equipment': 'Barbell & Plates',
      'videoDuration': '0:45',
      'videoQuality': '1080p HD',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'ئەژنۆت کەمێک بچەمێنەرەوە و پشتت لەسەر گۆشەی ٤٥ پلە ڕێک ڕابگرە. بارەکە ڕابکێشە بۆ ناوک بە ڕاکێشانی ئەنیشکەکانت بەرەو دواوە.',
      'mistake': 'خوارکردنی بڕبڕەی پشت و دروستکردنی پەستان لەسەر کەمەر.',
      'breathing': 'ڕاکێشان: هەناسەدانەوە، بەرەو خوار: هەڵمژین.',
      'keywords': ['row', 'ڕاو', 'باربێڵ', 'پشت'],
    },
    {
      'id': 'overhead_press',
      'title': 'Overhead Barbell Military Press',
      'kurdish': 'پرێسی شانی سەربازی بە باربێڵ',
      'muscle': 'شانی پێشەوە و ناوەڕاست',
      'muscleCategory': 'شان (Shoulders)',
      'sets': '4 Sets × 10 Reps',
      'level': 'پێشکەوتوو',
      'burn': '135 kcal',
      'equipment': 'Barbell & Squat Rack',
      'videoDuration': '0:45',
      'videoQuality': '1080p HD',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'بە پێوە بوەستە، سک و کەمەرت توند بکە. بارەکە لەسەر ئاستی سەرەوەی سنگتەوە بەرەو سەرووی سەر بەرز بکەرەوە تا دەستەکانت ڕاست دەبنەوە.',
      'mistake': 'بردنە دواوەی زۆری کەمەر و بەکارهێنانی قاچ بۆ هاوێشتن.',
      'breathing': 'سەرکەوتن: هەناسەدانەوە، دابەزین: هەڵمژین.',
      'keywords': ['overhead', 'press', 'شان', 'سەربازی', 'باربێڵ'],
    },
    {
      'id': 'lateral_raise',
      'title': 'Dumbbell Lateral Raise',
      'kurdish': 'کردنەوەی شان بە دەمبڵ بۆ لاکان',
      'muscle': 'شانی ناوەڕاست (تۆپکردنی شان)',
      'muscleCategory': 'شان (Shoulders)',
      'sets': '4 Sets × 15 Reps',
      'level': 'مامناوەند',
      'burn': '90 kcal',
      'equipment': 'Dumbbells',
      'videoDuration': '0:30',
      'videoQuality': '1080p HD',
      'image': 'assets/images/splash_athlete.jpg',
      'instructions':
          'دەمبڵەکان لە تەنیشت ڕانتەوە بەرز بکەرەوە تا ئاستی شانت بە شێوەیەکی کەمێک کەوانەیی، ئەنیشکت کەمێک چەماوە بێت.',
      'mistake': 'بەرزکردنەوەی دەمبڵەکان بە زەبری لەش و لاربوونەوە.',
      'breathing': 'بەرزکردنەوە: هەناسەدانەوە، هێنانە خوارەوە: هەڵمژین.',
      'keywords': ['lateral', 'raise', 'شان', 'لاکان', 'دەمبڵ'],
    },
    {
      'id': 'bicep_curl',
      'title': 'Standing Barbell Bicep Curl',
      'kurdish': 'بایسێپس بە باربێڵ بە پێوە',
      'muscle': 'بازوو (Biceps)',
      'muscleCategory': 'باڵ و بازوو (Arms)',
      'sets': '4 Sets × 12 Reps',
      'level': 'سەرەتایی',
      'burn': '100 kcal',
      'equipment': 'EZ Bar or Straight Bar',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/splash_athlete.jpg',
      'instructions':
          'بە پێوە بوەستە و ئەنیشکەکانت لە تەنیشت کەمەرت بچەسپێنە. بارەکە بەرەو سەرەوە بەرز بکەرەوە تەنها بە جوڵاندنی پێشەدەست.',
      'mistake': 'جوڵاندنی ئەنیشک بەرەو پێشەوە یان بەکارهێنانی کەمەر.',
      'breathing': 'سەرکەوتن: هەناسەدانەوە، دابەزین: هەڵمژین.',
      'keywords': ['bicep', 'curl', 'بایسێپس', 'بازوو', 'باربێڵ'],
    },
    {
      'id': 'tricep_rope',
      'title': 'Tricep Rope Pushdown',
      'kurdish': 'تڕایسێپس بە کێبڵ و پەت',
      'muscle': 'پشتی باڵ (Triceps)',
      'muscleCategory': 'باڵ و بازوو (Arms)',
      'sets': '4 Sets × 15 Reps',
      'level': 'سەرەتایی',
      'burn': '95 kcal',
      'equipment': 'Cable & Rope Attachment',
      'videoDuration': '0:32',
      'videoQuality': '1080p HD',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'پەتەکە ڕابکێشە بەرەو خوارەوە، لە کۆتایی جوڵەکەدا سەرەکانی پەتەکە لە یەکتر جیا بکەرەوە بۆ تەواو توندکردنی تڕایسێپس.',
      'mistake': 'جوڵاندنی ئەنیشکەکان لە کاتی کێشان.',
      'breathing': 'خوارەوە: هەناسەدانەوە، سەرەوە: هەڵمژین.',
      'keywords': ['tricep', 'rope', 'تڕایسێپس', 'پەت', 'کەیبڵ'],
    },
    {
      'id': 'barbell_squat',
      'title': 'Barbell Back Squat',
      'kurdish': 'سکوات بە باربێڵ لەسەر پشت',
      'muscle': 'ڕان و سمت (Quads & Glutes)',
      'muscleCategory': 'قاچ و سمت (Legs)',
      'sets': '4 Sets × 8-10 Reps',
      'level': 'پێشکەوتوو',
      'burn': '190 kcal',
      'equipment': 'Squat Rack & Barbell',
      'videoDuration': '0:55',
      'videoQuality': '4K Ultra',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'پێیەکانت بە پانی شانت بکەرەوە. دابەزە وەک ئەوەی لەسەر کورسی دابنیشیت، تا ئەژنۆت دەگاتە گۆشەی ٩٠ پلە یان کەمتر، پاشان پاڵ بنێ.',
      'mistake': 'هاتنە پێشەوەی زۆری ئەژنۆکان یان چەمانەوەی بڕبڕەی پشت.',
      'breathing': 'دابەزین: هەڵمژینی قووڵ، سەرکەوتن: بەهێز دانەوە.',
      'keywords': ['squat', 'سکوات', 'قاچ', 'ڕان', 'سمت'],
    },
    {
      'id': 'leg_press',
      'title': '45-Degree Leg Press',
      'kurdish': 'لێگ پرێس لەسەر ئامێری ٤٥ پلە',
      'muscle': 'چوارسەری ڕان و سمت',
      'muscleCategory': 'قاچ و سمت (Legs)',
      'sets': '4 Sets × 12 Reps',
      'level': 'مامناوەند',
      'burn': '145 kcal',
      'equipment': 'Leg Press Machine',
      'videoDuration': '0:40',
      'videoQuality': '1080p HD',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'پێیەکانت لە ناوەڕاستی سەکۆکە دابنێ. کێشەکە بهێنە خوارەوە بە کۆنترۆڵ، بەبێ ئەوەی ئەنیشکی ئەژنۆ لە کاتی بەرزکردنەوەدا قفڵ بکەیت.',
      'mistake': 'قفڵکردنی تەواوی ئەژنۆ کە فشارێکی زۆر دەخاتە سەر بەستەرەکان.',
      'breathing': 'خوارەوە: هەڵمژین، بردنە سەرەوە: دانەوە.',
      'keywords': ['leg', 'press', 'لێگ', 'پرێس', 'قاچ'],
    },
    {
      'id': 'plank_core',
      'title': 'Core Plank to Pike',
      'kurdish': 'پلانک و ڕاکێشانی ناوەند بۆ سک',
      'muscle': 'ماسولکە قووڵەکانی سک و ناوەند',
      'muscleCategory': 'سک و ناوەند (Core)',
      'sets': '3 Sets × 45 Sec',
      'level': 'سەرەتایی',
      'burn': '80 kcal',
      'equipment': 'Yoga Mat',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/posture_dark_3d.jpg',
      'instructions':
          'لەسەر پێشەدەستەکانت ڕابوەستە و تەواوی لەشت وەک تەختە لە یەک هێڵدا ڕابگرە. کەمەرت توند بکە و لەشت شۆڕ مەکەرەوە.',
      'mistake': 'بەرزکردنەوەی زۆری سمت یان شۆڕکردنەوەی کەمەر بەرەو زەوی.',
      'breathing': 'هەناسەدانی هێواش و بەردەوام بەبێ ڕاگرتنی هەناسە.',
      'keywords': ['plank', 'core', 'پلانک', 'سک', 'ناوەند'],
    },
  ];

  // Active User Course Exercises
  late List<Map<String, dynamic>> _myCourseExercises;

  // Track completion of sets for each exercise: [Set 1, Set 2, Set 3, Set 4]
  final Map<String, List<bool>> _exerciseSetsCompleted = {};

  @override
  void initState() {
    super.initState();
    // Default course: First 4 exercises
    _myCourseExercises = [
      Map<String, dynamic>.from(_masterExercises[0]),
      Map<String, dynamic>.from(_masterExercises[1]),
      Map<String, dynamic>.from(_masterExercises[2]),
      Map<String, dynamic>.from(_masterExercises[9]),
    ];

    for (final ex in _myCourseExercises) {
      _exerciseSetsCompleted[ex['id']] = [false, false, false, false];
    }
    // Set 1 and 2 done for first exercise as a showcase
    _exerciseSetsCompleted['bench_press'] = [true, true, false, false];
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Rest Timer Controller
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = true;
      _currentTimerSeconds = _selectedTimerDuration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimerSeconds > 0) {
        setState(() => _currentTimerSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isTimerRunning = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.alarm_on_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'کاتی پشوودان تەواو بوو! کاتی دەستپێکردنی سێتی داهاتووە 💪',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              duration: const Duration(seconds: 4),
            ),
          );
        }
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

  // Open Video & Exercise Technique Modal
  void _openExerciseVideoDetail(Map<String, dynamic> exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ExerciseVideoModal(
        exercise: exercise,
        onStartTimer: () {
          Navigator.pop(context);
          _startTimer();
        },
        onAddToCourse: () {
          Navigator.pop(context);
          _addExerciseToCourse(exercise);
        },
        isAlreadyInCourse: _myCourseExercises.any((e) => e['id'] == exercise['id']),
      ),
    );
  }

  // Add exercise to active course
  void _addExerciseToCourse(Map<String, dynamic> exercise) {
    final exists = _myCourseExercises.any((e) => e['id'] == exercise['id']);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ئەم یارییە پێشتر لە کۆرسەکەتدا بوونی هەیە: ${exercise['kurdish']}'),
          backgroundColor: Colors.orange.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _myCourseExercises.add(Map<String, dynamic>.from(exercise));
      _exerciseSetsCompleted[exercise['id']] = [false, false, false, false];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text('یارییەکە زیادکرا بۆ کۆرسەکەت: ${exercise['kurdish']}'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Course Importer Bottom Sheet (Photo Scan & Manual Builder)
  void _openCourseImporterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CourseImporterModal(
        masterExercises: _masterExercises,
        onCourseImported: (List<Map<String, dynamic>> newCourse) {
          setState(() {
            _myCourseExercises = newCourse;
            for (final ex in _myCourseExercises) {
              _exerciseSetsCompleted.putIfAbsent(
                ex['id'],
                () => [false, false, false, false],
              );
            }
            _activeTab = 0;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          // 1. HERO BANNER: Course Importer & Quick Setup
          _buildCourseHeroCard(),

          const SizedBox(height: 14),

          // 2. Responsive Smart Rest Timer Card (Never Overflows)
          _buildRestTimerCard(),

          const SizedBox(height: 16),

          // 3. Tab Switcher: "کۆرسەکەم (My Course)" vs "ڤیدیۆ و هەموو یارییەکان (Videos & Library)"
          _buildViewModeToggle(),

          const SizedBox(height: 14),

          // 4. Tab Content
          if (_activeTab == 0)
            _buildMyCourseSection()
          else
            _buildAllExercisesSection(),
        ],
      ),
    );
  }

  // --- APP BAR ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: const Column(
        children: [
          Text(
            'Workout Hub • ڕاهێنان',
            style: TextStyle(
              color: Color(0xFF131519),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 1),
          Text(
            'کۆرسی چالاک: ڕاهێنانی تایبەتی خۆت بە ڤیدیۆ',
            style: TextStyle(
              color: Color(0xFF757A86),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'سکانکردنی کۆرس',
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 20),
          ),
          onPressed: _openCourseImporterSheet,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // --- 1. HERO BANNER: COURSE IMPORTER ---
  Widget _buildCourseHeroCard() {
    final totalExercises = _myCourseExercises.length;
    int completedExercises = 0;
    for (final ex in _myCourseExercises) {
      final sets = _exerciseSetsCompleted[ex['id']] ?? [];
      if (sets.isNotEmpty && sets.every((done) => done)) {
        completedExercises++;
      }
    }
    final progress = totalExercises > 0 ? (completedExercises / totalExercises) : 0.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF131519),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle accent glow
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.18),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tags Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: const Text(
                        'کۆرسی دەستکرد و زیرەک',
                        style: TextStyle(
                          color: Color(0xFFFFB74D),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 13),
                          SizedBox(width: 4),
                          Text(
                            'سکان یان نوسین',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Main Heading
                const Text(
                  'کۆرسی ڕاهێنانی تایبەت بە خۆت دابنێ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'وێنەی وەرەقەی کۆرسەکەت دابنێ یاخود ناوی یارییەکان بنووسە بۆ ئەوەی ڕاهێنانەکانت بە تەواوی ڤیدیۆوە ڕێکبخات.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),

                // Workout Progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ئاستی بەرەوپێشچوون: $completedExercises لە $totalExercises یاری تەواوە',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Color(0xFFFFB74D),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 18),

                // Action Buttons Row
                Row(
                  children: [
                    // Upload / Manual Builder Button
                    Expanded(
                      flex: 6,
                      child: ElevatedButton.icon(
                        onPressed: _openCourseImporterSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.photo_camera_rounded, size: 18),
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

                    // Switch to All Exercises / Videos
                    Expanded(
                      flex: 4,
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _activeTab = 1),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.play_circle_fill_rounded,
                            color: Color(0xFFFFB74D), size: 18),
                        label: const Text(
                          'ڤیدیۆکان',
                          style: TextStyle(
                            fontSize: 12.5,
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

  // --- 2. RESPONSIVE SMART REST TIMER (ZERO OVERFLOW) ---
  Widget _buildRestTimerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EBF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Timer Circle + Text + Start/Pause Button
          Row(
            children: [
              // Circle Countdown Indicator
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _isTimerRunning ? const Color(0xFF131519) : const Color(0xFFF1F3F6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isTimerRunning ? AppColors.primary : Colors.grey.shade300,
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${_currentTimerSeconds}s',
                    style: TextStyle(
                      color: _isTimerRunning ? AppColors.primary : const Color(0xFF131519),
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and Subtitle with Flexible protection
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تایمەری پشووی نێوان سێتەکان',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF131519),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isTimerRunning
                          ? 'پشوو وەربگرە و هەناسەی قووڵ هەڵمژە...'
                          : 'کات هەڵبژێرە و دەست بە پشوو بکە',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Play / Stop Action Button
              ElevatedButton(
                onPressed: _isTimerRunning ? _resetTimer : _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTimerRunning ? Colors.redAccent : AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isTimerRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      size: 17,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      _isTimerRunning ? 'وەستاندن' : 'دەستپێکردن',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEF1F5)),
          const SizedBox(height: 10),

          // Duration Selector Pills: 30s, 45s, 60s, 90s, 120s
          Row(
            children: [30, 45, 60, 90, 120].map((sec) {
              final isSelected = _selectedTimerDuration == sec;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTimerDuration = sec;
                      if (!_isTimerRunning) {
                        _currentTimerSeconds = sec;
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : const Color(0xFFF4F6F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${sec}s',
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : const Color(0xFF5A606D),
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                        ),
                      ),
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

  // --- 3. DUAL TABS SWITCHER ---
  Widget _buildViewModeToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EBF0)),
      ),
      child: Row(
        children: [
          // Tab 0: My Course
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _activeTab == 0 ? const Color(0xFF131519) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center_rounded,
                      size: 15,
                      color: _activeTab == 0 ? Colors.white : const Color(0xFF676E7D),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'کۆرسەکەم (${_myCourseExercises.length})',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: _activeTab == 0 ? FontWeight.bold : FontWeight.w600,
                        color: _activeTab == 0 ? Colors.white : const Color(0xFF676E7D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab 1: Video Library & All Exercises
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _activeTab == 1 ? const Color(0xFF131519) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 16,
                      color: _activeTab == 1 ? Colors.white : const Color(0xFF676E7D),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ڤیدیۆ و یارییەکان',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: _activeTab == 1 ? FontWeight.bold : FontWeight.w600,
                        color: _activeTab == 1 ? Colors.white : const Color(0xFF676E7D),
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

  // --- 4. MY ACTIVE COURSE SECTION ---
  Widget _buildMyCourseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'ئەم یارییانە لە کۆرسەکەتن',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF131519),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: _openCourseImporterSheet,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.edit_note_rounded, size: 18),
                label: const Text(
                  'دەستکاری / نوێکردنەوە',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        if (_myCourseExercises.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8EBF0)),
            ),
            child: Column(
              children: [
                const Icon(Icons.fitness_center_rounded, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'هیچ یارییەک لە کۆرسەکەت نییە',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'وێنەی وەرەقەی کۆرسەکەت سکان بکە یان لە بەشی خوارەوە یاری زیادبکە.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _openCourseImporterSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('دروستکردنی کۆرس'),
                ),
              ],
            ),
          )
        else
          ..._myCourseExercises.asMap().entries.map(
                (entry) => _buildCourseExerciseCard(entry.key, entry.value),
              ),
      ],
    );
  }

  // Course Exercise Card with Video Player Badge & Set Trackers
  Widget _buildCourseExerciseCard(int index, Map<String, dynamic> item) {
    final setsCompleted =
        _exerciseSetsCompleted[item['id']] ?? [false, false, false, false];
    final allDone = setsCompleted.every((c) => c);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: allDone ? const Color(0xFF10B981) : const Color(0xFFE8EBF0),
          width: allDone ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _openExerciseVideoDetail(item),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise Image with Video Badge & Number
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            item['image'] ?? 'assets/images/workout_back.jpg',
                            width: 86,
                            height: 86,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 86,
                              height: 86,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.fitness_center),
                            ),
                          ),
                        ),
                        // Number Circle Badge
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: allDone ? const Color(0xFF10B981) : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: allDone
                                  ? const Icon(Icons.check, size: 13, color: Colors.white)
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
                        // VIDEO BADGE ON THUMBNAIL
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
                                SizedBox(width: 2),
                                Text(
                                  'ڤیدیۆ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Title & Specs
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
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
                          const SizedBox(height: 5),
                          Text(
                            item['kurdish'] ?? item['title'],
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF131519),
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
                              Icon(Icons.repeat_rounded, size: 13, color: Colors.grey.shade600),
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

                    // Quick Delete from course
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade400),
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
                const Divider(height: 1, color: Color(0xFFEEF1F5)),
                const SizedBox(height: 8),

                // Set Completion Interactive Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'تۆمارکردنی سێتەکان:',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF757A86),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: List.generate(setsCompleted.length, (sIdx) {
                        final isDone = setsCompleted[sIdx];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              setsCompleted[sIdx] = !isDone;
                              _exerciseSetsCompleted[item['id']] = setsCompleted;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDone ? const Color(0xFF10B981) : const Color(0xFFF1F3F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isDone)
                                  const Icon(Icons.check, size: 12, color: Colors.white)
                                else
                                  const SizedBox.shrink(),
                                if (isDone) const SizedBox(width: 3),
                                Text(
                                  'سێتی ${sIdx + 1}',
                                  style: TextStyle(
                                    color: isDone ? Colors.white : const Color(0xFF4A4E5A),
                                    fontSize: 10.5,
                                    fontWeight: isDone ? FontWeight.bold : FontWeight.w600,
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

  // --- 5. ALL EXERCISES & VIDEO LIBRARY ---
  Widget _buildAllExercisesSection() {
    final filtered = _masterExercises.where((item) {
      // Muscle filter
      if (_selectedMuscleIndex > 0) {
        final selectedCat = _muscles[_selectedMuscleIndex];
        if (item['muscleCategory'] != selectedCat) return false;
      }
      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final kurd = (item['kurdish'] as String).toLowerCase();
        final eng = (item['title'] as String).toLowerCase();
        final keywords = (item['keywords'] as List<dynamic>).map((k) => k.toString()).toList();
        final matchesKeywords = keywords.any((k) => k.toLowerCase().contains(q));
        if (!kurd.contains(q) && !eng.contains(q) && !matchesKeywords) {
          return false;
        }
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8EBF0)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'گەڕان لە ڤیدیۆ و یارییەکان (سنگ، باربێڵ، اسکوات...)',
                hintStyle: const TextStyle(color: Color(0xFF9EA3AE), fontSize: 12),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Muscle Category Horizontal Chips
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _muscles.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedMuscleIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedMuscleIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : const Color(0xFFE8EBF0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _muscles[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF4A4E5A),
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        // Results count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'فێرکاری ڤیدیۆیی یارییەکان (${filtered.length} یاری بەردەستە)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF131519),
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.ondemand_video_rounded, color: AppColors.primary, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'ڤیدیۆی فێرکاری',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Exercise Cards
        ...filtered.map((item) => _buildLibraryExerciseCard(item)),
      ],
    );
  }

  // Library Card with Video Play Button & Add to Course Action
  Widget _buildLibraryExerciseCard(Map<String, dynamic> item) {
    final isInCourse = _myCourseExercises.any((e) => e['id'] == item['id']);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EBF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openExerciseVideoDetail(item),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail with Play Overlay
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        item['image'] ?? 'assets/images/workout_back.jpg',
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['videoDuration'] ?? '0:45',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['muscle'] ?? '',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item['level'] ?? '',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['kurdish'] ?? item['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF131519),
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
                          Text(
                            item['sets'] ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          // Quick Add / Added Status Button
                          GestureDetector(
                            onTap: () => _addExerciseToCourse(item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isInCourse
                                    ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                    : AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isInCourse ? Icons.check_rounded : Icons.add_rounded,
                                    size: 13,
                                    color: isInCourse
                                        ? const Color(0xFF10B981)
                                        : AppColors.primary,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    isInCourse ? 'لە کۆرسە' : 'زیادکردن',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: isInCourse
                                          ? const Color(0xFF10B981)
                                          : AppColors.primary,
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
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// INTERACTIVE VIDEO TUTORIAL & EXERCISE DETAIL MODAL
// ============================================================================
class _ExerciseVideoModal extends StatefulWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onStartTimer;
  final VoidCallback onAddToCourse;
  final bool isAlreadyInCourse;

  const _ExerciseVideoModal({
    required this.exercise,
    required this.onStartTimer,
    required this.onAddToCourse,
    required this.isAlreadyInCourse,
  });

  @override
  State<_ExerciseVideoModal> createState() => _ExerciseVideoModalState();
}

class _ExerciseVideoModalState extends State<_ExerciseVideoModal> {
  bool _isPlaying = true;
  double _videoProgress = 0.35;
  bool _isSlowMotion = false;
  bool _isLooping = true;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    // Simulate real video playback progression
    _progressTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_isPlaying && mounted) {
        setState(() {
          _videoProgress += (_isSlowMotion ? 0.008 : 0.02);
          if (_videoProgress >= 1.0) {
            _videoProgress = _isLooping ? 0.0 : 1.0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
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
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E5EA),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
              children: [
                // 1. VIDEO PLAYER CONTAINER (Simulated Full Featured Player)
                Container(
                  height: 225,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(22),
                    image: DecorationImage(
                      image: AssetImage(ex['image'] ?? 'assets/images/workout_back.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.85,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Dark gradient for controls visibility
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),

                      // Top Controls: HD Badge, Slow-mo, Close
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.hd_rounded, color: AppColors.accentGold, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    ex['videoQuality'] ?? '1080p HD',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),

                            // Loop toggle
                            GestureDetector(
                              onTap: () => setState(() => _isLooping = !_isLooping),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: _isLooping
                                      ? AppColors.primary
                                      : Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.repeat_rounded, color: Colors.white, size: 15),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // 0.5x Slow motion toggle
                            GestureDetector(
                              onTap: () => setState(() => _isSlowMotion = !_isSlowMotion),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _isSlowMotion
                                      ? AppColors.primary
                                      : Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _isSlowMotion ? '0.5x هێواش' : '1.0x خێرایی',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Close Sheet
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Center Big Play/Pause Action
                      Center(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPlaying = !_isPlaying),
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 14,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),

                      // Bottom Progress bar & Time
                      Positioned(
                        bottom: 10,
                        left: 14,
                        right: 14,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.remove_red_eye_rounded,
                                        color: Colors.white70, size: 12),
                                    SizedBox(width: 4),
                                    Text(
                                      'تەکنیکی دروستی جووڵە',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ex['videoDuration'] ?? '0:45',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _videoProgress,
                                minHeight: 4,
                                backgroundColor: Colors.white.withValues(alpha: 0.3),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Title & Muscle Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ex['muscle'] ?? '',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ex['kurdish'] ?? ex['title'],
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF131519),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ex['title'],
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add to course button if not in course
                    if (!widget.isAlreadyInCourse)
                      ElevatedButton.icon(
                        onPressed: widget.onAddToCourse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text(
                          'بۆ کۆرسەکەم',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // 3. Quick Stats Grid
                Row(
                  children: [
                    _buildSpecTile('سێت و دووبارە', ex['sets'] ?? '4 Sets × 12'),
                    const SizedBox(width: 8),
                    _buildSpecTile('سووتاندن', ex['burn'] ?? '120 kcal'),
                    const SizedBox(width: 8),
                    _buildSpecTile('ئاست', ex['level'] ?? 'مامناوەند'),
                  ],
                ),

                const SizedBox(height: 20),

                // 4. STEP-BY-STEP INSTRUCTIONS IN KURDISH
                const Row(
                  children: [
                    Icon(Icons.directions_run_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'چۆنیەتی ئەنجامدانی یارییەکە بە شێوازی دروست:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF131519),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8EBF0)),
                  ),
                  child: Text(
                    ex['instructions'] ?? 'ئەم یارییە بە تەکنیکی دروست و هێواش ئەنجام بدە.',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.55,
                      color: Color(0xFF33373F),
                    ),
                  ),
                ),

                // 5. BREATHING ADVICE
                if (ex['breathing'] != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.air_rounded, color: Colors.blue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'تەکنیکی هەناسەدان لەکاتی جووڵە:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ex['breathing'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 6. COMMON MISTAKES WARNING
                if (ex['mistake'] != null) ...[
                  const SizedBox(height: 14),
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
                        const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'هەڵە باوەکان کە دەبێت لێیان دووربکەویتەوە:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ex['mistake'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 22),

                // 7. BOTTOM ACTION BUTTON: START REST TIMER
                ElevatedButton.icon(
                  onPressed: widget.onStartTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.timer_rounded, size: 20),
                  label: const Text(
                    'تەواوم کرد! کاتی پشوودان لێبدە',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecTile(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EBF0)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Color(0xFF757A86), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF131519)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// COURSE IMPORTER MODAL (PHOTO SCAN & MANUAL TYPING)
// ============================================================================
class _CourseImporterModal extends StatefulWidget {
  final List<Map<String, dynamic>> masterExercises;
  final Function(List<Map<String, dynamic>>) onCourseImported;

  const _CourseImporterModal({
    required this.masterExercises,
    required this.onCourseImported,
  });

  @override
  State<_CourseImporterModal> createState() => _CourseImporterModalState();
}

class _CourseImporterModalState extends State<_CourseImporterModal> {
  int _importMethod = 0; // 0 = Photo Scanner, 1 = Manual Typing
  bool _isAnalyzing = false;
  final List<Map<String, dynamic>> _customSelectedExercises = [];

  void _simulatePhotoScan() {
    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          // Auto detected exercises simulation
          final detected = [
            widget.masterExercises[0],
            widget.masterExercises[1],
            widget.masterExercises[2],
            widget.masterExercises[9],
            widget.masterExercises[10],
          ];
          widget.onCourseImported(detected.map((e) => Map<String, dynamic>.from(e)).toList());
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text('سەرکەوتووانە کۆرسەکە لە وێنەکەوە دەرهێنرا و چالاککرا!'),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        });
      }
    });
  }

  void _finishManualCourse() {
    if (_customSelectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تکایە لانیکەم یەک یاری هەڵبژێرە بۆ کۆرسەکەت'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.onCourseImported(
      _customSelectedExercises.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'دانانی کۆرسی ڕاهێنان',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF131519),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Method Segmented Tabs: 0 = Photo, 1 = Manual
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _importMethod = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _importMethod == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _importMethod == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 15,
                              color: _importMethod == 0 ? AppColors.primary : Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'سکانکردنی وێنە',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    _importMethod == 0 ? FontWeight.bold : FontWeight.w600,
                                color: _importMethod == 0
                                    ? AppColors.primary
                                    : const Color(0xFF676E7D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _importMethod = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _importMethod == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _importMethod == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              size: 17,
                              color: _importMethod == 1 ? AppColors.primary : Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'نوسین بە دەست',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    _importMethod == 1 ? FontWeight.bold : FontWeight.w600,
                                color: _importMethod == 1
                                    ? AppColors.primary
                                    : const Color(0xFF676E7D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Method Content
          Expanded(
            child: _importMethod == 0 ? _buildPhotoScanBody() : _buildManualTypingBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoScanBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E5EA), width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'وێنەی وەرەقەی ڕاهێنانەکەت دابنێ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131519),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'سیستەم بە شێوازی زیرەک یارییەکان دەخوێنێتەوە و لەگەڵ فێرکاری ڤیدیۆیی ڕێکیان دەخات.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF676E7D), height: 1.45),
                ),
                const SizedBox(height: 20),
                if (_isAnalyzing)
                  const Column(
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 12),
                      Text(
                        'خەریکی خوێندنەوە و دەرهێنانی یارییەکانە...',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _simulatePhotoScan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt_rounded, size: 18),
                          label: const Text(
                            'گرتنی وێنە',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _simulatePhotoScan,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF131519),
                            side: const BorderSide(color: Color(0xFFD0D5DD)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.photo_library_rounded, size: 18),
                          label: const Text(
                            'لە گەلەری',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildManualTypingBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text(
          'ناوی ئەو یارییانە هەڵبژێرە کە دەتەوێت لە کۆرسەکەتدا بن:',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Quick select from master exercises
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.masterExercises.map((ex) {
            final isAdded = _customSelectedExercises.any((e) => e['id'] == ex['id']);
            return FilterChip(
              selected: isAdded,
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primary,
              label: Text(
                ex['kurdish'] ?? ex['title'],
                style: TextStyle(
                  fontSize: 11.5,
                  color: isAdded ? AppColors.primary : const Color(0xFF33373F),
                  fontWeight: isAdded ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _customSelectedExercises.add(ex);
                  } else {
                    _customSelectedExercises.removeWhere((e) => e['id'] == ex['id']);
                  }
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
        Text(
          'یارییە هەڵبژێردراوەکان: ${_customSelectedExercises.length}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        ..._customSelectedExercises.asMap().entries.map((entry) {
          final idx = entry.key;
          final ex = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8EBF0)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '${idx + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ex['kurdish'] ?? ex['title'],
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.red, size: 18),
                  onPressed: () {
                    setState(() {
                      _customSelectedExercises.removeAt(idx);
                    });
                  },
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _finishManualCourse,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text(
            'تەواوکردن و چالاککردنی کۆرس',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
