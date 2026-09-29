import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/profile/presentation/widgets/gym_pass_sheet.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  final String? initialPlanId;

  const SubscriptionPlansScreen({super.key, this.initialPlanId});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  late String _selectedPlanId;
  String _selectedPayment = 'fib'; // 'fib', 'fastpay', 'cash'

  final List<Map<String, dynamic>> _plans = [
    {
      'id': '1_year',
      'title': 'Annual VIP Pass',
      'duration': '12 Months',
      'badge': 'BEST VALUE • SAVE 40%',
      'price': '340,000',
      'period': 'year',
      'monthlyEquivalent': '28,300 IQD / mo',
      'isPopular': false,
      'isBestValue': true,
      'accentColor': const Color(0xFF10B981),
      'perks': [
        'All Erbil branches unrestricted access',
        'Personal Trainer sessions included',
        'Free monthly InBody body composition scan',
        'Sauna, Jacuzzi & VIP Locker access',
        '20% OFF at Protein & Shake Bar',
      ],
    },
    {
      'id': '3_months',
      'title': 'Quarterly Pro',
      'duration': '3 Months',
      'badge': 'MOST POPULAR 🔥',
      'price': '110,000',
      'period': '3 mos',
      'monthlyEquivalent': '36,600 IQD / mo',
      'isPopular': true,
      'isBestValue': false,
      'accentColor': AppColors.primary,
      'perks': [
        'Full gym & equipment access',
        'Unlimited AI Coach Bilal in-app guidance',
        'Weekly Sauna & Jacuzzi entry',
        'Custom workout & macro nutrition plans',
      ],
    },
    {
      'id': '1_month',
      'title': 'Monthly Flex',
      'duration': '1 Month',
      'badge': null,
      'price': '45,000',
      'period': 'month',
      'monthlyEquivalent': 'Standard flexible rate',
      'isPopular': false,
      'isBestValue': false,
      'accentColor': const Color(0xFF64748B),
      'perks': [
        'Full access to all workout machines',
        'Digital QR entry pass on your phone',
        'Calorie, hydration & step tracking',
        'General locker room access',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedPlanId = widget.initialPlanId ?? '3_months';
  }

  Map<String, dynamic> get _currentPlan {
    return _plans.firstWhere(
      (p) => p['id'] == _selectedPlanId,
      orElse: () => _plans[1],
    );
  }

  void _onConfirmSubscription() {
    final plan = _currentPlan;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF181A20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Membership Activated! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You are now an active member of ${plan['title']} at Bilal Gym. Your digital QR pass is ready for check-in.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${plan['price']} IQD',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const GymPassSheet(),
                        );
                      },
                      child: const Text('View Pass 🎟️', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context, plan);
                      },
                      child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0D10),
      body: Stack(
        children: [
          // Background ambient gradient
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: -100,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFFB800).withValues(alpha: 0.35)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.workspace_premium_rounded, size: 13, color: Color(0xFFFFB800)),
                            SizedBox(width: 4),
                            Text(
                              'BILAL GYM PRO',
                              style: TextStyle(
                                color: Color(0xFFFFB800),
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const GymPassSheet(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Scrollable Body
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                    children: [
                      // Hero Header Banner
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/workout_back.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                const Color(0xFF0C0D10),
                                const Color(0xFF0C0D10).withValues(alpha: 0.5),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.65, 1.0],
                            ),
                          ),
                          padding: const EdgeInsets.all(18),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Unlock Your ',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Full Potential',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primary,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Select your membership to access all gym zones & elite AI coaching.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Feature Pills Carousel
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFeaturePill(Icons.fitness_center_rounded, 'Full Gym Access'),
                            const SizedBox(width: 8),
                            _buildFeaturePill(Icons.auto_awesome_rounded, 'AI Coach Bilal'),
                            const SizedBox(width: 8),
                            _buildFeaturePill(Icons.hot_tub_rounded, 'Sauna & Jacuzzi'),
                            const SizedBox(width: 8),
                            _buildFeaturePill(Icons.restaurant_menu_rounded, 'Diet Protocols'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Choose Membership Plan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            'No commitments • Cancel anytime',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // The 3 Plan Cards
                      ..._plans.map((plan) => _buildModernPlanCard(plan)),

                      const SizedBox(height: 14),

                      // Payment Method Selector
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14161C),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Payment Method',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Secured & Encrypted 🔒',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _buildPaymentOption('fib', 'FIB Bank 💳'),
                                const SizedBox(width: 8),
                                _buildPaymentOption('fastpay', 'FastPay 📱'),
                                const SizedBox(width: 8),
                                _buildPaymentOption('cash', 'Pay at Gym 💵'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // What's included checklist
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14161C),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'All Memberships Include:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...[
                              'Instant digital pass for Erbil gym branch entry',
                              '24/7 AI-driven workout recommendations',
                              'Full body macro & hydration dashboard',
                              'Free locker room & warm shower facilities',
                            ].map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3.5),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, size: 15, color: Color(0xFF10B981)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.75),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Floating Checkout Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C0D10).withValues(alpha: 0.88),
                    border: Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPlan['title'],
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${_currentPlan['price']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                'IQD',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shadowColor: AppColors.primary.withValues(alpha: 0.45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _onConfirmSubscription,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue to Payment',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward_rounded, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String id, String title) {
    final isSelected = _selectedPayment == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPayment = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.08),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernPlanCard(Map<String, dynamic> plan) {
    final isSelected = _selectedPlanId == plan['id'];
    final badge = plan['badge'] as String?;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanId = plan['id']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF181B23) : const Color(0xFF121419),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge Banner (if popular or best value)
            if (badge != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : const Color(0xFF232733),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  children: [
                    Text(
                      badge,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFFFFB800),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Title + Radio Checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plan['monthlyEquivalent'],
                            style: TextStyle(
                              color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    plan['price'],
                                    style: TextStyle(
                                      color: isSelected ? AppColors.primary : Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'IQD',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '/ ${plan['period']}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.white30,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
                  const SizedBox(height: 8),

                  // Perks List
                  Column(
                    children: (plan['perks'] as List<String>).map((perk) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_rounded,
                              size: 13,
                              color: isSelected ? AppColors.primary : const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                perk,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.72),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
