import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class AiFoodScannerScreen extends StatefulWidget {
  const AiFoodScannerScreen({super.key});

  @override
  State<AiFoodScannerScreen> createState() => _AiFoodScannerScreenState();
}

class _AiFoodScannerScreenState extends State<AiFoodScannerScreen>
    with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  bool _hasScanned = false;
  late AnimationController _laserController;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  void _triggerScan() {
    setState(() {
      _isScanning = true;
      _hasScanned = false;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _hasScanned = true;
        });
      }
    });
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
        title: const Row(
          children: [
            Icon(Icons.camera_alt_outlined, color: Color(0xFF10B981), size: 20),
            SizedBox(width: 8),
            Text(
              'AI Food & Calorie Vision 📸',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Viewfinder simulation
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Meal image background
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/diet_healthy.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Dark camera overlay
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: _isScanning ? const Color(0xFF10B981) : Colors.white24,
                      width: 2,
                    ),
                  ),
                ),

                // Animated Laser Line when scanning
                if (_isScanning)
                  AnimatedBuilder(
                    animation: _laserController,
                    builder: (context, child) {
                      return Positioned(
                        top: 40 + (_laserController.value * 280),
                        left: 30,
                        right: 30,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.transparent, Color(0xFF10B981), Colors.transparent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withValues(alpha: 0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                // Viewfinder Corners
                Positioned(
                  top: 36,
                  left: 36,
                  child: _buildCorner(true, true),
                ),
                Positioned(
                  top: 36,
                  right: 36,
                  child: _buildCorner(true, false),
                ),
                Positioned(
                  bottom: 36,
                  left: 36,
                  child: _buildCorner(false, true),
                ),
                Positioned(
                  bottom: 36,
                  right: 36,
                  child: _buildCorner(false, false),
                ),

                // Scanning prompt pill
                Positioned(
                  top: 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      _isScanning
                          ? 'Scanning with AI Vision...'
                          : 'Point camera at your plate',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lower Panel: Scan button or Result Card
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF16181F),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: _hasScanned ? _buildScanResultView() : _buildPreScanView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreScanView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.document_scanner_rounded, color: Color(0xFF10B981), size: 44),
        const SizedBox(height: 12),
        const Text(
          'Instant AI Nutrition Detection',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        const Text(
          'Our AI identifies food items, estimates portion size in grams, and calculates exact calories & macros.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60, fontSize: 12.5),
        ),
        const Spacer(),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _isScanning ? null : _triggerScan,
          icon: _isScanning
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.camera_rounded, size: 22),
          label: Text(
            _isScanning ? 'Analyzing Meal...' : 'Scan Plate Now 📸',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildScanResultView() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Dish Title & Match Rate
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grilled Chicken & Jasmine Rice',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15.5),
                  ),
                  Text('98% AI Confidence • Healthy Clean Meal', style: TextStyle(color: Color(0xFF10B981), fontSize: 11.5, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('620', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
                Text('KCAL', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Macros Breakdown
        Row(
          children: [
            _buildMacroBadge('Protein', '54g', const Color(0xFF38BDF8)),
            const SizedBox(width: 8),
            _buildMacroBadge('Carbs', '68g', const Color(0xFFFBBF24)),
            const SizedBox(width: 8),
            _buildMacroBadge('Fats', '14g', const Color(0xFFF43F5E)),
          ],
        ),
        const SizedBox(height: 14),

        // Detected Components
        const Text('Detected Food Breakdown:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        _buildFoodItem('Grilled Chicken Breast (180g)', '280 kcal • 54g Protein'),
        _buildFoodItem('Steamed Jasmine Rice (200g)', '260 kcal • 56g Carbs'),
        _buildFoodItem('Steamed Broccoli & Avocado', '80 kcal • 8g Healthy Fats'),
        const SizedBox(height: 16),

        // Log Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Meal logged successfully (+620 kcal, +54g Protein) ✅'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
            Navigator.pop(context);
          },
          icon: const Icon(Icons.add_task_rounded, size: 20),
          label: const Text('Log to Today\'s Calories', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Widget _buildMacroBadge(String title, String val, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(val, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 14)),
            Text(title, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(String name, String detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          Text(detail, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Color(0xFF10B981), width: 3) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Color(0xFF10B981), width: 3) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Color(0xFF10B981), width: 3) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Color(0xFF10B981), width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}
