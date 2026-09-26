import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class MuscleGroupInfo {
  final String name;
  final String kurdishName;
  final int recoveryPercent;
  final int hoursRemaining;
  final String lastTrained;
  final List<String> topExercises;
  final String stretchTip;
  final bool isFront;

  const MuscleGroupInfo({
    required this.name,
    required this.kurdishName,
    required this.recoveryPercent,
    required this.hoursRemaining,
    required this.lastTrained,
    required this.topExercises,
    required this.stretchTip,
    required this.isFront,
  });
}

class MuscleRecoveryScreen extends StatefulWidget {
  const MuscleRecoveryScreen({super.key});

  @override
  State<MuscleRecoveryScreen> createState() => _MuscleRecoveryScreenState();
}

class _MuscleRecoveryScreenState extends State<MuscleRecoveryScreen> {
  bool _isFrontView = true;
  String _selectedMuscle = 'Chest (Pectorals)';

  final List<MuscleGroupInfo> _muscleData = const [
    MuscleGroupInfo(
      name: 'Chest (Pectorals)',
      kurdishName: 'ماسولکەکانی سنگ',
      recoveryPercent: 35,
      hoursRemaining: 28,
      lastTrained: 'Yesterday (Chest & Triceps)',
      topExercises: ['Incline Barbell Press', 'Dumbbell Flyes', 'Dips'],
      stretchTip: 'Doorway pectoral stretch for 30s each side.',
      isFront: true,
    ),
    MuscleGroupInfo(
      name: 'Shoulders (Deltoids)',
      kurdishName: 'ماسولکەکانی شان',
      recoveryPercent: 55,
      hoursRemaining: 16,
      lastTrained: '2 Days Ago',
      topExercises: ['Overhead Dumbbell Press', 'Lateral Raises', 'Face Pulls'],
      stretchTip: 'Cross-body shoulder stretch & arm circles.',
      isFront: true,
    ),
    MuscleGroupInfo(
      name: 'Arms (Biceps & Triceps)',
      kurdishName: 'ماسولکەکانی باسک و قۆڵ',
      recoveryPercent: 70,
      hoursRemaining: 8,
      lastTrained: 'Yesterday',
      topExercises: ['EZ-Bar Curls', 'Tricep Rope Pushdowns', 'Hammer Curls'],
      stretchTip: 'Wall bicep stretch & overhead tricep extension stretch.',
      isFront: true,
    ),
    MuscleGroupInfo(
      name: 'Core & Abs',
      kurdishName: 'ماسولکەکانی سک و ناوەند',
      recoveryPercent: 90,
      hoursRemaining: 0,
      lastTrained: '3 Days Ago',
      topExercises: ['Hanging Leg Raises', 'Cable Crunches', 'Plank Hold'],
      stretchTip: 'Cobra stretch for abdominal relaxation.',
      isFront: true,
    ),
    MuscleGroupInfo(
      name: 'Quadriceps (Front Legs)',
      kurdishName: 'ماسولکەی پێشەوەی ڕان',
      recoveryPercent: 100,
      hoursRemaining: 0,
      lastTrained: '4 Days Ago (Fully Ready!)',
      topExercises: ['Barbell Back Squats', 'Leg Press', 'Bulgarian Split Squats'],
      stretchTip: 'Standing quad stretch & deep low lunges.',
      isFront: true,
    ),
    MuscleGroupInfo(
      name: 'Upper Back & Lats',
      kurdishName: 'ماسولکەکانی سەرەوەی پشت و باڵ',
      recoveryPercent: 88,
      hoursRemaining: 2,
      lastTrained: '3 Days Ago',
      topExercises: ['Pull-Ups', 'Barbell Bent-Over Rows', 'Lat Pulldowns'],
      stretchTip: 'Child\'s pose & bar hanging stretch.',
      isFront: false,
    ),
    MuscleGroupInfo(
      name: 'Lower Back & Erector',
      kurdishName: 'خوارەوەی پشت',
      recoveryPercent: 65,
      hoursRemaining: 12,
      lastTrained: '2 Days Ago',
      topExercises: ['Romanian Deadlift', 'Back Extensions', 'Bird Dog'],
      stretchTip: 'Cat-Cow stretch and knee-to-chest hold.',
      isFront: false,
    ),
    MuscleGroupInfo(
      name: 'Hamstrings & Glutes',
      kurdishName: 'ماسولکەی دواوەی ڕان و کەمەر',
      recoveryPercent: 100,
      hoursRemaining: 0,
      lastTrained: '4 Days Ago (Fully Ready!)',
      topExercises: ['Seated Leg Curl', 'Barbell Hip Thrust', 'Stiff-Leg Deadlift'],
      stretchTip: 'Seated toe touch and pigeon pose.',
      isFront: false,
    ),
    MuscleGroupInfo(
      name: 'Calves (Gastrocnemius)',
      kurdishName: 'ماسولکەی پوز',
      recoveryPercent: 95,
      hoursRemaining: 0,
      lastTrained: '4 Days Ago',
      topExercises: ['Standing Calf Raises', 'Seated Calf Press'],
      stretchTip: 'Wall calf stretch with heel planted.',
      isFront: false,
    ),
  ];

  Color _getRecoveryColor(int percent) {
    if (percent >= 80) return const Color(0xFF10B981); // Green (Ready)
    if (percent >= 50) return const Color(0xFFF59E0B); // Amber (Recovering)
    return const Color(0xFFEF4444); // Red (Fatigued)
  }

  String _getRecoveryBadge(int percent) {
    if (percent >= 80) return 'READY TO TRAIN 🟢';
    if (percent >= 50) return 'RECOVERING 🟡';
    return 'HIGH FATIGUE 🔴';
  }

  @override
  Widget build(BuildContext context) {
    final activeList = _muscleData.where((m) => m.isFront == _isFrontView).toList();
    final selectedMuscleInfo = _muscleData.firstWhere(
      (m) => m.name == _selectedMuscle,
      orElse: () => activeList.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16181E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Muscle Recovery Heatmap 🧬',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Anatomical Strain & Fatigue Tracker',
              style: TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF10B981), width: 0.8),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt_rounded, color: Color(0xFF10B981), size: 14),
                SizedBox(width: 4),
                Text(
                  '78% Systemic',
                  style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w900, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // Smart AI Recommendation Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF38BDF8), size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TODAY\'S OPTIMAL FOCUS',
                        style: TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Legs & Core Day 🔥',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Quadriceps & Core are 100% recovered. Chest needs 28h more rest.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Front / Back View Switcher
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1F26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFrontView = true;
                        _selectedMuscle = 'Chest (Pectorals)';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: _isFrontView ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'FRONT BODY (پێشەوە)',
                        style: TextStyle(
                          color: _isFrontView ? Colors.white : Colors.white60,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFrontView = false;
                        _selectedMuscle = 'Upper Back & Lats';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: !_isFrontView ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'BACK BODY (دواوە)',
                        style: TextStyle(
                          color: !_isFrontView ? Colors.white : Colors.white60,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Muscle Interactive List
          ...activeList.map((m) {
            final isSelected = m.name == _selectedMuscle;
            final color = _getRecoveryColor(m.recoveryPercent);

            return GestureDetector(
              onTap: () => setState(() => _selectedMuscle = m.name),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF222631) : const Color(0xFF16181F),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? color : Colors.white.withValues(alpha: 0.06),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                m.kurdishName,
                                style: const TextStyle(color: Colors.white54, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getRecoveryBadge(m.recoveryPercent),
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${m.recoveryPercent}%',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: m.recoveryPercent / 100.0,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 14),

          // Detailed Deep Dive Card for Selected Muscle
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1E27),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.insights_rounded, color: _getRecoveryColor(selectedMuscleInfo.recoveryPercent), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${selectedMuscleInfo.name} Insights',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInsightRow('Status', _getRecoveryBadge(selectedMuscleInfo.recoveryPercent)),
                _buildInsightRow('Rest Needed', selectedMuscleInfo.hoursRemaining == 0 ? 'Full Rested (Ready)' : '${selectedMuscleInfo.hoursRemaining} hours left'),
                _buildInsightRow('Last Workout', selectedMuscleInfo.lastTrained),
                const Divider(color: Colors.white12, height: 22),
                const Text(
                  'Top Exercises to Target:',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800, fontSize: 12.5),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: selectedMuscleInfo.topExercises.map((e) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(e, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Recovery & Stretch Tip:',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800, fontSize: 12.5),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedMuscleInfo.stretchTip,
                  style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12.5)),
        ],
      ),
    );
  }
}
