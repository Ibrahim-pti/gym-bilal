import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/profile/presentation/screens/subscription_plans_screen.dart';


class GymPassSheet extends StatelessWidget {
  const GymPassSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
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
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Digital Gym Pass 🎟️',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Scan at reception or entrance gate',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.lightTextSecondary,
                    ),
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

          // Member Pass Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2129), Color(0xFF101216)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BILAL GYM PASS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),
                            Text(
                              'Digital Membership',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF10B981)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Color(0xFF10B981), size: 7),
                          SizedBox(width: 5),
                          Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // QR Code Display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Simulated QR Matrix
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CustomPaint(
                          painter: _QrPainter(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '#GB-MEMBER-PASS',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Member Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('MEMBER', style: TextStyle(color: Colors.white54, fontSize: 9.5, fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text('Gym Member', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('STATUS', style: TextStyle(color: Colors.white54, fontSize: 9.5, fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text('Active Pass', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 14, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Benefits row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPerk('Locker Room', Icons.lock_outline),
              _buildPerk('Sauna & Jacuzzi', Icons.hot_tub_rounded),
              _buildPerk('Towel Service', Icons.check_circle_outline_rounded),
            ],
          ),
          const SizedBox(height: 18),

          // Renew & Change Plan Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Close sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubscriptionPlansScreen()),
                );
              },
              icon: const Icon(Icons.bolt_rounded, color: Colors.white),
              label: const Text(
                'Change or Renew Plan ⚡',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerk(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Corner Finder Patterns
    _drawFinder(canvas, paint, const Offset(10, 10), 32);
    _drawFinder(canvas, paint, Offset(size.width - 42, 10), 32);
    _drawFinder(canvas, paint, Offset(10, size.height - 42), 32);

    // Decorative Data Dots
    final dotSize = size.width / 14;
    for (int r = 0; r < 12; r++) {
      for (int c = 0; c < 12; c++) {
        // Skip corner finder zones
        if ((r < 4 && c < 4) || (r < 4 && c > 7) || (r > 7 && c < 4)) continue;
        if ((r * 7 + c * 13) % 3 == 0) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(c * dotSize + 12, r * dotSize + 12, dotSize * 0.75, dotSize * 0.75),
              const Radius.circular(2),
            ),
            paint,
          );
        }
      }
    }
  }

  void _drawFinder(Canvas canvas, Paint paint, Offset offset, double size) {
    // Outer box
    final outerRect = Rect.fromLTWH(offset.dx, offset.dy, size, size);
    canvas.drawRRect(RRect.fromRectAndRadius(outerRect, const Radius.circular(6)), paint);

    // White gap
    final whitePaint = Paint()..color = Colors.white;
    final innerRect = Rect.fromLTWH(offset.dx + 4, offset.dy + 4, size - 8, size - 8);
    canvas.drawRRect(RRect.fromRectAndRadius(innerRect, const Radius.circular(4)), whitePaint);

    // Center dot
    final centerRect = Rect.fromLTWH(offset.dx + 9, offset.dy + 9, size - 18, size - 18);
    canvas.drawRRect(RRect.fromRectAndRadius(centerRect, const Radius.circular(3)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
