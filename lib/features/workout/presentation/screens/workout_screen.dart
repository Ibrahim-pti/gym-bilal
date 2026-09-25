import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // Active selected muscle category filter: null = Grid View of all categories
  String? _selectedCategory;

  // Categories definitions in 100% English with signature colors and icons
  final List<Map<String, dynamic>> _muscleCategories = [
    {
      'id': 'all',
      'title': 'All Movements',
      'subtitle': 'Full Master Library',
      'image': 'assets/images/onboarding_athlete.jpg',
      'count': '19 Drills',
      'tag': 'Master Suite',
      'icon': Icons.bolt_rounded,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'chest',
      'title': 'Chest',
      'subtitle': 'Pectorals & Push',
      'image': 'assets/images/workout_back.jpg',
      'count': '4 Drills',
      'tag': 'Pectorals',
      'icon': Icons.fitness_center_rounded,
      'accentColor': const Color(0xFFFF5252),
    },
    {
      'id': 'back',
      'title': 'Back & Lats',
      'subtitle': 'V-Taper & Pull',
      'image': 'assets/images/pullup_figure.jpg',
      'count': '4 Drills',
      'tag': 'V-Taper',
      'icon': Icons.sports_gymnastics_rounded,
      'accentColor': const Color(0xFF0284C7),
    },
    {
      'id': 'shoulders',
      'title': 'Shoulders',
      'subtitle': 'Deltoids & Traps',
      'image': 'assets/images/male_fitness_banner.jpg',
      'count': '3 Drills',
      'tag': 'Deltoids',
      'icon': Icons.shield_rounded,
      'accentColor': const Color(0xFFF59E0B),
    },
    {
      'id': 'arms',
      'title': 'Arms & Biceps',
      'subtitle': 'Biceps & Triceps',
      'image': 'assets/images/splash_athlete.jpg',
      'count': '3 Drills',
      'tag': 'Arm Definition',
      'icon': Icons.fitness_center_outlined,
      'accentColor': const Color(0xFF8B5CF6),
    },
    {
      'id': 'legs',
      'title': 'Legs & Glutes',
      'subtitle': 'Quads & Hamstrings',
      'image': 'assets/images/female_fitness_banner.jpg',
      'count': '3 Drills',
      'tag': 'Lower Body',
      'icon': Icons.directions_run_rounded,
      'accentColor': const Color(0xFF10B981),
    },
    {
      'id': 'core',
      'title': 'Core & Abs',
      'subtitle': 'Transverse & Six-Pack',
      'image': 'assets/images/posture_dark_3d.jpg',
      'count': '2 Drills',
      'tag': 'Core Stability',
      'icon': Icons.self_improvement_rounded,
      'accentColor': const Color(0xFFEC4899),
    },
  ];

  // Search
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Bookmarks
  final Set<String> _bookmarkedIds = {'bench_press', 'pull_ups', 'barbell_squat'};

  // Compact Floating Rest Timer State
  final int _timerSeconds = 45;
  int _currentTimerSeconds = 45;
  bool _isTimerActive = false;
  Timer? _activeTimer;

  // Master Exercises Database (100% English)
  final List<Map<String, dynamic>> _allExercises = [
    // --- 1. CHEST ---
    {
      'id': 'bench_press',
      'title': 'Barbell Bench Press',
      'muscleCategory': 'chest',
      'muscle': 'Chest Focus',
      'target': 'Pectoralis Major & Triceps',
      'sets': '4 Sets × 10-12 Reps',
      'level': 'Intermediate',
      'burn': '140 kcal',
      'equipment': 'Barbell & Flat Bench',
      'videoDuration': '0:45',
      'videoQuality': '1080p HD',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'Lie flat on the bench with your feet firmly planted on the floor. Grip the barbell slightly wider than shoulder-width. Lower the bar smoothly to mid-chest with control, then drive it powerfully upward without locking your elbows.',
      'mistake': 'Bouncing the barbell off your ribcage or lifting your hips off the bench during the press.',
      'breathing': 'Inhale deeply as you lower the barbell; exhale forcefully as you drive the weight upward.',
      'keywords': ['bench', 'press', 'chest', 'barbell', 'pecs'],
    },
    {
      'id': 'incline_dumbbell_press',
      'title': 'Incline Dumbbell Press',
      'muscleCategory': 'chest',
      'muscle': 'Upper Chest',
      'target': 'Clavicular Head & Front Deltoids',
      'sets': '4 Sets × 12 Reps',
      'level': 'Advanced',
      'burn': '125 kcal',
      'equipment': 'Incline Bench & Dumbbells',
      'videoDuration': '0:40',
      'videoQuality': '1080p HD',
      'image': 'assets/images/onboarding_athlete.jpg',
      'instructions':
          'Position the bench at a 30 to 45-degree angle. Press the dumbbells upward in a converging arc toward the ceiling, pausing briefly at the peak to squeeze your upper chest fibers.',
      'mistake': 'Setting the bench angle too steep (over 45 degrees), which transfers tension to the anterior deltoids.',
      'breathing': 'Inhale on the controlled negative descent; exhale as you press upward to full contraction.',
      'keywords': ['incline', 'dumbbell', 'chest', 'upper'],
    },
    {
      'id': 'cable_fly',
      'title': 'Cable Chest Fly',
      'muscleCategory': 'chest',
      'muscle': 'Mid & Inner Chest',
      'target': 'Sternal Pec Isolation & Squeeze',
      'sets': '3 Sets × 15 Reps',
      'level': 'Beginner',
      'burn': '95 kcal',
      'equipment': 'Cable Crossover Machine',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/card_gym_full.png',
      'instructions':
          'Bring handles forward in a wide hugging motion with a slight bend in your elbows. Squeeze your pecs hard for one full second at the centerline before returning with control.',
      'mistake': 'Locking your arms completely straight or allowing the weights to overstretch your shoulders behind your torso.',
      'breathing': 'Inhale as your arms open wide; exhale as you bring hands together at the center.',
      'keywords': ['cable', 'fly', 'chest', 'crossover'],
    },
    {
      'id': 'chest_dips',
      'title': 'Parallel Bar Chest Dips',
      'muscleCategory': 'chest',
      'muscle': 'Lower Chest',
      'target': 'Lower Pectorals & Triceps',
      'sets': '3 Sets × 12 Reps',
      'level': 'Intermediate',
      'burn': '115 kcal',
      'equipment': 'Dip Station / Parallel Bars',
      'videoDuration': '0:38',
      'videoQuality': '1080p HD',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'Lean your torso forward at roughly a 30-degree angle to emphasize chest engagement. Lower your body until your elbows reach a 90-degree angle, then press up firmly.',
      'mistake': 'Staying completely upright, which shifts the majority of tension onto the triceps instead of chest.',
      'breathing': 'Inhale on the descent; exhale as you press back to starting lockout.',
      'keywords': ['dips', 'chest', 'lower', 'parallel'],
    },

    // --- 2. BACK ---
    {
      'id': 'pull_ups',
      'title': 'Wide-Grip Pull Ups',
      'muscleCategory': 'back',
      'muscle': 'Back & Lats',
      'target': 'Latissimus Dorsi & Teres Major',
      'sets': '4 Sets × To Failure',
      'level': 'Intermediate',
      'burn': '160 kcal',
      'equipment': 'Pull-Up Bar',
      'videoDuration': '0:50',
      'videoQuality': '4K Ultra',
      'image': 'assets/images/pullup_figure.jpg',
      'instructions':
          'Grip the bar slightly wider than shoulder-width with an overhand grip. Pull your chest toward the bar by driving your elbows down and back until your chin clears the bar.',
      'mistake': 'Kicking your legs or using momentum to swing your body over the bar.',
      'breathing': 'Exhale as you pull your chest to the bar; inhale as you lower down under strict control.',
      'keywords': ['pull', 'up', 'back', 'lats', 'v-taper'],
    },
    {
      'id': 'lat_pulldown',
      'title': 'Wide-Grip Lat Pulldown',
      'muscleCategory': 'back',
      'muscle': 'Upper Lats',
      'target': 'Lat Width & Back Thickness',
      'sets': '4 Sets × 12 Reps',
      'level': 'Beginner',
      'burn': '110 kcal',
      'equipment': 'Cable Pulldown Machine',
      'videoDuration': '0:42',
      'videoQuality': '1080p HD',
      'image': 'assets/images/pullup_figure.jpg',
      'instructions':
          'Sit securely with your thighs locked under the pads. Lean back slightly and pull the wide bar down to your upper clavicle while squeezing your shoulder blades together.',
      'mistake': 'Pulling the bar behind your neck, which puts hazardous rotational stress on the cervical spine.',
      'breathing': 'Exhale as you pull the bar downward; inhale as the bar returns smoothly to the top.',
      'keywords': ['lat', 'pulldown', 'back', 'cable'],
    },
    {
      'id': 'barbell_row',
      'title': 'Bent-Over Barbell Row',
      'muscleCategory': 'back',
      'muscle': 'Mid Back',
      'target': 'Rhomboids, Trapezius & Lats',
      'sets': '4 Sets × 10 Reps',
      'level': 'Advanced',
      'burn': '150 kcal',
      'equipment': 'Barbell & Olympic Plates',
      'videoDuration': '0:45',
      'videoQuality': '1080p HD',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'Hinge at your hips with a flat back and a 45-degree torso angle. Pull the barbell straight up into your lower ribcage by leading with your elbows.',
      'mistake': 'Rounding your lumbar spine or using jerking leg momentum to lift the barbell.',
      'breathing': 'Exhale as you row the bar to your abdomen; inhale as you lower the weight.',
      'keywords': ['row', 'barbell', 'back', 'bent-over'],
    },
    {
      'id': 'deadlift',
      'title': 'Conventional Barbell Deadlift',
      'muscleCategory': 'back',
      'muscle': 'Full Posterior Chain',
      'target': 'Erector Spinae, Glutes & Hamstrings',
      'sets': '4 Sets × 6-8 Reps',
      'level': 'Advanced',
      'burn': '210 kcal',
      'equipment': 'Barbell & Olympic Plates',
      'videoDuration': '0:55',
      'videoQuality': '4K Ultra',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'Stand with feet hip-width apart, bar over mid-foot. Hinge down, grip the bar, brace your core, keep your spine neutral, and drive the floor away with your legs to stand upright.',
      'mistake': 'Hyperextending your lower back at lockout or letting the bar drift far in front of your shins.',
      'breathing': 'Take a deep breath and brace your core at the bottom; exhale at the top lockout.',
      'keywords': ['deadlift', 'back', 'powerlifting', 'strength'],
    },

    // --- 3. SHOULDERS ---
    {
      'id': 'overhead_press',
      'title': 'Overhead Military Press',
      'muscleCategory': 'shoulders',
      'muscle': 'Anterior & Lateral Delts',
      'target': 'Deltoid Complex & Triceps',
      'sets': '4 Sets × 10 Reps',
      'level': 'Advanced',
      'burn': '135 kcal',
      'equipment': 'Barbell & Squat Rack',
      'videoDuration': '0:45',
      'videoQuality': '1080p HD',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'Stand tall with feet shoulder-width apart and core braced. Press the barbell vertically overhead from collarbone level until your arms are fully extended overhead.',
      'mistake': 'Arching your lower back excessively or bending your knees to turn the lift into a push-press.',
      'breathing': 'Exhale as you press the bar overhead; inhale as you lower it with control to collarbone.',
      'keywords': ['overhead', 'press', 'military', 'shoulders'],
    },
    {
      'id': 'lateral_raise',
      'title': 'Dumbbell Lateral Raise',
      'muscleCategory': 'shoulders',
      'muscle': 'Lateral Deltoids',
      'target': 'Shoulder Capping & Width',
      'sets': '4 Sets × 15 Reps',
      'level': 'Intermediate',
      'burn': '90 kcal',
      'equipment': 'Dumbbells',
      'videoDuration': '0:30',
      'videoQuality': '1080p HD',
      'image': 'assets/images/splash_athlete.jpg',
      'instructions':
          'Raise the dumbbells out to the sides in a slight forward angle with soft elbows until your arms are parallel to the floor. Pause momentarily at shoulder height.',
      'mistake': 'Swinging your torso back and forth or shrugging your traps to raise the dumbbells.',
      'breathing': 'Exhale as you raise dumbbells laterally; inhale on the controlled descent.',
      'keywords': ['lateral', 'raise', 'shoulders', 'delts'],
    },
    {
      'id': 'face_pulls',
      'title': 'Cable Rope Face Pulls',
      'muscleCategory': 'shoulders',
      'muscle': 'Rear Deltoids',
      'target': 'Posterior Delts & Rotator Cuff',
      'sets': '4 Sets × 15 Reps',
      'level': 'Beginner',
      'burn': '85 kcal',
      'equipment': 'Cable & Rope Attachment',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'Set cable at eye height. Pull rope attachment toward your face while flaring elbows high and externally rotating wrists back.',
      'mistake': 'Pulling down toward your chest instead of keeping elbows high at eye level.',
      'breathing': 'Exhale on the pull and contraction; inhale as arms extend forward.',
      'keywords': ['face', 'pull', 'rear', 'delts'],
    },

    // --- 4. ARMS ---
    {
      'id': 'bicep_curl',
      'title': 'Standing Barbell Bicep Curl',
      'muscleCategory': 'arms',
      'muscle': 'Biceps Brachii',
      'target': 'Bicep Peak & Forearms',
      'sets': '4 Sets × 12 Reps',
      'level': 'Beginner',
      'burn': '100 kcal',
      'equipment': 'EZ Bar or Straight Bar',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/splash_athlete.jpg',
      'instructions':
          'Stand upright with elbows pinned tightly against your sides. Curl the barbell upward by contracting your biceps while keeping your upper arms stationary.',
      'mistake': 'Swinging elbows forward or hyperextending your spine to cheat the weight up.',
      'breathing': 'Exhale as you curl the weight upward; inhale as you lower the barbell.',
      'keywords': ['bicep', 'curl', 'arms', 'barbell'],
    },
    {
      'id': 'hammer_curl',
      'title': 'Dumbbell Hammer Curl',
      'muscleCategory': 'arms',
      'muscle': 'Brachialis & Forearms',
      'target': 'Arm Thickness & Forearm Strength',
      'sets': '3 Sets × 12 Reps',
      'level': 'Intermediate',
      'burn': '90 kcal',
      'equipment': 'Dumbbells',
      'videoDuration': '0:32',
      'videoQuality': '1080p HD',
      'image': 'assets/images/onboarding_athlete.jpg',
      'instructions':
          'Hold dumbbells with palms facing each other (neutral grip). Curl weights toward shoulders while maintaining the neutral hand alignment throughout.',
      'mistake': 'Flaring elbows outward or twisting wrists at the top of the curl.',
      'breathing': 'Exhale as you curl dumbbells; inhale on the downward return.',
      'keywords': ['hammer', 'curl', 'biceps', 'brachialis'],
    },
    {
      'id': 'tricep_rope',
      'title': 'Tricep Rope Pushdown',
      'muscleCategory': 'arms',
      'muscle': 'Lateral & Medial Triceps',
      'target': 'Tricep Horseshoe Definition',
      'sets': '4 Sets × 15 Reps',
      'level': 'Beginner',
      'burn': '95 kcal',
      'equipment': 'Cable & Rope Attachment',
      'videoDuration': '0:32',
      'videoQuality': '1080p HD',
      'image': 'assets/images/male_fitness_banner.jpg',
      'instructions':
          'Pin your elbows against your ribs. Push the rope attachment downward toward your thighs, spreading the ends apart at the bottom for peak tricep contraction.',
      'mistake': 'Allowing elbows to drift forward and up, turning the exercise into a shoulder press.',
      'breathing': 'Exhale as you press the rope down; inhale as hands return to 90-degree flexion.',
      'keywords': ['tricep', 'rope', 'pushdown', 'arms'],
    },

    // --- 5. LEGS ---
    {
      'id': 'barbell_squat',
      'title': 'Barbell Back Squat',
      'muscleCategory': 'legs',
      'muscle': 'Quads & Glutes',
      'target': 'Quadriceps, Gluteus Maximus & Core',
      'sets': '4 Sets × 8-10 Reps',
      'level': 'Advanced',
      'burn': '190 kcal',
      'equipment': 'Squat Rack & Barbell',
      'videoDuration': '0:55',
      'videoQuality': '4K Ultra',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'Rest barbell securely across upper traps. Descend by breaking at hips and knees simultaneously until thighs are parallel to the floor, then drive through heels to stand.',
      'mistake': 'Knees caving inward or chest collapsing forward during the ascent.',
      'breathing': 'Inhale deeply and brace core before descending; exhale as you drive out of the hole.',
      'keywords': ['squat', 'legs', 'quads', 'glutes'],
    },
    {
      'id': 'leg_press',
      'title': '45-Degree Leg Press',
      'muscleCategory': 'legs',
      'muscle': 'Quadriceps & Hips',
      'target': 'Quad Thickness & Leg Drive',
      'sets': '4 Sets × 12 Reps',
      'level': 'Intermediate',
      'burn': '145 kcal',
      'equipment': 'Leg Press Machine',
      'videoDuration': '0:40',
      'videoQuality': '1080p HD',
      'image': 'assets/images/female_fitness_banner.jpg',
      'instructions':
          'Place feet shoulder-width apart on the sled. Lower the platform smoothly until knees are at 90 degrees, then press back up without hyper-locking knees.',
      'mistake': 'Locking your knees violently at the top or lifting your pelvis off the backrest.',
      'breathing': 'Inhale on the negative descent; exhale as you drive the sled upward.',
      'keywords': ['leg', 'press', 'quads', 'machine'],
    },
    {
      'id': 'romanian_deadlift',
      'title': 'Romanian Deadlift (RDL)',
      'muscleCategory': 'legs',
      'muscle': 'Hamstrings & Glutes',
      'target': 'Hamstring Elongation & Glute Tie-in',
      'sets': '4 Sets × 10 Reps',
      'level': 'Intermediate',
      'burn': '130 kcal',
      'equipment': 'Barbell or Dumbbells',
      'videoDuration': '0:42',
      'videoQuality': '1080p HD',
      'image': 'assets/images/workout_back.jpg',
      'instructions':
          'Maintain a soft bend in knees and a rigid neutral spine. Push hips back as far as possible while sliding the weight down close to shins until deep hamstring stretch.',
      'mistake': 'Bending knees excessively into a squat or rounding the lower spine.',
      'breathing': 'Inhale on the hip hinge descent; exhale as you thrust hips forward to full upright.',
      'keywords': ['rdl', 'romanian', 'deadlift', 'hamstrings'],
    },

    // --- 6. CORE ---
    {
      'id': 'plank_core',
      'title': 'Core Plank to Pike',
      'muscleCategory': 'core',
      'muscle': 'Transverse Abdominis',
      'target': 'Deep Core Stability & Flat Waist',
      'sets': '3 Sets × 45 Sec',
      'level': 'Beginner',
      'burn': '80 kcal',
      'equipment': 'Yoga Mat',
      'videoDuration': '0:35',
      'videoQuality': '1080p HD',
      'image': 'assets/images/posture_dark_3d.jpg',
      'instructions':
          'Hold a rigid forearm plank with your body in a straight line from heels to head. Engage your transverse abdominis by drawing your belly button inward.',
      'mistake': 'Sagging your lower back or piking your hips high into the air.',
      'breathing': 'Breathe steadily and rhythmically without holding your breath.',
      'keywords': ['plank', 'core', 'abs', 'stability'],
    },
    {
      'id': 'hanging_leg_raise',
      'title': 'Hanging Knee / Leg Raise',
      'muscleCategory': 'core',
      'muscle': 'Lower Abdominals',
      'target': 'V-Line Definition & Hip Flexors',
      'sets': '4 Sets × 15 Reps',
      'level': 'Intermediate',
      'burn': '95 kcal',
      'equipment': 'Pull-Up Bar',
      'videoDuration': '0:36',
      'videoQuality': '1080p HD',
      'image': 'assets/images/posture_dark_3d.jpg',
      'instructions':
          'Hang from bar with straight arms. Raise knees or straight legs upward by rolling your pelvis up toward your ribcage with zero torso swinging.',
      'mistake': 'Swinging your body back and forth using momentum rather than abdominal contraction.',
      'breathing': 'Exhale as you raise legs; inhale as you lower them with control.',
      'keywords': ['hanging', 'leg', 'raise', 'abs'],
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
                  'Rest time finished! Time for the next set 💪',
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
    // Filtered exercises
    final filteredExercises = _allExercises.where((item) {
      // If a category is selected (and not 'all')
      if (_selectedCategory != null && _selectedCategory != 'all') {
        if (item['muscleCategory'] != _selectedCategory) return false;
      }
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final title = (item['title'] as String).toLowerCase();
        final target = (item['target'] as String).toLowerCase();
        final keywords = (item['keywords'] as List<dynamic>).map((k) => k.toString()).toList();
        final matchesKeywords = keywords.any((k) => k.toLowerCase().contains(q));
        if (!title.contains(q) && !target.contains(q) && !matchesKeywords) {
          return false;
        }
      }
      return true;
    }).toList();

    // Determine current view mode:
    // If user has not chosen a category and search is empty -> show the GRID VIEW!
    // If user chose a category OR searched -> show EXERCISES LIST!
    final showGridView = _selectedCategory == null && _searchQuery.isEmpty;
    final gridMuscleCategories = _muscleCategories.where((c) => c['id'] != 'all').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          // 1. Sleek Modern App Bar
          _buildSliverAppBar(),

          // 2. Search Bar
          SliverToBoxAdapter(
            child: _buildSearchBarSection(),
          ),

          // 3. MAIN CONTENT: Either GRID OF MUSCLES or EXERCISES LIST
          if (showGridView) ...[
            // Eye-Catching Hero Movement Showcase Banner
            SliverToBoxAdapter(
              child: _buildHeroShowcaseBanner(),
            ),

            // Interactive Quick Filter Category Chips
            SliverToBoxAdapter(
              child: _buildQuickFilterChips(),
            ),

            // 2-Column Grid of 6 Muscle Categories (Symmetric 2x3 Grid)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 110),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cat = gridMuscleCategories[index];
                    return _buildGridMuscleCard(cat);
                  },
                  childCount: gridMuscleCategories.length,
                ),
              ),
            ),
          ] else ...[
            // Header for Exercises List with Back Button
            SliverToBoxAdapter(
              child: _buildExercisesListHeader(filteredExercises.length),
            ),

            // Exercise Cards List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
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
            'Exercise & Video Hub',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF131519),
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Master Movement Library & Form Guide',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF757A86),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. SEARCH BAR ---
  Widget _buildSearchBarSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Container(
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
            hintText: 'Search exercises, muscles (Bench, Squat, Delts...)',
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
    );
  }

  // --- 3. HERO SHOWCASE BANNER (EYE-CATCHING / WOW FACTOR) ---
  Widget _buildHeroShowcaseBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'assets/images/onboarding_athlete.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),

            // Deep dark cinematic gradient with warm orange rim
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.94),
                    Colors.black.withValues(alpha: 0.72),
                    Colors.black.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),

            // Content
            Container(
              height: 180,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Pill & Video Tag
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFFFF8A00)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bolt_rounded, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'MASTER MOVEMENT LIBRARY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam_rounded, color: Color(0xFF10B981), size: 12),
                            SizedBox(width: 4),
                            Text(
                              '1080p HD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Headline & Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '19 Master Drills & Videos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Calibrated cues & form mistakes for 6 target muscle groups',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Action Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = 'all';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Explore All Exercises',
                                style: TextStyle(
                                  color: Color(0xFF131519),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 14),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '6 Target Zones',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. INTERACTIVE QUICK FILTER CATEGORY CHIPS ---
  Widget _buildQuickFilterChips() {
    return Container(
      height: 38,
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 14),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _muscleCategories.length,
        itemBuilder: (context, index) {
          final cat = _muscleCategories[index];
          final isSelected = _selectedCategory == cat['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat['id'];
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF131519) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? const Color(0xFF131519) : const Color(0xFFE5E7EB),
                ),
                boxShadow: [
                  if (!isSelected)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat['icon'] as IconData? ?? Icons.fitness_center_rounded,
                    size: 13,
                    color: isSelected ? AppColors.accentGold : (cat['accentColor'] as Color? ?? AppColors.primary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['title'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF2D3139),
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
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

  // --- 5. ULTRA-PREMIUM 2-COLUMN GRID MUSCLE CARD ---
  Widget _buildGridMuscleCard(Map<String, dynamic> cat) {
    final Color accentColor = (cat['accentColor'] as Color?) ?? AppColors.primary;
    final IconData icon = (cat['icon'] as IconData?) ?? Icons.fitness_center_rounded;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1.2),
        image: DecorationImage(
          image: AssetImage(cat['image']),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            setState(() {
              _selectedCategory = cat['id'];
            });
          },
          child: Stack(
            children: [
              // Deep Dark Multi-Stop Vignette
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.36, 0.68, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.22),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.68),
                      Colors.black.withValues(alpha: 0.96),
                    ],
                  ),
                ),
              ),

              // Top Left: Glowing Tag with Category Icon
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: accentColor, size: 11),
                      const SizedBox(width: 4),
                      Text(
                        (cat['tag'] as String).toUpperCase(),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top Right: Drill Count with active green dot
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        cat['count'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Content: Title, Subtitle, and Eye-Catching Action Button
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (cat['title'] as String).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cat['subtitle'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 9),

                    // Tactile Eye-Catching Action Pill Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6.5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor,
                            accentColor.withValues(alpha: 0.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'View Drills',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 10),
                          ),
                        ],
                      ),
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

  // --- 4. EXERCISES LIST HEADER (WITH BACK TO GRID BUTTON) ---
  Widget _buildExercisesListHeader(int count) {
    final activeCat = _muscleCategories.firstWhere(
      (c) => c['id'] == _selectedCategory,
      orElse: () => _muscleCategories.first,
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back to Grid Button & Active Category Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = null;
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E5EA)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded, size: 15, color: Color(0xFF131519)),
                      SizedBox(width: 6),
                      Text(
                        'All Muscle Groups',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF131519),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Count Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.video_collection_rounded, color: AppColors.primary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '$count Exercises',
                      style: const TextStyle(
                        color: AppColors.primary,
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

          // Active Category Name
          Row(
            children: [
              Text(
                activeCat['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF131519),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '• ${activeCat['subtitle']}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF757A86),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Quick Filter Switcher Chips
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _muscleCategories.length,
              itemBuilder: (context, index) {
                final cat = _muscleCategories[index];
                final isSelected = _selectedCategory == cat['id'];

                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF131519) : const Color(0xFFF4F6F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        cat['title'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF4A4E5A),
                          fontSize: 11,
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

  // --- 5. ULTRA MODERN EXERCISE CARD WITH VIDEO SHOWCASE ---
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
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 170,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.fitness_center_rounded, size: 40),
                      ),
                    ),
                  ),

                  // Dark gradient overlay
                  Container(
                    height: 170,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    width: 52,
                    height: 52,
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
                            'Watch Form Video',
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
                    // Title in English (Bold & Prominent)
                    Text(
                      ex['title'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF131519),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Target Muscle Breakdown
                    Text(
                      ex['target'],
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
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
// INTERACTIVE VIDEO TUTORIAL & MOVEMENT MODAL (100% ENGLISH)
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
                                  _isSlowMotion ? '0.5x Slow' : '1.0x Normal',
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
                                      'Technique & Form Guide',
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
                            ex['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF131519),
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ex['target'],
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
                    _buildSpecTile('Sets & Reps', ex['sets']),
                    const SizedBox(width: 8),
                    _buildSpecTile('Calories', ex['burn']),
                    const SizedBox(width: 8),
                    _buildSpecTile('Equipment', ex['equipment']),
                  ],
                ),

                const SizedBox(height: 20),

                // 4. STEP-BY-STEP INSTRUCTIONS
                const Row(
                  children: [
                    Icon(Icons.directions_run_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Instructions & Movement Execution:',
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
                                'Breathing Technique:',
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
                                'Common Mistakes to Avoid:',
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
                    'Start Rest Countdown',
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
