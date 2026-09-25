import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _selectedMuscleIndex = 0;
  final List<String> _muscles = [
    'هەموو یارییەکان',
    'سنگ (Chest)',
    'پشت (Back)',
    'شان (Shoulders)',
    'باڵ و قۆڵ (Arms)',
    'قاچ (Legs)',
    'سک (Abs)',
  ];

  // Rest Timer state
  final int _timerSeconds = 45;
  int _currentTimerSeconds = 45;
  bool _isTimerRunning = false;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _currentTimerSeconds = _timerSeconds;
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
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _currentTimerSeconds = _timerSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final List<Map<String, dynamic>> _exercises = [
    {
      'title': 'Barbell Bench Press',
      'muscle': 'سنگ (Chest)',
      'sets': '4 Sets × 10-12 Reps',
      'level': 'مامناوەند',
      'burn': '120 kcal',
      'image': 'assets/images/workout_back.jpg',
    },
    {
      'title': 'Incline Dumbbell Press',
      'muscle': 'بەشی سەرەوەی سنگ',
      'sets': '3 Sets × 12 Reps',
      'level': 'پێشکەوتوو',
      'burn': '95 kcal',
      'image': 'assets/images/onboarding_athlete.jpg',
    },
    {
      'title': 'Wide-Grip Pull Ups',
      'muscle': 'پشت و باڵ (Back & Lats)',
      'sets': '4 Sets × To Failure',
      'level': 'سەرەتایی / مامناوەند',
      'burn': '140 kcal',
      'image': 'assets/images/pullup_figure.jpg',
    },
    {
      'title': 'Standing Bicep Curls',
      'muscle': 'ماسولکەی پێشەوەی قۆڵ',
      'sets': '3 Sets × 15 Reps',
      'level': 'سەرەتایی',
      'burn': '80 kcal',
      'image': 'assets/images/splash_athlete.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'یارییەکان و ڕاهێنان (Workout Hub)',
          style: TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded,
                color: AppColors.lightTextPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // Muscle Filter Chips (Horizontal)
          Container(
            height: 52,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _muscles[index],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.lightTextPrimary,
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Rest Timer Widget
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1F2228), Color(0xFF131416)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${_currentTimerSeconds}s',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تایمەری پشوودانی نێوان سێتەکان',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isTimerRunning
                            ? 'پشوو وەربگرە و هەناسە بدە...'
                            : 'سێتەکەت تەواو کرد؟ کاتی پشوودان لێبدە',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isTimerRunning ? _resetTimer : _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTimerRunning
                          ? Colors.redAccent
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      _isTimerRunning ? 'وەستاندن' : 'دەستپێکردن',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Exercise List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: const Text(
              'لیستی ڕاهێنانەکان (Exercises)',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),

          ..._exercises.map((item) => _buildExerciseCard(item)),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              item['image'],
              width: 82,
              height: 82,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tagCardio,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['muscle'],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.repeat_rounded,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      item['sets'],
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
