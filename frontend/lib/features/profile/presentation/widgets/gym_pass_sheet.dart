import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gym_base/core/services/api_service.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/profile/presentation/screens/subscription_plans_screen.dart';

class GymPassSheet extends StatefulWidget {
  const GymPassSheet({super.key});

  @override
  State<GymPassSheet> createState() => _GymPassSheetState();
}

class _GymPassSheetState extends State<GymPassSheet> {
  Map<String, dynamic>? _member;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMember();
  }

  Future<void> _loadMember() async {
    final m = await ApiService().getSavedMember();
    if (mounted) {
      setState(() {
        _member = m;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final barcode = _member?['barcode'] ?? 'GB-MEMBER-PASS';
    final name = _member?['name'] ?? 'Gym Member';
    final sub = _member?['subscription'];
    final planName = sub?['plan_name'] ?? 'مانگانە (Monthly)';
    final daysLeft = sub?['days_left'] ?? 30;
    final bool isActive = (_member?['status'] == 'active') || daysLeft > 0;

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'کارتی دیجیتاڵی جیم 🎟️',
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'پشکنینی هاتنەژوورەوە لە ڕیسێپشن',
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 12,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BILAL GYM PASS',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),
                            Text(
                              'Digital Membership',
                              style: GoogleFonts.outfit(
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
                        color: (isActive ? const Color(0xFF10B981) : Colors.redAccent).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isActive ? const Color(0xFF10B981) : Colors.redAccent),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: isActive ? const Color(0xFF10B981) : Colors.redAccent, size: 7),
                          const SizedBox(width: 5),
                          Text(
                            isActive ? 'کارایە (ACTIVE)' : 'بەسەرچووە',
                            style: GoogleFonts.notoSansArabic(
                              color: isActive ? const Color(0xFF10B981) : Colors.redAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // QR Code Display with qr_flutter
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: QrImageView(
                          data: barcode,
                          version: QrVersions.auto,
                          size: 140,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '#$barcode',
                        style: GoogleFonts.outfit(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
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
                      children: [
                        Text(
                          'ئەندام (MEMBER)',
                          style: GoogleFonts.notoSansArabic(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name,
                          style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'پلان (PLAN)',
                          style: GoogleFonts.notoSansArabic(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$planName ($daysLeft ڕۆژ)',
                          style: GoogleFonts.notoSansArabic(color: const Color(0xFFFBBF24), fontSize: 13, fontWeight: FontWeight.w900),
                        ),
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubscriptionPlansScreen()),
                );
              },
              icon: const Icon(Icons.bolt_rounded, color: Colors.white),
              label: Text(
                'نوێکردنەوە یان گۆڕینی پلان ⚡',
                style: GoogleFonts.notoSansArabic(
                  fontSize: 14,
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
