import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class WaterWaveTrackerSheet extends StatefulWidget {
  final double currentLiters;
  final double goalLiters;
  final Function(double)? onWaterUpdated;

  const WaterWaveTrackerSheet({
    super.key,
    this.currentLiters = 1.8,
    this.goalLiters = 2.5,
    this.onWaterUpdated,
  });

  @override
  State<WaterWaveTrackerSheet> createState() => _WaterWaveTrackerSheetState();
}

class _WaterWaveTrackerSheetState extends State<WaterWaveTrackerSheet>
    with SingleTickerProviderStateMixin {
  late double _current;
  late double _goal;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _current = widget.currentLiters;
    _goal = widget.goalLiters;
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _addWater(double amount) {
    setState(() {
      _current = min(_current + amount, _goal * 1.5);
    });
    widget.onWaterUpdated?.call(_current);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_current / _goal).clamp(0.0, 1.0);
    final percentInt = (progress * 100).toInt();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hydration Wave Tracker 💧',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Optimal muscle hydration & recovery',
                    style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Animated Fluid Wave Container
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F9FF),
              border: Border.all(color: const Color(0xFFBAE6FD), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated Wave
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(180, 180),
                        painter: _WavePainter(
                          progress: progress,
                          wavePhase: _waveController.value * 2 * pi,
                        ),
                      );
                    },
                  ),
                  // Water Text Overlay
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_current.toStringAsFixed(1)}L',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.lightTextPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        '$percentInt% of ${_goal.toStringAsFixed(1)}L Goal',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Add Buttons
          Row(
            children: [
              _buildAddBtn('+250ml', 'Cup 🥛', 0.25),
              const SizedBox(width: 10),
              _buildAddBtn('+500ml', 'Bottle 💧', 0.50),
              const SizedBox(width: 10),
              _buildAddBtn('+750ml', 'Shaker 🥤', 0.75),
            ],
          ),
          const SizedBox(height: 16),

          // Hydration Tip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Color(0xFF0284C7), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Drinking 500ml before workout boosts muscular strength by 15%.',
                    style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddBtn(String label, String sub, double amount) {
    return Expanded(
      child: InkWell(
        onTap: () => _addWater(amount),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF0284C7),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: const TextStyle(color: Color(0xFF0369A1), fontSize: 10.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final double wavePhase;

  _WavePainter({required this.progress, required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final waveHeight = 8.0;
    final waterLevel = size.height * (1.0 - progress);

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, waterLevel);

    for (double x = 0; x <= size.width; x++) {
      double y = waterLevel + sin((x / size.width * 2 * pi) + wavePhase) * waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, waterLevel, size.width, size.height - waterLevel));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.wavePhase != wavePhase;
  }
}
