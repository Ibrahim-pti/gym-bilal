import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // Selected Muscle Filter
  int _selectedMuscleIndex = 0;
  final List<Map<String, dynamic>> _muscleCategories = [
    {'title': 'هەموو یارییەکان', 'id': 'all'},
    {'title': 'سنگ (Chest)', 'id': 'chest'},
    {'title': 'پشت (Back)', 'id': 'back'},
    {'title': 'شان (Shoulders)', 'id': 'shoulders'},
    {'title': 'باڵ و بازوو (Arms)', 'id': 'arms'},
    {'title': 'قاچ و سمت (Legs)', 'id': 'legs'},
    {'title': 'سک و ناوەند (Core)', 'id': 'core'},
  ];

  // Search
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Bookmarked / Favorite Exercises
  final Set<String> _bookmarkedIds = {'bench_press', 'pull_ups', 'barbell_squat'};

  // Compact Floating Rest Timer State
  final int _timerSeconds = 45;
  int _currentTimerSeconds = 45;
  bool _isTimerActive = false;
  Timer? _activeTimer;

  // Master Exercises Database with rich video and technique data
  final List<Map<String, dynamic>> _allExercises = [
    // --- 1. CHEST (سنگ) ---
    {
      'id': 'bench_press',
      'title': 'Barbell Bench Press',
      'kurdish': 'بێنچ پرێس بە باربێڵ',
      'muscleCategory': 'chest',
      'muscle': 'سنگ (Chest)',
      'target': 'ماسولکەی گەورەی سنگ',
      'sets': '4 Sets × 10-12 Reps',
      'level': 'مامناوەند',
      'burn': '140 kcal',
      'equipment': 'Barbell & Flat Bench',
      'videoDuration': '0:45',
      'videoQuality': '1080p HD',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'لەسەر بێنچەکە پاڵبکەوە و پێیەکانت لەسەر زەوی بچەسپێنە. بارەکە بە فراوانی زیاتر لە شانت بگرە، بە کۆنترۆڵ بیهێنە خوارەوە تا بەشی خوارەوەی سنگ، پاشان بە هێزەوە پاڵی پێوە بنێ بۆ سەرەوە بەبێ قفڵکردنی ئەنیشک.',
      'mistake': 'بەرزکردنەوەی سمت لەسەر بێنچەکە یان کێشانی بار لە سنگ بە خێرایی.',
      'breathing': 'لەکاتی هێنانە خوارەوە هەناسە هەڵمژە، لەکاتی بردنە سەرەوە بەهێز بیدەرەوە.',
      'keywords': ['bench', 'press', 'بێنچ', 'پرێس', 'سنگ', 'باربێڵ', 'chest'],
    },
    {
      'id': 'incline_dumbbell_press',
      'title': 'Incline Dumbbell Press',
      'kurdish': 'پرێسی سنگ بە دەمبڵی لار',
      'muscleCategory': 'chest',
      'muscle': 'سەرەوەی سنگ',
      'target': 'بەشی سەرەوەی سنگ و شانی پێشەوە',
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
      'muscleCategory': 'chest',
      'muscle': 'ناوەڕاستی سنگ',
      'target': 'جیاکردنەوە و هێڵی ناوەڕاستی سنگ',
      'sets': '3 Sets × 15 Reps',
      'level': 'سەرەتایی',
      'burn': '95 kcal',
      'equipment': 'Cable Crossover Machine',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/card_gym_full.png',
      'instructions':
          'دەستەکان بە کەوانەیی بەرەو پێشەوە بهێنە. لە خاڵی کۆتاییدا بۆ ماوەی ١ چرکە سنگت توند بگرە و ئەنیشکت کەمێک چەماوە ڕابگرە.',
      'mistake': 'ڕاستکردنەوەی تەواوی دەست کە فشاری مەترسیدار دەخاتە سەر ئەنیشک.',
      'breathing': 'پێشەوە بردن: هەناسەدانەوە، گەڕانەوە: هەناسە هەڵمژین.',
      'keywords': ['cable', 'fly', 'کەیبڵ', 'فلای', 'تەلبەند', 'سنگ'],
    },
    {
      'id': 'chest_dips',
      'title': 'Chest Parallel Dips',
      'kurdish': 'دیپس بۆ خوارەوەی سنگ',
      'muscleCategory': 'chest',
      'muscle': 'خوارەوەی سنگ',
      'target': 'هێڵی ژێر سنگ و تڕایسێپس',
      'sets': '3 Sets × 12 Reps',
      'level': 'مامناوەند',
      'burn': '115 kcal',
      'equipment': 'Dip Station / Parallel Bars',
      'videoDuration': '0:38',
      'videoQuality': '1080p HD',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'لەش کەمێک بەرەو پێشەوە لار بکەرەوە بۆ ئەوەی فشارەکە بکەوێتە سەر سنگت، بە هێواشی دابەزە تا ئەنیشکت گۆشەی ٩٠ پلە دروست دەکات، پاشان سەرکەوە.',
      'mistake': 'مانەوە بە ڕێکی کە دەبێتە هۆی خستنی فشار لەسەر تڕایسێپس نەک سنگ.',
      'breathing': 'دابەزین: هەڵمژین، سەرکەوتن: دانەوە.',
      'keywords': ['dips', 'دیپس', 'سنگ', 'تڕایسێپس'],
    },

    // --- 2. BACK (پشت) ---
    {
      'id': 'pull_ups',
      'title': 'Wide-Grip Pull Ups',
      'kurdish': 'پول ئەپس بە گرتنی پان',
      'muscleCategory': 'back',
      'muscle': 'پشت و باڵەکان',
      'target': 'فراوانکردنی پانی پشت (V-Taper)',
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
      'muscleCategory': 'back',
      'muscle': 'پشت و لاتس',
      'target': 'پانی پشت و باڵەکان',
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
      'kurdish': 'ڕاکێشانی باربێڵ بە چەمانەوە',
      'muscleCategory': 'back',
      'muscle': 'ناوەڕاستی پشت',
      'target': 'ئەستوورکردنی ماسولکەکانی پشت',
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
      'id': 'deadlift',
      'title': 'Conventional Barbell Deadlift',
      'kurdish': 'دیدلیفت بە باربێڵ',
      'muscleCategory': 'back',
      'muscle': 'تەواوی پشت و قاچ',
      'target': 'هێزی گشتی پشت و بەستەرەکان',
      'sets': '4 Sets × 6-8 Reps',
      'level': 'پێشکەوتوو',
      'burn': '210 kcal',
      'equipment': 'Barbell & Olympic Plates',
      'videoDuration': '0:55',
      'videoQuality': '4K Ultra',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'پێیەکانت بە پانی شانت دابنێ. بارەکە بە هەردوو دەست بگرە، پشتت بە تەواوی ڕێک و سنگی بەرز ڕابگرە، بە هێزی پاڵنانی پێیەکان کێشەکە بەرز بکەرەوە.',
      'mistake': 'قۆپکردنی پشت لەکاتی بەرزکردنەوە کە مەترسی دیسکی هەیە.',
      'breathing': 'لەسەر زەوی هەڵمژینی قووڵ، لە بەرزترین خاڵ دانەوە.',
      'keywords': ['deadlift', 'دیدلیفت', 'پشت', 'قاچ'],
    },

    // --- 3. SHOULDERS (شان) ---
    {
      'id': 'overhead_press',
      'title': 'Overhead Military Press',
      'kurdish': 'پرێسی شانی سەربازی بە باربێڵ',
      'muscleCategory': 'shoulders',
      'muscle': 'شانی پێشەوە و ناوەڕاست',
      'target': 'گەورەکردنی قەبارەی گشتی شان',
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
      'kurdish': 'کردنەوەی دەمبڵ بۆ لاکان',
      'muscleCategory': 'shoulders',
      'muscle': 'شانی ناوەڕاست',
      'target': 'تۆپکردن و فراوانکردنی شان',
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
      'id': 'face_pulls',
      'title': 'Cable Face Pulls',
      'kurdish': 'فەیس پول بە کەیبڵ و پەت',
      'muscleCategory': 'shoulders',
      'muscle': 'شانی دواوە و ستوون',
      'target': 'ڕێککردنەوەی قەمبووری و شانی دواوە',
      'sets': '4 Sets × 15 Reps',
      'level': 'سەرەتایی',
      'burn': '85 kcal',
      'equipment': 'Cable & Rope',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'پەتەکە ڕابکێشە بەرەو ڕووی دەموچاوت لە ئاستی چاودا، لە کاتی ڕاکێشاندا ئەنیشکەکانت بە بەرزی و بۆ دەرەوە ڕابگرە.',
      'mistake': 'ڕاکێشان بۆ خوارەوەی گەردن بەبێ بەرزکردنەوەی ئەنیشک.',
      'breathing': 'ڕاکێشان: دانەوە، گەڕانەوە: هەڵمژین.',
      'keywords': ['face', 'pull', 'شان', 'دواوە', 'پەت'],
    },

    // --- 4. ARMS (باڵ و بازوو) ---
    {
      'id': 'bicep_curl',
      'title': 'Standing Barbell Bicep Curl',
      'kurdish': 'بایسێپس بە باربێڵ بە پێوە',
      'muscleCategory': 'arms',
      'muscle': 'بازوو (Biceps)',
      'target': 'لووتکەی ماسولکەی بازوو',
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
      'id': 'hammer_curl',
      'title': 'Dumbbell Hammer Curl',
      'kurdish': 'هەمەر کێرڵ بە دەمبڵ',
      'muscleCategory': 'arms',
      'muscle': 'بازوو و مەچەک',
      'target': 'ئەستوورکردنی بازوو و ساعد',
      'sets': '3 Sets × 12 Reps',
      'level': 'مامناوەند',
      'burn': '90 kcal',
      'equipment': 'Dumbbells',
      'videoDuration': '0:32',
      'videoQuality': '1080p HD',
      'image': 'assets/images/onboarding_athlete.jpg',
      'instructions':
          'دەمبڵەکان بگرە بە شێوەی چەکوش کە کەمەرەی دەمبڵەکە بەرەو سەرەوە بێت، بە هێواشی کێرڵی بکە بەبێ جوڵاندنی شانت.',
      'mistake': 'لەقاندنی قۆڵ و پشت بۆ کێشانی دەمبڵ.',
      'breathing': 'بەرزکردنەوە: دانەوە، دابەزین: هەڵمژین.',
      'keywords': ['hammer', 'curl', 'هەمەر', 'چەکوش', 'بازوو'],
    },
    {
      'id': 'tricep_rope',
      'title': 'Tricep Rope Pushdown',
      'kurdish': 'تڕایسێپس بە کێبڵ و پەت',
      'muscleCategory': 'arms',
      'muscle': 'پشتی باڵ (Triceps)',
      'target': 'سەری دەرەوەی تڕایسێپس',
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

    // --- 5. LEGS (قاچ و سمت) ---
    {
      'id': 'barbell_squat',
      'title': 'Barbell Back Squat',
      'kurdish': 'سکوات بە باربێڵ لەسەر پشت',
      'muscleCategory': 'legs',
      'muscle': 'ڕان و سمت (Quads & Glutes)',
      'target': 'گەورەکردنی قەبارەی ڕان و سمت',
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
      'muscleCategory': 'legs',
      'muscle': 'چوارسەری ڕان',
      'target': 'ئەستووری پێشەوەی ڕان',
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
      'id': 'romanian_deadlift',
      'title': 'Romanian Deadlift (RDL)',
      'kurdish': 'دیدلیفتی ڕۆمانی بۆ پشتەڕان',
      'muscleCategory': 'legs',
      'muscle': 'پشتەڕان و سمت',
      'target': 'درێژکردنەوە و توندکردنی پشتەڕان',
      'sets': '4 Sets × 10 Reps',
      'level': 'مامناوەند',
      'burn': '130 kcal',
      'equipment': 'Barbell or Dumbbells',
      'videoDuration': '0:42',
      'videoQuality': '1080p HD',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'بە پێوە بوەستە، ئەژنۆ کەمێک چەماوە بێت. سمتت بەرەو دواوە بدە کاتێک بارەکە بە نزیک قاچتدا دەهێنیتە خوارەوە تا پشتەڕانت ڕادەکێشرێت.',
      'mistake': 'چەمانەوەی ئەژنۆ وەک سکوات یان خوارکردنی کەمەر.',
      'breathing': 'دابەزین: هەڵمژین، سەرکەوتن: دانەوە.',
      'keywords': ['rdl', 'romanian', 'deadlift', 'پشتەڕان', 'سمت'],
    },

    // --- 6. CORE (سک و ناوەند) ---
    {
      'id': 'plank_core',
      'title': 'Core Plank to Pike',
      'kurdish': 'پلانک و توندکردنی ناوەند',
      'muscleCategory': 'core',
      'muscle': 'ماسولکە قووڵەکانی سک',
      'target': 'تەختی سک و ڕێکی باڵا',
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
    {
      'id': 'hanging_leg_raise',
      'title': 'Hanging Knee/Leg Raise',
      'kurdish': 'هەڵواسینی قاچ بۆ خوارەوەی سک',
      'muscleCategory': 'core',
      'muscle': 'خوارەوەی سک (V-Line)',
      'target': 'دروستکردنی هێڵی خوارەوەی سک',
      'sets': '4 Sets × 15 Reps',
      'level': 'مامناوەند',
      'burn': '95 kcal',
      'equipment': 'Pull-Up Bar',
      'videoDuration': '0:36',
      'videoQuality': '1080p HD',
      'image': 'assets/images/posture_dark_3d.jpg',
      'instructions':
          'لە بارەکە هەڵبواسە. ئەژنۆ یان قاچت ڕاست بەرەو سەرووی کەمەرت بەرز بکەرەوە بە هێزی ماسولکەکانی سک بەبێ لەقاندنی لەش.',
      'mistake': 'شەپۆلدانی لەش بە دواوە و پێشەوە بۆ بەرزکردنەوە.',
      'breathing': 'بەرزکردنەوە: دانەوە، دابەزین: هەڵمژین.',
      'keywords': ['hanging', 'leg', 'raise', 'سک', 'هەڵواسین'],
    },
  ];

  @override
  void dispose() {
    _activeTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Timer Methods
  void _toggleTimer() {
    if (_isTimerActive) {
      _activeTimer?.cancel();
      setState(() => _isTimerActive = false);
    } else {
      setState(() {
        _isTimerActive = true;
        _currentTimerSeconds = _timerSeconds;
      });
      _activeTimer?.cancel();
      _activeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentTimerSeconds > 0) {
          setState(() => _currentTimerSeconds--);
        } else {
          _activeTimer?.cancel();
          setState(() => _isTimerActive = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'کاتی پشوودان تەواو بوو! ئامادەبە بۆ سێتی داهاتوو 💪',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        }
      });
    }
  }

  // Open Full Screen Video & Detail Modal
  void _openExerciseVideoDetail(Map<String, dynamic> exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ExerciseVideoModal(
        exercise: exercise,
        onStartRestTimer: () {
          Navigator.pop(context);
          _toggleTimer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredExercises = _allExercises.where((item) {
      // Muscle Category filter
      if (_selectedMuscleIndex > 0) {
        final catId = _muscleCategories[_selectedMuscleIndex]['id'];
        if (item['muscleCategory'] != catId) return false;
      }
      // Search filter
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

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: CustomScrollView(
        slivers: [
          // 1. Sleek Modern App Bar with Compact Timer
          _buildSliverAppBar(),

          // 2. Search & Category Filters (Sticky/Pinned Header)
          SliverToBoxAdapter(
            child: _buildSearchAndFilterHeader(),
          ),

          // 3. Results Count Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'هەموو یارییەکان (${filteredExercises.length} یاری بەردەستە)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF131519),
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.video_library_rounded, color: AppColors.primary, size: 15),
                      SizedBox(width: 4),
                      Text(
                        'فێرکاری بە ڤیدیۆ',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Exercise Cards List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ex = filteredExercises[index];
                  return _buildUltraExerciseCard(ex);
                },
                childCount: filteredExercises.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. SLIVER APP BAR ---
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      pinned: true,
      centerTitle: true,
      toolbarHeight: 65,
      title: const Column(
        children: [
          Text(
            'هەموو یارییەکان و ڤیدیۆ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF131519),
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Exercise & Movement Video Hub',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF757A86),
            ),
          ),
        ],
      ),
      actions: [
        // Sleek Compact Timer Pill Button in AppBar
        GestureDetector(
          onTap: _toggleTimer,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _isTimerActive ? AppColors.primary : const Color(0xFFF1F3F6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isTimerActive ? AppColors.primary : const Color(0xFFE2E5EA),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isTimerActive ? Icons.stop_rounded : Icons.timer_outlined,
                  size: 15,
                  color: _isTimerActive ? Colors.white : const Color(0xFF131519),
                ),
                const SizedBox(width: 4),
                Text(
                  _isTimerActive ? '${_currentTimerSeconds}s' : 'پشوو',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: _isTimerActive ? Colors.white : const Color(0xFF131519),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. SEARCH & MUSCLE FILTERS HEADER ---
  Widget _buildSearchAndFilterHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Column(
        children: [
          // Modern Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8EBF0)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(fontSize: 13, color: Color(0xFF131519)),
              decoration: InputDecoration(
                hintText: 'گەڕان بە ناوی یاری (سنگ، پشت، باربێڵ، سکوات...)',
                hintStyle: const TextStyle(color: Color(0xFF9EA3AE), fontSize: 12.5),
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
          const SizedBox(height: 12),

          // Horizontal Category Chips
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _muscleCategories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedMuscleIndex == index;
                final cat = _muscleCategories[index];

                return GestureDetector(
                  onTap: () => setState(() => _selectedMuscleIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF131519) : const Color(0xFFF4F6F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        cat['title'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF4A4E5A),
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
        ],
      ),
    );
  }

  // --- 3. ULTRA MODERN EXERCISE CARD WITH VIDEO SHOWCASE ---
  Widget _buildUltraExerciseCard(Map<String, dynamic> ex) {
    final isBookmarked = _bookmarkedIds.contains(ex['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8EBF0)),
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
          borderRadius: BorderRadius.circular(24),
          onTap: () => _openExerciseVideoDetail(ex),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP VIDEO THUMBNAIL WITH GLOWING PLAY BUTTON
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.asset(
                      ex['image'],
                      height: 165,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 165,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.fitness_center_rounded, size: 40),
                      ),
                    ),
                  ),

                  // Dark gradient overlay
                  Container(
                    height: 165,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),

                  // Top Left: Target Muscle Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                      ),
                      child: Text(
                        ex['muscle'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Top Right: Bookmark Button
                  Positioned(
                    top: 10,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isBookmarked) {
                            _bookmarkedIds.remove(ex['id']);
                          } else {
                            _bookmarkedIds.add(ex['id']);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                          color: isBookmarked ? AppColors.accentGold : Colors.white,
                          size: 17,
                        ),
                      ),
                    ),
                  ),

                  // Center Glowing Play Button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  // Bottom Overlay: Video Specs & Quality
                  Positioned(
                    bottom: 10,
                    left: 14,
                    right: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ex['videoQuality'] ?? '1080p',
                                style: const TextStyle(
                                  color: AppColors.accentGold,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'سەیرکردنی ڤیدیۆ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 2. EXERCISE DETAILS BODY
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title in Kurdish (Bold & Prominent)
                    Text(
                      ex['kurdish'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF131519),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // English Name & Focus
                    Text(
                      '${ex['title']} • ${ex['target']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757A86),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Metrics Badges Row
                    Row(
                      children: [
                        _buildMetricChip(Icons.repeat_rounded, ex['sets']),
                        const SizedBox(width: 8),
                        _buildMetricChip(Icons.local_fire_department_rounded, ex['burn']),
                        const SizedBox(width: 8),
                        _buildMetricChip(Icons.fitness_center_rounded, ex['level']),
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

  Widget _buildMetricChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECF0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF5A606D)),
          const SizedBox(width: 4),
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
// INTERACTIVE VIDEO TUTORIAL & MOVEMENT MODAL
// ============================================================================
class _ExerciseVideoModal extends StatefulWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onStartRestTimer;

  const _ExerciseVideoModal({
    required this.exercise,
    required this.onStartRestTimer,
  });

  @override
  State<_ExerciseVideoModal> createState() => _ExerciseVideoModalState();
}

class _ExerciseVideoModalState extends State<_ExerciseVideoModal> {
  bool _isPlaying = true;
  double _progress = 0.3;
  bool _isSlowMotion = false;
  bool _isLooping = true;
  Timer? _videoTicker;

  @override
  void initState() {
    super.initState();
    // Live playback ticker simulation
    _videoTicker = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_isPlaying && mounted) {
        setState(() {
          _progress += (_isSlowMotion ? 0.008 : 0.02);
          if (_progress >= 1.0) {
            _progress = _isLooping ? 0.0 : 1.0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _videoTicker?.cancel();
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
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 34),
              children: [
                // 1. FULL INTERACTIVE VIDEO PLAYER SIMULATOR
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(22),
                    image: DecorationImage(
                      image: AssetImage(ex['image']),
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
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.45),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),

                      // Top Row Controls (HD Badge, Loop, Slow-mo, Close)
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

                            // Loop Toggle
                            GestureDetector(
                              onTap: () => setState(() => _isLooping = !_isLooping),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _isLooping ? AppColors.primary : Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.repeat_rounded, color: Colors.white, size: 15),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // 0.5x Slow motion
                            GestureDetector(
                              onTap: () => setState(() => _isSlowMotion = !_isSlowMotion),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _isSlowMotion ? AppColors.primary : Colors.black.withValues(alpha: 0.65),
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

                            // Close Button
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

                      // Center Big Play/Pause
                      Center(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPlaying = !_isPlaying),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 16,
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

                      // Bottom Progress bar & Video duration
                      Positioned(
                        bottom: 12,
                        left: 14,
                        right: 14,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.remove_red_eye_rounded, color: Colors.white70, size: 13),
                                    SizedBox(width: 4),
                                    Text(
                                      'ڕێنمایی تەکنیکی جووڵە',
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
                                value: _progress,
                                minHeight: 4,
                                backgroundColor: Colors.white.withValues(alpha: 0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 2. TITLE & MUSCLE
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
                              ex['muscle'],
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ex['kurdish'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF131519),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${ex['title']} • ${ex['target']}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF676E7D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 3. STATS TILES
                Row(
                  children: [
                    _buildSpecTile('سێت و دووبارە', ex['sets']),
                    const SizedBox(width: 8),
                    _buildSpecTile('سووتاندن', ex['burn']),
                    const SizedBox(width: 8),
                    _buildSpecTile('ئامێر', ex['equipment']),
                  ],
                ),

                const SizedBox(height: 20),

                // 4. STEP-BY-STEP INSTRUCTIONS IN KURDISH
                const Row(
                  children: [
                    Icon(Icons.directions_run_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'چۆنیەتی ئەنجامدانی یارییەکە بە تەکنیکی دروست:',
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
                    ex['instructions'],
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.55,
                      color: Color(0xFF33373F),
                    ),
                  ),
                ),

                // 5. BREATHING GUIDELINE
                if (ex['breathing'] != null) ...[
                  const SizedBox(height: 12),
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
                                'تەکنیکی هەناسەدان:',
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

                // 6. COMMON MISTAKES TO AVOID
                if (ex['mistake'] != null) ...[
                  const SizedBox(height: 12),
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

                const SizedBox(height: 24),

                // 7. ACTION BUTTON: START REST TIMER
                ElevatedButton.icon(
                  onPressed: widget.onStartRestTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.timer_rounded, size: 20),
                  label: const Text(
                    'دەستپێکردنی کاتی پشوودان',
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
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF131519)),
            ),
          ],
        ),
      ),
    );
  }
}
