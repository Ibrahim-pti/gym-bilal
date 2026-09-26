import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class WorkoutSet {
  final int setNumber;
  double weight;
  int reps;
  bool isCompleted;

  WorkoutSet({
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });
}

class WorkoutExerciseItem {
  final String name;
  final String muscle;
  final List<WorkoutSet> sets;

  WorkoutExerciseItem({
    required this.name,
    required this.muscle,
    required this.sets,
  });
}

class LiveWorkoutSessionScreen extends StatefulWidget {
  final String routineName;
  const LiveWorkoutSessionScreen({super.key, this.routineName = 'Push Day (Chest & Shoulders)'});

  @override
  State<LiveWorkoutSessionScreen> createState() => _LiveWorkoutSessionScreenState();
}

class _LiveWorkoutSessionScreenState extends State<LiveWorkoutSessionScreen> {
  // Session Timer
  int _secondsElapsed = 1420; // ~23 mins
  Timer? _sessionTimer;

  // Rest Timer
  int _restSecondsRemaining = 0;
  Timer? _restTimer;
  bool _isResting = false;

  late List<WorkoutExerciseItem> _exercises;

  @override
  void initState() {
    super.initState();
    _startSessionTimer();

    _exercises = [
      WorkoutExerciseItem(
        name: 'Incline Barbell Bench Press',
        muscle: 'Upper Chest',
        sets: [
          WorkoutSet(setNumber: 1, weight: 70.0, reps: 10, isCompleted: true),
          WorkoutSet(setNumber: 2, weight: 80.0, reps: 8, isCompleted: true),
          WorkoutSet(setNumber: 3, weight: 85.0, reps: 6, isCompleted: false),
          WorkoutSet(setNumber: 4, weight: 90.0, reps: 4, isCompleted: false),
        ],
      ),
      WorkoutExerciseItem(
        name: 'Dumbbell Shoulder Press',
        muscle: 'Deltoids',
        sets: [
          WorkoutSet(setNumber: 1, weight: 24.0, reps: 10, isCompleted: false),
          WorkoutSet(setNumber: 2, weight: 26.0, reps: 8, isCompleted: false),
          WorkoutSet(setNumber: 3, weight: 28.0, reps: 8, isCompleted: false),
        ],
      ),
      WorkoutExerciseItem(
        name: 'Cable Lateral Raises',
        muscle: 'Side Delts',
        sets: [
          WorkoutSet(setNumber: 1, weight: 12.5, reps: 15, isCompleted: false),
          WorkoutSet(setNumber: 2, weight: 12.5, reps: 12, isCompleted: false),
          WorkoutSet(setNumber: 3, weight: 15.0, reps: 10, isCompleted: false),
        ],
      ),
      WorkoutExerciseItem(
        name: 'Tricep Rope Pushdowns',
        muscle: 'Triceps',
        sets: [
          WorkoutSet(setNumber: 1, weight: 25.0, reps: 12, isCompleted: false),
          WorkoutSet(setNumber: 2, weight: 30.0, reps: 10, isCompleted: false),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  void _triggerRestTimer([int seconds = 60]) {
    _restTimer?.cancel();
    setState(() {
      _restSecondsRemaining = seconds;
      _isResting = true;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining > 0) {
        if (mounted) setState(() => _restSecondsRemaining--);
      } else {
        timer.cancel();
        if (mounted) setState(() => _isResting = false);
      }
    });
  }

  void _skipRestTimer() {
    _restTimer?.cancel();
    setState(() => _isResting = false);
  }

  void _addRestTime(int extraSeconds) {
    setState(() => _restSecondsRemaining += extraSeconds);
  }

  String _formatTime(int totalSeconds) {
    int m = totalSeconds ~/ 60;
    int s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _totalVolumeLifted {
    double sum = 0;
    for (var ex in _exercises) {
      for (var s in ex.sets) {
        if (s.isCompleted) {
          sum += s.weight * s.reps;
        }
      }
    }
    return sum;
  }

  int get _completedSetsCount {
    int count = 0;
    for (var ex in _exercises) {
      for (var s in ex.sets) {
        if (s.isCompleted) count++;
      }
    }
    return count;
  }

  void _finishWorkout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1B1E26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: const [
            Text('🏆 WORKOUT FINISHED!', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 18)),
            SizedBox(height: 4),
            Text('Great job on crushing today\'s session!', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSummaryStat('Time Elapsed', _formatTime(_secondsElapsed), Icons.timer_outlined),
                  const Divider(color: Colors.white12, height: 16),
                  _buildSummaryStat('Total Volume Lifted', '${_totalVolumeLifted.toStringAsFixed(0)} kg', Icons.fitness_center_rounded),
                  const Divider(color: Colors.white12, height: 16),
                  _buildSummaryStat('Completed Sets', '$_completedSetsCount Sets', Icons.check_circle_outline_rounded),
                  const Divider(color: Colors.white12, height: 16),
                  _buildSummaryStat('Estimated Calories', '385 kcal', Icons.local_fire_department_rounded),
                  const Divider(color: Colors.white12, height: 16),
                  _buildSummaryStat('XP Earned', '+250 XP ⚡', Icons.bolt_rounded),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Save Workout & Exit', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16181F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.routineName,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const Text(
              'LIVE GYM SESSION IN PROGRESS 🔴',
              style: TextStyle(color: Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('FINISH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
            children: [
              // Live Metric HUD Cards
              Row(
                children: [
                  _buildHudBox('TIME', _formatTime(_secondsElapsed), Icons.timer_outlined, Colors.white),
                  const SizedBox(width: 8),
                  _buildHudBox('HEART RATE', '138 bpm', Icons.favorite_rounded, const Color(0xFFEF4444)),
                  const SizedBox(width: 8),
                  _buildHudBox('CALORIES', '340 kcal', Icons.local_fire_department_rounded, const Color(0xFFF97316)),
                  const SizedBox(width: 8),
                  _buildHudBox('VOLUME', '${_totalVolumeLifted.toStringAsFixed(0)} kg', Icons.fitness_center_rounded, const Color(0xFF38BDF8)),
                ],
              ),
              const SizedBox(height: 18),

              // Exercises List
              ..._exercises.map((exercise) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181B22),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
                              ),
                              Text(
                                exercise.muscle,
                                style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.more_horiz_rounded, color: Colors.white70, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Set Headers
                      Row(
                        children: const [
                          SizedBox(width: 34, child: Text('SET', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800))),
                          Expanded(child: Center(child: Text('WEIGHT (KG)', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800)))),
                          Expanded(child: Center(child: Text('REPS', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800)))),
                          SizedBox(width: 44, child: Center(child: Text('DONE', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800)))),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Set Rows
                      ...exercise.sets.map((set) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                            color: set.isCompleted
                                ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                : Colors.white.withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: set.isCompleted
                                  ? const Color(0xFF10B981).withValues(alpha: 0.3)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  '${set.setNumber}',
                                  style: TextStyle(
                                    color: set.isCompleted ? const Color(0xFF10B981) : Colors.white70,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '${set.weight.toStringAsFixed(1)} kg',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '${set.reps} reps',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      set.isCompleted = !set.isCompleted;
                                    });
                                    if (set.isCompleted) {
                                      _triggerRestTimer(60);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: set.isCompleted ? const Color(0xFF10B981) : Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                      color: set.isCompleted ? Colors.white : Colors.white38,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ],
          ),

          // Floating Rest Timer Overlay Bar
          if (_isResting)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E2430), Color(0xFF11141A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: CircularProgressIndicator(
                            value: _restSecondsRemaining / 60.0,
                            strokeWidth: 4,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            backgroundColor: Colors.white12,
                          ),
                        ),
                        Text(
                          '${_restSecondsRemaining}s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('REST TIMER ⏱️', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 11)),
                          SizedBox(height: 2),
                          Text('Recover before next set', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: '+15s',
                      onPressed: () => _addRestTime(15),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                        child: const Text('+15s', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Skip',
                      onPressed: _skipRestTimer,
                      icon: const Icon(Icons.skip_next_rounded, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHudBox(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF181B22),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12.5)),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8.5, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
