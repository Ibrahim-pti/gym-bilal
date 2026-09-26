import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/profile/presentation/screens/body_transformation_screen.dart';
import 'package:gym_base/features/calorie/presentation/screens/supplement_tracker_screen.dart';
import 'package:gym_base/features/profile/presentation/widgets/fitness_calculators_sheet.dart';
import 'package:gym_base/features/profile/presentation/widgets/gym_pass_sheet.dart';
import 'package:gym_base/features/profile/presentation/widgets/pr_tracker_sheet.dart';
import 'package:gym_base/features/workout/presentation/screens/muscle_recovery_screen.dart';
import 'package:gym_base/features/profile/presentation/screens/ai_gym_coach_screen.dart';
import 'package:gym_base/features/workout/presentation/screens/live_workout_session_screen.dart';
import 'package:gym_base/features/calorie/presentation/screens/ai_food_scanner_screen.dart';
import 'package:gym_base/features/community/presentation/screens/gym_leaderboard_screen.dart';
import 'package:gym_base/features/calorie/presentation/widgets/water_wave_tracker_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // PRs state
  Map<String, double> _prs = {
    'Bench Press': 110.0,
    'Back Squat': 150.0,
    'Deadlift': 185.0,
    'Overhead Press': 72.5,
  };

  // Preferences state
  bool _isMetric = true;
  bool _workoutReminders = true;
  bool _waterReminders = true;
  bool _darkMode = false;

  void _openCalculators([int initialTab = 0]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FitnessCalculatorsSheet(initialTab: initialTab),
    );
  }

  void _openGymPass() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GymPassSheet(),
    );
  }

  void _openPrTracker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PrTrackerSheet(
        initialPrs: _prs,
        onSave: (updated) => setState(() => _prs = updated),
      ),
    );
  }

  void _openWaterTracker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WaterWaveTrackerSheet(),
    );
  }

  void _showMusicSnackbar(String playlist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting to $playlist on Spotify... 🎧'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showContactCoachDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.support_agent_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Contact Gym & Coach', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Have questions about your workout program, diet, or membership?',
              style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF25D366).withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366)),
              ),
              title: const Text('WhatsApp Coach', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              subtitle: const Text('Coach Bilal • Online', style: TextStyle(fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening WhatsApp with Coach Bilal...')),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.call_rounded, color: AppColors.primary),
              ),
              title: const Text('Gym Reception Call', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              subtitle: const Text('+964 750 000 0000', style: TextStyle(fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling Gym Reception...')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'More & Gym Hub',
          style: TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          // Gym Pass quick icon
          IconButton(
            tooltip: 'Digital Gym Pass',
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFD494)),
              ),
              child: const Icon(Icons.qr_code_2_rounded, color: Color(0xFFC76B00), size: 19),
            ),
            onPressed: _openGymPass,
          ),
          IconButton(
            icon: const Icon(Icons.support_agent_rounded, color: AppColors.lightTextPrimary),
            tooltip: 'Contact Coach',
            onPressed: _showContactCoachDialog,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          // 1. Athlete Profile & Pass Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Aryan Rathore',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7EB),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFFFD494)),
                                ),
                                child: const Text(
                                  'PRO 👑',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFC76B00),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Level 12 • Advanced Athlete',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 15),
                              SizedBox(width: 4),
                              Text(
                                '14-Day Streak 🔥',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Digital Gym Pass Action Button
                InkWell(
                  onTap: _openGymPass,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.qr_code_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Digital Gym Pass (Check-in QR)',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '24 Days Left',
                            style: TextStyle(
                              color: Color(0xFF059669),
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // === NEXT-GEN AI & ADVANCED INNOVATIONS 🚀 ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Next-Gen AI & Innovations 🚀',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'SMART AI ✨',
                  style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1. Featured Coach Bilal AI Banner
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AiGymCoachScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1C29), Color(0xFF0E1017)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFFEC4899)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Coach Bilal AI 🤖',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15.5),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'ONLINE',
                              style: TextStyle(color: Color(0xFF10B981), fontSize: 9.5, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Ask anything about workouts, diet, form & custom splits.',
                          style: TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 2 Grid Tiles for Advanced Features: Muscle Heatmap & Live Session
          Row(
            children: [
              _buildFeatureTile(
                title: 'Muscle Heatmap',
                subtitle: 'Anatomical Recovery',
                tag: '78% Ready',
                icon: Icons.accessibility_new_rounded,
                color: const Color(0xFF10B981),
                bgGradient: const [Color(0xFF111E1A), Color(0xFF0C1412)],
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MuscleRecoveryScreen()));
                },
              ),
              const SizedBox(width: 10),
              _buildFeatureTile(
                title: 'Live Gym Mode',
                subtitle: 'Timer & Rest Countdown',
                tag: 'LIVE 🔴',
                icon: Icons.timer_outlined,
                color: const Color(0xFFEF4444),
                bgGradient: const [Color(0xFF221316), Color(0xFF140D0E)],
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveWorkoutSessionScreen()));
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2 Grid Tiles: AI Food Vision & Leaderboard Podium
          Row(
            children: [
              _buildFeatureTile(
                title: 'AI Food Vision',
                subtitle: 'Camera Calorie Scan',
                tag: 'AI SCAN 📸',
                icon: Icons.camera_alt_outlined,
                color: const Color(0xFF06B6D4),
                bgGradient: const [Color(0xFF0F1E24), Color(0xFF0A1317)],
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AiFoodScannerScreen()));
                },
              ),
              const SizedBox(width: 10),
              _buildFeatureTile(
                title: 'Gym Leaderboard',
                subtitle: 'Ranks & Top 3 Podium',
                tag: 'RANK #4 👑',
                icon: Icons.emoji_events_rounded,
                color: const Color(0xFFF59E0B),
                bgGradient: const [Color(0xFF241C10), Color(0xFF151009)],
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GymLeaderboardScreen()));
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Hydration Wave Quick Card
          InkWell(
            onTap: _openWaterTracker,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.water_drop_rounded, color: Color(0xFF0284C7), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hydration Wave Tracker 💧',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                        ),
                        Text(
                          '1.8L of 2.5L logged today (72%) • Tap to log water',
                          style: TextStyle(color: Color(0xFF0369A1), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF0284C7)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 2. FITNESS TOOLS & CALCULATORS HUB 🧮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Fitness Tools & Calculators 🧮',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () => _openCalculators(0),
                child: const Text('Open All', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // 3 Tool Action Cards (1RM, Plates, Rest Timer)
          Row(
            children: [
              _buildToolCard(
                title: '1RM Max',
                subtitle: 'One Rep Max',
                icon: Icons.fitness_center_rounded,
                color: const Color(0xFFEA580C),
                onTap: () => _openCalculators(0),
              ),
              const SizedBox(width: 10),
              _buildToolCard(
                title: 'Barbell Plates',
                subtitle: 'Disk Loading',
                icon: Icons.line_weight_rounded,
                color: const Color(0xFF2563EB),
                onTap: () => _openCalculators(1),
              ),
              const SizedBox(width: 10),
              _buildToolCard(
                title: 'Rest Timer',
                subtitle: 'Set Intervals',
                icon: Icons.timer_outlined,
                color: const Color(0xFF10B981),
                onTap: () => _openCalculators(2),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 3. PERSONAL RECORDS (PRs) SHOWCASE 🏆
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.shade200),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.emoji_events_rounded, color: Color(0xFFF59E0B), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Personal Records (PRs)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: _openPrTracker,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          'Edit / View All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildPrItem('Bench', '${_prs['Bench Press']?.toStringAsFixed(0)} kg'),
                    _buildPrItem('Squat', '${_prs['Back Squat']?.toStringAsFixed(0)} kg'),
                    _buildPrItem('Deadlift', '${_prs['Deadlift']?.toStringAsFixed(0)} kg'),
                    _buildPrItem('OHP', '${_prs['Overhead Press']?.toStringAsFixed(0)} kg'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. FEATURE: Body Transformation & Before/After Slider Card 📸✨
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BodyTransformationScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B1D22), Color(0xFF131417)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/onboarding_athlete.jpg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '-8.5kg',
                              style: TextStyle(color: Color(0xFF10B981), fontSize: 9.5, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Transformation Slider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Interactive Before / After comparison & body fat % tracker.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 11.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white70,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 5. FEATURE: Daily Supplement Stack & Schedule Card 💊
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SupplementTrackerScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE9D5FF), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9333EA).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.medication_rounded, color: Color(0xFF9333EA), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Supplements & Schedule',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Creatine, Whey, Omega-3 • 4/6 Taken Today',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF9333EA),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 6. GYM WORKOUT PLAYLISTS 🎧
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.headphones_rounded, color: Color(0xFF1DB954), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Gym Workout Beats & Playlists 🎧',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPlaylistTile('⚡ Hardstyle Gym Phonk', 'High BPM Energy', const Color(0xFF3B82F6)),
                      const SizedBox(width: 10),
                      _buildPlaylistTile('🔥 Heavy Lifting Beats', 'PR Strength Beats', const Color(0xFFEF4444)),
                      const SizedBox(width: 10),
                      _buildPlaylistTile('🎧 Beast Mode Rap', 'Aggressive Motivation', const Color(0xFF8B5CF6)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 7. Monthly Performance Metric Tiles
          Row(
            children: [
              _buildStatBox('Current Weight', '76.0 kg', 'Goal: 75.0 kg', Icons.monitor_weight_outlined),
              const SizedBox(width: 10),
              _buildStatBox('Workouts Done', '28 Sessions', 'Past 30 Days', Icons.fitness_center_rounded),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatBox('Calories Burned', '14,250 kcal', 'Monthly Burn', Icons.whatshot_rounded),
              const SizedBox(width: 10),
              _buildStatBox('Active Hours', '34.5 hrs', 'Total Gym Time', Icons.timer_outlined),
            ],
          ),
          const SizedBox(height: 20),

          // 8. Medals & Achievements
          const Text(
            'Medals & Achievements 🏆',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w900,
              color: AppColors.lightTextPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadgeItem('🔥', 'Streak Master', '14 Days In a Row'),
                _buildBadgeItem('🏋️', 'Iron Lifter', '50 Personal Bests'),
                _buildBadgeItem('🥗', 'Calorie Pro', '30 Meals Logged'),
                _buildBadgeItem('👑', 'Gym Champion', 'Rank #1 This Month'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 9. APP PREFERENCES & QUICK SETTINGS ⚙️
          const Text(
            'Settings & Preferences ⚙️',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w900,
              color: AppColors.lightTextPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // Weight Unit Toggle
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.scale_rounded, size: 20, color: AppColors.lightTextPrimary),
                  ),
                  title: const Text('Units System', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: Text(_isMetric ? 'Metric (kg, cm)' : 'Imperial (lbs, ft)', style: const TextStyle(fontSize: 12)),
                  trailing: Switch.adaptive(
                    value: _isMetric,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _isMetric = val),
                  ),
                ),
                const Divider(height: 1),

                // Workout Reminders
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.notifications_active_outlined, size: 20, color: AppColors.lightTextPrimary),
                  ),
                  title: const Text('Gym Workout Reminders', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Daily at 5:30 PM', style: TextStyle(fontSize: 12)),
                  trailing: Switch.adaptive(
                    value: _workoutReminders,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _workoutReminders = val),
                  ),
                ),
                const Divider(height: 1),

                // Water Reminders
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.water_drop_outlined, size: 20, color: Color(0xFF0284C7)),
                  ),
                  title: const Text('Hydration Reminders', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Every 2 hours (Goal: 2.5L)', style: TextStyle(fontSize: 12)),
                  trailing: Switch.adaptive(
                    value: _waterReminders,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _waterReminders = val),
                  ),
                ),
                const Divider(height: 1),

                // Dark Mode Toggle
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.dark_mode_outlined, size: 20, color: AppColors.lightTextPrimary),
                  ),
                  title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: Text(_darkMode ? 'Enabled (OLED Dark)' : 'Light Mode', style: const TextStyle(fontSize: 12)),
                  trailing: Switch.adaptive(
                    value: _darkMode,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _darkMode = val),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Contact & Help Banner
          GestureDetector(
            onTap: _showContactCoachDialog,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.headset_mic_rounded, color: Color(0xFF2563EB)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need Help or Personal Coaching?',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: Color(0xFF1E3A8A)),
                        ),
                        Text(
                          'Direct WhatsApp support with Gym Bilal team',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF3B82F6)),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFF2563EB)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildFeatureTile({
    required String title,
    required String subtitle,
    required String tag,
    required IconData icon,
    required Color color,
    required List<Color> bgGradient,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 116,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: bgGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 17),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(color: color, fontSize: 8.5, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white60, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrItem(String exercise, String weight) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              exercise,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              weight,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.lightTextPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistTile(String title, String desc, Color accent) {
    return GestureDetector(
      onTap: () => _showMusicSnackbar(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1D22),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow_rounded, color: accent, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12.5),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white60, fontSize: 10.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String value, String subtitle, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.tagCardio,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.lightTextPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeItem(String emoji, String title, String desc) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFF5EA),
            border: Border.all(color: const Color(0xFFFFD494)),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.lightTextPrimary,
          ),
        ),
        Text(
          desc,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
