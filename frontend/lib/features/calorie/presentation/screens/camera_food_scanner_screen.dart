import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/calorie/data/services/nutrition_api_service.dart';

class CameraFoodScannerScreen extends StatefulWidget {
  const CameraFoodScannerScreen({super.key});

  @override
  State<CameraFoodScannerScreen> createState() => _CameraFoodScannerScreenState();
}

class _CameraFoodScannerScreenState extends State<CameraFoodScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerAnimController;
  late Animation<double> _scannerPosition;

  bool _isFlashOn = false;
  bool _isAnalyzing = false;
  int _selectedFoodIndex = 0;
  final TextEditingController _customFoodController = TextEditingController();

  final List<Map<String, dynamic>> _presetFoods = NutritionApiService.getPresetFoods();

  @override
  void initState() {
    super.initState();
    _scannerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scannerPosition = Tween<double>(begin: 0.15, end: 0.82).animate(
      CurvedAnimation(parent: _scannerAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerAnimController.dispose();
    _customFoodController.dispose();
    super.dispose();
  }

  Future<void> _performScan([String? query]) async {
    setState(() => _isAnalyzing = true);

    final searchQuery = query ?? (_presetFoods[_selectedFoodIndex]['name'] as String);
    final nutritionResult = await NutritionApiService.calculateFoodCalories(searchQuery);

    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    _showNutritionResultSheet(nutritionResult);
  }

  void _showNutritionResultSheet(Map<String, dynamic> data) {
    int servingMultiplier = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final int baseCal = data['calories'] as int;
            final int totalCal = baseCal * servingMultiplier;

            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E5EA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      children: [
                        // Food Image with AI Detection Badge
                        Container(
                          height: 190,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: AssetImage(data['imageUrl'] ?? 'assets/images/card_nutrition_full.png'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Vignette
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.75),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
                                      const SizedBox(width: 5),
                                      Text(
                                        'AI Match: ${data['confidence']}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 14,
                                right: 14,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.25),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        data['portion'] ?? '1 standard serving',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      data['healthScore'] ?? 'Grade A',
                                      style: const TextStyle(
                                        color: Color(0xFFFFB74D),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title & Calorie Badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF131519),
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Verified Nutrition Facts • Real-time API',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF757A86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.primary, Color(0xFFFF8A00)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '$totalCal',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const Text(
                                    'TOTAL KCAL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // 3 Macro Cards (Protein, Carbs, Fat)
                        Row(
                          children: [
                            _buildMacroPill('Protein', data['protein'] ?? '35g', const Color(0xFFFF5252), Icons.fitness_center_rounded),
                            const SizedBox(width: 8),
                            _buildMacroPill('Carbs', data['carbs'] ?? '42g', const Color(0xFF0284C7), Icons.bolt_rounded),
                            const SizedBox(width: 8),
                            _buildMacroPill('Fat', data['fat'] ?? '14g', const Color(0xFF8B5CF6), Icons.eco_rounded),
                            const SizedBox(width: 8),
                            _buildMacroPill('Fiber', data['fiber'] ?? '4g', const Color(0xFF10B981), Icons.spa_rounded),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Portion Multiplier Controls
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE8EBF0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Serving Quantity',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF131519),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Adjust portion size for accuracy',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF757A86),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.primary),
                                    onPressed: servingMultiplier > 1
                                        ? () => setModalState(() => servingMultiplier--)
                                        : null,
                                  ),
                                  Text(
                                    '$servingMultiplier',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF131519),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary),
                                    onPressed: () => setModalState(() => servingMultiplier++),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Detected Ingredients
                        const Text(
                          'Detected Ingredients & Composition:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF131519),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: (data['ingredients'] as List<dynamic>? ?? ['Fresh ingredients'])
                              .map(
                                (ing) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F3F6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    ing.toString(),
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF33373F),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 24),

                        // Primary Action Button: Log Meal
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context); // Close sheet
                              final loggedMeal = {
                                'title': data['name'],
                                'food': (data['ingredients'] as List<dynamic>?)?.join(' + ') ?? data['name'],
                                'cal': totalCal,
                                'protein': data['protein'],
                                'carbs': data['carbs'],
                                'fat': data['fat'],
                                'time': 'Just Now',
                                'icon': Icons.camera_alt_rounded,
                              };
                              Navigator.pop(context, loggedMeal); // Return to Calorie screen with meal data
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.add_task_rounded, size: 20),
                            label: Text(
                              'Log This Meal (+$totalCal kcal)',
                              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMacroPill(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF131519)),
            ),
          ],
        ),
      ),
    );
  }

  void _openCustomFoodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Analyze Custom Food', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type any food dish, fruit, or meal to calculate calories via live API:',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF757A86)),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _customFoodController,
                autofocus: true,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g. 2 eggs with avocado toast, or chicken pasta',
                  hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF9EA3AE)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF757A86))),
            ),
            ElevatedButton(
              onPressed: () {
                final query = _customFoodController.text.trim();
                Navigator.pop(context);
                if (query.isNotEmpty) {
                  _performScan(query);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Calculate Nutrition'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFood = _presetFoods[_selectedFoodIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. CAMERA VIEWPORT (LIVE FOOD SCENERY SIMULATOR)
          Positioned.fill(
            child: Image.asset(
              currentFood['imageUrl'] ?? 'assets/images/onboarding_athlete.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. DARK VIGNETTE & RETICLE OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),

          // 3. ANIMATED SCANNING LASER BEAM
          AnimatedBuilder(
            animation: _scannerAnimController,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * _scannerPosition.value,
                left: 36,
                right: 36,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFF00E5FF),
                        AppColors.primary,
                        Color(0xFF00E5FF),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.8),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 4. CORNER VIEWFINDER BRACKETS
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.76,
              height: MediaQuery.of(context).size.width * 0.76,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                children: [
                  // Corner Highlights
                  _buildCorner(Alignment.topLeft, true, true),
                  _buildCorner(Alignment.topRight, true, false),
                  _buildCorner(Alignment.bottomLeft, false, true),
                  _buildCorner(Alignment.bottomRight, false, false),

                  // Center Detection Pill
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00E5FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            currentFood['name'],
                            style: const TextStyle(
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
          ),

          // 5. TOP CONTROLS BAR (BACK, FLASH, AI TAG, CUSTOM SEARCH)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Close Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const Spacer(),

                  // AI Vision 2.0 Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 14),
                        SizedBox(width: 5),
                        Text(
                          'AI NUTRITION VISION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Flashlight Toggle
                  GestureDetector(
                    onTap: () => setState(() => _isFlashOn = !_isFlashOn),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isFlashOn ? AppColors.accentGold : Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Icon(
                        _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                        color: _isFlashOn ? Colors.black : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Search Custom Food Button
                  GestureDetector(
                    onTap: _openCustomFoodDialog,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. BOTTOM HUD & CONTROLS: PRESET FOOD CAROUSEL & SHUTTER BUTTON
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Preset Food Selection Chips (Tap to detect different foods)
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _presetFoods.length,
                    itemBuilder: (context, index) {
                      final item = _presetFoods[index];
                      final isSelected = _selectedFoodIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFoodIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${item['calories']} kcal',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.accentGold,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Main Camera Shutter Capture Button
                GestureDetector(
                  onTap: _isAnalyzing ? null : () => _performScan(),
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.transparent,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFFF8A00)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isAnalyzing
                            ? const SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'Point at food & tap to calculate calories',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment align, bool isTop, bool isLeft) {
    return Align(
      alignment: align,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: Color(0xFF00E5FF), width: 3.5) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: Color(0xFF00E5FF), width: 3.5) : BorderSide.none,
            left: isLeft ? const BorderSide(color: Color(0xFF00E5FF), width: 3.5) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: Color(0xFF00E5FF), width: 3.5) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
