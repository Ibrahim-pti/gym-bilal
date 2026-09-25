import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/calorie/presentation/screens/camera_food_scanner_screen.dart';
import 'package:gym_base/features/calorie/presentation/screens/supplement_tracker_screen.dart';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  State<CalorieScreen> createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  int _consumedCalories = 1680;
  final int _targetCalories = 2400;
  final int _burnedCalories = 420;
  int _waterGlasses = 7; // out of 10
  final int _targetGlasses = 10;

  // Master Logged Meals (100% English)
  final List<Map<String, dynamic>> _meals = [
    {
      'title': 'Breakfast',
      'food': '3 Boiled Eggs + Sourdough Toast + Black Coffee',
      'cal': 360,
      'protein': '26g',
      'carbs': '32g',
      'fat': '14g',
      'time': '08:30 AM',
      'icon': Icons.wb_sunny_rounded,
    },
    {
      'title': 'Lunch',
      'food': 'Grilled Chicken Breast with Brown Rice & Green Salad',
      'cal': 680,
      'protein': '52g',
      'carbs': '70g',
      'fat': '18g',
      'time': '01:45 PM',
      'icon': Icons.restaurant_rounded,
    },
    {
      'title': 'Pre-Workout Snack',
      'food': 'Banana + Natural Peanut Butter + Double Espresso',
      'cal': 240,
      'protein': '7g',
      'carbs': '35g',
      'fat': '9g',
      'time': '04:30 PM',
      'icon': Icons.bolt_rounded,
    },
    {
      'title': 'Dinner',
      'food': 'Seared Sirloin Steak with Sweet Potato & Greek Yogurt',
      'cal': 400,
      'protein': '38g',
      'carbs': '22g',
      'fat': '15g',
      'time': '08:00 PM',
      'icon': Icons.nightlight_round,
    },
  ];

  // Open the AI Camera Food Scanner Page
  Future<void> _openCameraScanner() async {
    final scannedMeal = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraFoodScannerScreen(),
      ),
    );

    if (scannedMeal != null && mounted) {
      setState(() {
        _meals.insert(0, scannedMeal);
        _consumedCalories += (scannedMeal['cal'] as int? ?? 0);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Added ${scannedMeal['title']} (+${scannedMeal['cal']} kcal) via AI Scanner!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = (_targetCalories - _consumedCalories).clamp(0, 5000);
    final progress = (_consumedCalories / _targetCalories).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Calorie & Nutrition Vision',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF131519),
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Smart Food Scanner & Macro Tracker',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF757A86),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E7EC)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF131519)),
                SizedBox(width: 5),
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131519),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          // 1. HERO AI CAMERA FOOD SCANNER CARD (TOP SPOTLIGHT)
          _buildHeroCameraScannerCard(),

          const SizedBox(height: 14),

          // 2. DAILY CALORIE RADIAL PROGRESS DASHBOARD
          _buildCalorieProgressCard(remaining, progress),

          const SizedBox(height: 14),

          // 3. SMART HYDRATION WATER TRACKER
          _buildHydrationTrackerCard(),

          const SizedBox(height: 12),

          // 3.5. DAILY SUPPLEMENT STACK TRACKER
          _buildSupplementsTrackerCard(),

          const SizedBox(height: 20),

          // 4. LOGGED MEALS OF THE DAY SECTION
          _buildMealsHeader(),

          const SizedBox(height: 10),

          // 5. LIST OF LOGGED MEALS
          ..._meals.map((meal) => _buildMealCard(meal)),
        ],
      ),
    );
  }

  // --- 1. HERO AI CAMERA FOOD SCANNER CARD ---
  Widget _buildHeroCameraScannerCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
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
              'assets/images/card_nutrition_full.png',
              height: 185,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),

            // Deep dark cinematic gradient with warm orange rim
            Container(
              height: 185,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.94),
                    Colors.black.withValues(alpha: 0.74),
                    Colors.black.withValues(alpha: 0.40),
                  ],
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: AI Vision Tag & Accuracy Badge
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
                            Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'AI FOOD VISION 2.0',
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
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Live Nutrition API',
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

                  const SizedBox(height: 12),

                  // Headline & Description
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan Food with Camera',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Point at any meal to instantly calculate calories & macros',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Action Button
                  GestureDetector(
                    onTap: _openCameraScanner,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
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
                          Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Launch AI Food Scanner',
                            style: TextStyle(
                              color: Color(0xFF131519),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 13),
                        ],
                      ),
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

  // --- 2. DAILY CALORIE RADIAL PROGRESS DASHBOARD ---
  Widget _buildCalorieProgressCard(int remaining, double progress) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Column(
        children: [
          Row(
            children: [
              // Radial Progress Meter
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 105,
                    height: 105,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      strokeCap: StrokeCap.round,
                      backgroundColor: const Color(0xFFF1F3F6),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$remaining',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF131519),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Text(
                        'kcal left',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF757A86),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 18),

              // Metrics Column
              Expanded(
                child: Column(
                  children: [
                    _buildStatRow('Daily Goal', '$_targetCalories kcal', const Color(0xFF131519)),
                    const Divider(height: 16, color: Color(0xFFF2F4F7)),
                    _buildStatRow('Consumed', '$_consumedCalories kcal', AppColors.primary),
                    const Divider(height: 16, color: Color(0xFFF2F4F7)),
                    _buildStatRow('Burned via Workout', '$_burnedCalories kcal 🔥', const Color(0xFF10B981)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF0F2F5)),
          const SizedBox(height: 16),

          // Macro Breakdown Progress Bars
          Row(
            children: [
              _buildMacroBar('Protein', '103g / 150g', 103 / 150, const Color(0xFFFF5252)),
              const SizedBox(width: 12),
              _buildMacroBar('Carbs', '179g / 220g', 179 / 220, const Color(0xFF0284C7)),
              const SizedBox(width: 12),
              _buildMacroBar('Healthy Fats', '56g / 70g', 56 / 70, const Color(0xFF8B5CF6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF757A86), fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: valueColor),
        ),
      ],
    );
  }

  Widget _buildMacroBar(String label, String value, double ratio, Color color) {
    final clampedRatio = ratio.clamp(0.0, 1.0);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF131519)),
              ),
              Text(
                '${(clampedRatio * 100).round()}%',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontSize: 9.5, color: Color(0xFF757A86), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: clampedRatio,
              minHeight: 5,
              backgroundColor: const Color(0xFFF1F3F6),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. SMART HYDRATION WATER TRACKER ---
  Widget _buildHydrationTrackerCard() {
    final double liters = (_waterGlasses * 0.25);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop_rounded, color: Color(0xFF0284C7), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Water Hydration',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0C4A6E)),
                ),
                const SizedBox(height: 2),
                Text(
                  '${liters.toStringAsFixed(2)}L / 2.5L ($_waterGlasses of $_targetGlasses Glasses)',
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF0369A1), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF0284C7), size: 22),
                onPressed: _waterGlasses > 0 ? () => setState(() => _waterGlasses--) : null,
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add_circle_rounded, color: Color(0xFF0284C7), size: 24),
                onPressed: _waterGlasses < _targetGlasses + 5 ? () => setState(() => _waterGlasses++) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3.5. DAILY SUPPLEMENT STACK CARD ---
  Widget _buildSupplementsTrackerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.medication_rounded, color: Color(0xFF9333EA), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Supplement Stack',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF581C87)),
                ),
                SizedBox(height: 2),
                Text(
                  'Creatine, Whey Isolate, Omega-3 • 4/6 Taken',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF7E22CE), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SupplementTrackerScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9333EA),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Stack 💊', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  // --- 4. MEALS HEADER & SCAN BUTTON ---
  Widget _buildMealsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Today's Logged Meals",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF131519),
            letterSpacing: -0.3,
          ),
        ),
        GestureDetector(
          onTap: _openCameraScanner,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 14),
                SizedBox(width: 4),
                Text(
                  '+ Scan Meal',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 5. LOGGED MEAL CARD ---
  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EBF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  meal['icon'] as IconData? ?? Icons.restaurant_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF131519),
                      ),
                    ),
                    Text(
                      meal['time'] ?? 'Today',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF757A86)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE8EBF0)),
                ),
                child: Text(
                  '${meal['cal']} kcal',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF131519),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            meal['food'],
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF4A4E5A),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMacroChip('P: ${meal['protein']}', const Color(0xFFFF5252)),
              const SizedBox(width: 6),
              _buildMacroChip('C: ${meal['carbs']}', const Color(0xFF0284C7)),
              const SizedBox(width: 6),
              _buildMacroChip('F: ${meal['fat']}', const Color(0xFF8B5CF6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
