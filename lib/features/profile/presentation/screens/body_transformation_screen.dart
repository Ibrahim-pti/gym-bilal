import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class BodyTransformationScreen extends StatefulWidget {
  const BodyTransformationScreen({super.key});

  @override
  State<BodyTransformationScreen> createState() => _BodyTransformationScreenState();
}

class _BodyTransformationScreenState extends State<BodyTransformationScreen> {
  // Slider position from 0.0 (all before) to 1.0 (all after), default 0.5 (halfway)
  double _sliderValue = 0.5;

  // Selected angle: 'front', 'back', 'side'
  String _selectedAngle = 'front';

  // Selected metric tab: 'weight', 'bodyfat'
  String _selectedMetric = 'weight';

  // Logged weight entries for graph
  final List<Map<String, dynamic>> _weightHistory = [
    {'date': 'Wk 1 (Jan)', 'weight': 84.5, 'bodyFat': 22.0},
    {'date': 'Wk 4 (Feb)', 'weight': 82.0, 'bodyFat': 19.5},
    {'date': 'Wk 8 (Mar)', 'weight': 79.5, 'bodyFat': 16.0},
    {'date': 'Wk 12 (Apr)', 'weight': 77.2, 'bodyFat': 13.8},
    {'date': 'Current', 'weight': 76.0, 'bodyFat': 12.2},
  ];

  // Circumference measurements
  final List<Map<String, dynamic>> _measurements = [
    {
      'part': 'Chest',
      'before': '102 cm',
      'current': '110 cm',
      'diff': '+8 cm',
      'isGain': true,
      'icon': Icons.accessibility_new_rounded,
    },
    {
      'part': 'Arms (Biceps)',
      'before': '34.0 cm',
      'current': '39.5 cm',
      'diff': '+5.5 cm',
      'isGain': true,
      'icon': Icons.fitness_center_rounded,
    },
    {
      'part': 'Waist',
      'before': '89 cm',
      'current': '78 cm',
      'diff': '-11 cm',
      'isGain': false,
      'icon': Icons.straighten_rounded,
    },
    {
      'part': 'Thighs',
      'before': '54 cm',
      'current': '60 cm',
      'diff': '+6 cm',
      'isGain': true,
      'icon': Icons.directions_walk_rounded,
    },
    {
      'part': 'Shoulders',
      'before': '114 cm',
      'current': '122 cm',
      'diff': '+8 cm',
      'isGain': true,
      'icon': Icons.shield_rounded,
    },
  ];

  String get _beforeImage {
    switch (_selectedAngle) {
      case 'back':
        return 'assets/images/workout_back.jpg';
      case 'side':
        return 'assets/images/male_fitness_banner.jpg';
      default:
        return 'assets/images/splash_athlete.jpg';
    }
  }

  String get _afterImage {
    switch (_selectedAngle) {
      case 'back':
        return 'assets/images/pullup_figure.jpg';
      case 'side':
        return 'assets/images/card_gym_full.png';
      default:
        return 'assets/images/onboarding_athlete.jpg';
    }
  }

  void _showLogModal() {
    final weightController = TextEditingController(text: '76.0');
    final fatController = TextEditingController(text: '12.2');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Log Today\'s Progress 📸',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      suffixText: 'kg',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: fatController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Body Fat (%)',
                      suffixText: '%',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Attach New Progress Photo',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final newWeight = double.tryParse(weightController.text) ?? 76.0;
                  final newFat = double.tryParse(fatController.text) ?? 12.2;
                  setState(() {
                    _weightHistory.add({
                      'date': 'Today',
                      'weight': newWeight,
                      'bodyFat': newFat,
                    });
                  });
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 Progress successfully logged!'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save Entry', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          children: [
            Text(
              'Physique & Transformation',
              style: TextStyle(
                color: AppColors.lightTextPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(width: 6),
            Text('✨', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_rounded, color: AppColors.primary),
            onPressed: _showLogModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Angle Switcher (Front, Back, Side)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  _buildAngleButton('front', 'Front View'),
                  const SizedBox(width: 8),
                  _buildAngleButton('back', 'Back & Lats'),
                  const SizedBox(width: 8),
                  _buildAngleButton('side', 'Side Profile'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 1. Interactive Before/After Visual Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final height = constraints.maxHeight;

                      return GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _sliderValue = (_sliderValue + details.delta.dx / width).clamp(0.0, 1.0);
                          });
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // "AFTER" IMAGE (Base background full image)
                            Image.asset(
                              _afterImage,
                              fit: BoxFit.cover,
                              width: width,
                              height: height,
                            ),

                            // "BEFORE" IMAGE (Clipped with custom width)
                            ClipRect(
                              clipper: _HorizontalClipper(width * _sliderValue),
                              child: Image.asset(
                                _beforeImage,
                                fit: BoxFit.cover,
                                width: width,
                                height: height,
                              ),
                            ),

                            // "BEFORE" Tag (Top Left)
                            Positioned(
                              top: 14,
                              left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'BEFORE',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '84.5 kg • 22.0%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // "AFTER" Tag (Top Right)
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'CURRENT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '76.0 kg • 12.2%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Draggable Vertical Divider Line
                            Positioned(
                              left: (width * _sliderValue) - 1.5,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 3,
                                color: Colors.white,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.unfold_more_rounded,
                                        color: AppColors.primary,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Drag hint chip at bottom center
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.swipe_rounded, color: Colors.white, size: 14),
                                      SizedBox(width: 6),
                                      Text(
                                        'Slide left or right to compare',
                                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. High-Impact Stats Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatTile(
                    title: 'Weight Lost',
                    value: '-8.5 kg',
                    subtext: '12 Weeks Total',
                    color: const Color(0xFF10B981),
                    icon: Icons.trending_down_rounded,
                  ),
                  const SizedBox(width: 10),
                  _buildStatTile(
                    title: 'Body Fat %',
                    value: '-9.8%',
                    subtext: '22.0% -> 12.2%',
                    color: const Color(0xFFFF5252),
                    icon: Icons.local_fire_department_rounded,
                  ),
                  const SizedBox(width: 10),
                  _buildStatTile(
                    title: 'Lean Muscle',
                    value: '+3.4 kg',
                    subtext: 'Hypertrophy Gain',
                    color: AppColors.primary,
                    icon: Icons.fitness_center_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 3. Weight & Body Fat Progress Timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress Timeline',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.lightTextPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  // Metric Switcher (Weight vs Body Fat)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _buildMetricTab('weight', 'Weight (kg)'),
                        _buildMetricTab('bodyfat', 'Body Fat (%)'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Interactive Progress Nodes Graph
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _weightHistory.map((item) {
                        final isWeight = _selectedMetric == 'weight';
                        final double val = isWeight
                            ? (item['weight'] as double)
                            : (item['bodyFat'] as double);

                        // Calculate height relative to max
                        final double minVal = isWeight ? 74.0 : 10.0;
                        final double maxVal = isWeight ? 86.0 : 24.0;
                        final double fraction = ((val - minVal) / (maxVal - minVal)).clamp(0.2, 1.0);
                        final double barHeight = 110 * fraction;

                        final isCurrent = item['date'] == 'Current';

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              isWeight ? '$val' : '$val%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isCurrent ? AppColors.primary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 32,
                              height: barHeight,
                              decoration: BoxDecoration(
                                gradient: isCurrent
                                    ? AppColors.buttonGradient
                                    : LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.grey.shade300,
                                          Colors.grey.shade200,
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['date'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                                color: isCurrent ? AppColors.primary : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            // 4. Body Circumference Measurements Table
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Body Circumference Logs',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.lightTextPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Tape Measurements',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _measurements.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, index) {
                    final m = _measurements[index];
                    final isGain = m['isGain'] as bool;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(m['icon'] as IconData, color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m['part'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Was: ${m['before']}',
                                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                m['current'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.5,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isGain
                                      ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                      : const Color(0xFF3B82F6).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  m['diff'] as String,
                                  style: TextStyle(
                                    color: isGain ? const Color(0xFF059669) : const Color(0xFF2563EB),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAngleButton(String angle, String label) {
    final isSelected = _selectedAngle == angle;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAngle = angle;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTab(String metric, String label) {
    final isSelected = _selectedMetric == metric;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMetric = metric;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.lightTextPrimary : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required String subtext,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.lightTextPrimary,
              ),
            ),
            Text(
              subtext,
              style: TextStyle(
                fontSize: 9.5,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalClipper extends CustomClipper<Rect> {
  final double clipWidth;
  _HorizontalClipper(this.clipWidth);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, clipWidth, size.height);
  }

  @override
  bool shouldReclip(covariant _HorizontalClipper oldClipper) {
    return oldClipper.clipWidth != clipWidth;
  }
}
