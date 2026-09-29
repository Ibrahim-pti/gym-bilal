import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/profile/presentation/widgets/gym_pass_sheet.dart';
import 'package:rasedi_flutter_sdk/rasedi_flutter_sdk.dart';
import 'package:gym_base/core/services/rasedi_payment_service.dart';
import 'package:gym_base/core/widgets/rasedi_webview_screen.dart'; // RasediNativePaymentProcessor



class SubscriptionPlansScreen extends StatefulWidget {
  final String? initialPlanId;

  const SubscriptionPlansScreen({super.key, this.initialPlanId});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  late String _selectedPlanId;
  String _selectedPayment = 'fib'; // 'fib', 'fastpay', 'card', 'cash'
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'fib',
      'title': 'FIB Bank (First Iraqi Bank)',
      'subtitle': 'Pay instantly with FIB app or QR scan',
      'badge': 'RECOMMENDED ⚡',
      'icon': Icons.account_balance_rounded,
      'color': const Color(0xFF00A59B),
      'instructions': 'You will be redirected to the secure FIB checkout. Scan the QR code or approve the transfer in your FIB mobile banking app.',
      'gateways': [Gateway.FIB],
      'steps': [
        'Tap proceed to generate a secure FIB payment session.',
        'Open your FIB mobile banking app and scan the QR code or tap approve.',
        'Authorize the transfer of {amount} IQD in your FIB app.',
        'Return to the app — your Bilal Gym pass activates instantly.',
      ],
    },
    {
      'id': 'fastpay',
      'title': 'FastPay Wallet',
      'subtitle': 'Direct payment from FastPay mobile balance',
      'badge': 'INSTANT 📱',
      'icon': Icons.phone_android_rounded,
      'color': const Color(0xFFE50046),
      'instructions': 'You will be redirected to FastPay. Enter your FastPay mobile number and PIN to authorize the payment.',
      'gateways': [Gateway.FAST_PAY],
      'steps': [
        'Tap proceed to launch the FastPay secure payment gateway.',
        'Enter your registered FastPay mobile number & 6-digit PIN.',
        'Enter the one-time verification OTP sent via SMS to your phone.',
        'Your membership pass activates right away upon successful charge.',
      ],
    },
    {
      'id': 'card',
      'title': 'Credit / Debit Card',
      'subtitle': 'Visa, MasterCard & local electronic cards',
      'badge': '3D SECURE 💳',
      'icon': Icons.credit_card_rounded,
      'color': const Color(0xFF6366F1),
      'instructions': 'You will be redirected to Rasedi PCI-DSS secure checkout. Enter your card number, expiration date, and CVV.',
      'gateways': [Gateway.CREDIT_CARD],
      'steps': [
        'Proceed to Rasedi PCI-DSS certified secure payment screen.',
        'Enter your 16-digit card number, expiration date, and CVV.',
        'Complete the 3D-Secure SMS verification with your issuing bank.',
        'Receive instant digital receipt and access pass in the app.',
      ],
    },
    {
      'id': 'cash',
      'title': 'Pay Cash at Reception',
      'subtitle': 'Reserve your plan & pay cash at Bilal Gym',
      'badge': 'IN-PERSON 💵',
      'icon': Icons.storefront_rounded,
      'color': const Color(0xFF10B981),
      'instructions': 'Reserve your pass now. Present your booking reference to the receptionist at Bilal Gym to complete payment.',
      'gateways': <Gateway>[],
      'steps': [
        'Tap the reserve button to lock in this membership plan and price.',
        'A reservation code will be generated and saved to your profile.',
        'Visit Bilal Gym reception desk in Erbil within 48 hours.',
        'Pay {amount} IQD in cash to receive your official physical RFID keycard.',
      ],
    },
  ];

  final List<Map<String, dynamic>> _plans = [
    {
      'id': '1_year',
      'title': 'Annual VIP Pass',
      'duration': '12 Months',
      'badge': 'BEST VALUE • SAVE 40%',
      'price': '340,000',
      'rawAmount': '340000',
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
      'rawAmount': '110000',
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
      'rawAmount': '45000',
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

  Widget _buildOfficialPaymentLogo(String methodId) {
    switch (methodId) {
      case 'fib':
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF00A59B).withValues(alpha: 0.5),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00A59B).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              'assets/images/fib_logo.png',
              fit: BoxFit.cover,
            ),
          ),
        );

      case 'fastpay':
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE50046).withValues(alpha: 0.5),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE50046).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              'assets/images/fastpay_logo.png',
              fit: BoxFit.cover,
            ),
          ),
        );

      case 'card':
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
            ),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.22),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 26,
                  height: 16,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEB001B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        );

      case 'cash':
      default:
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF064E3B), Color(0xFF065F46)],
            ),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.payments_rounded, color: Color(0xFF34D399), size: 19),
                SizedBox(height: 1),
                Text(
                  'CASH',
                  style: TextStyle(
                    color: Color(0xFF34D399),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  void _showPaymentMethodPicker(Map<String, dynamic> plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (context, setModalState) {
          final selectedMethod = _paymentMethods.firstWhere(
            (m) => m['id'] == _selectedPayment,
            orElse: () => _paymentMethods[0],
          );
          final List<String> steps = List<String>.from(selectedMethod['steps'] ?? []);

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF111319),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 44,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Modal Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose Payment Method',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                '${plan['title']} • ',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${plan['price']} IQD',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white60),
                        onPressed: () => Navigator.pop(sheetCtx),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),

                // Scrollable Payment Methods + Instructions
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELECT PAYMENT METHOD',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),

                        ..._paymentMethods.map((method) {
                          final isSelected = _selectedPayment == method['id'];
                          final Color methodColor = method['color'];

                          return GestureDetector(
                            onTap: () {
                              setModalState(() => _selectedPayment = method['id']);
                              setState(() => _selectedPayment = method['id']);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1B1E28)
                                    : const Color(0xFF151720),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white.withValues(alpha: 0.08),
                                  width: isSelected ? 1.8 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.12),
                                          blurRadius: 16,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  _buildOfficialPaymentLogo(method['id']),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                method['title'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                              decoration: BoxDecoration(
                                                color: methodColor.withValues(alpha: 0.16),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                method['badge'],
                                                style: TextStyle(
                                                  color: methodColor,
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          method['subtitle'],
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.55),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? AppColors.primary : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : Colors.white38,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 6),

                        // How to pay container
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF171A24),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.format_list_numbered_rounded,
                                      size: 15,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'How to pay with ${selectedMethod['title'].toString().split(" (").first}:',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...steps.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final String stepText = entry.value;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 9),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        margin: const EdgeInsets.only(top: 1),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary.withValues(alpha: 0.18),
                                          border: Border.all(
                                            color: AppColors.primary.withValues(alpha: 0.4),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          stepText.replaceAll('{amount}', plan['price']),
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.8),
                                            fontSize: 11.5,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Modal Bottom CTA
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1116),
                    border: Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shadowColor: AppColors.primary.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {
                            Navigator.pop(sheetCtx);
                            _processPayment(plan, selectedMethod);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedMethod['id'] == 'cash'
                                    ? 'Reserve Pass & Pay at Gym ➔'
                                    : 'Pay ${plan['price']} IQD with ${selectedMethod['title'].toString().split(" (").first} ➔',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selectedMethod['id'] == 'cash' ? Icons.storefront_outlined : Icons.lock_outline_rounded,
                            size: 11,
                            color: Colors.white38,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            selectedMethod['id'] == 'cash'
                                ? 'No upfront charge • Pay in cash at gym reception'
                                : 'Secured 256-bit encryption by Rasedi Payment Gateway',
                            style: const TextStyle(color: Colors.white38, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _processPayment(Map<String, dynamic> plan, Map<String, dynamic> method) async {
    if (method['id'] == 'cash') {
      _showSuccessDialog(plan, isCashPayment: true);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final List<Gateway> gateways = List<Gateway>.from(method['gateways']);

      final response = await RasediPaymentService().initiatePlanPayment(
        planTitle: plan['title'],
        rawAmount: plan['rawAmount'],
        duration: plan['duration'],
        preferredGateways: gateways.isNotEmpty ? gateways : null,
      );

      setState(() => _isProcessing = false);

      if (!mounted) return;

      // Open native payment processor — hidden WebView + opens banking app directly
      await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => RasediNativePaymentProcessor(
            checkoutUrl: response.body.redirectUrl,
            referenceCode: response.body.referenceCode,
            planTitle: plan['title'],
            amount: plan['price'],
            gatewayName: method['title'].toString().split(' (').first,
            onPaymentClosed: () {
              Navigator.of(context).pop();
              // Show verification sheet so user can check payment status
              _showPaymentVerificationSheet(
                plan: plan,
                method: method,
                referenceCode: response.body.referenceCode,
                redirectUrl: response.body.redirectUrl,
              );
            },
          ),
        ),
      );
    } catch (e) {
      setState(() => _isProcessing = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment initiation failed: ${e.toString().replaceAll("Exception: ", "")}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }


  void _showPaymentVerificationSheet({
    required Map<String, dynamic> plan,
    Map<String, dynamic>? method,
    required String referenceCode,
    required String redirectUrl,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (context, setSheetState) {
          bool isChecking = false;
          String statusText = 'Waiting for payment confirmation...';
          Color statusColor = const Color(0xFFFBBF24);

          Future<void> checkStatus() async {
            setSheetState(() => isChecking = true);
            try {
              final status = await RasediPaymentService().checkPaymentStatus(referenceCode);
              setSheetState(() {
                isChecking = false;
                if (status == PaymentStatus.PAID) {
                  statusText = 'Payment Successful! 🎉';
                  statusColor = const Color(0xFF10B981);
                } else if (status == PaymentStatus.FAILED || status == PaymentStatus.CANCELED) {
                  statusText = 'Payment $status';
                  statusColor = Colors.redAccent;
                } else {
                  statusText = 'Status: $status (Pending)';
                  statusColor = const Color(0xFFFBBF24);
                }
              });

              if (status == PaymentStatus.PAID) {
                await Future.delayed(const Duration(milliseconds: 600));
                if (context.mounted) {
                  Navigator.pop(sheetCtx);
                  _showSuccessDialog(plan, referenceCode: referenceCode);
                }
              }
            } catch (err) {
              setSheetState(() {
                isChecking = false;
                statusText = 'Error checking: $err';
              });
            }
          }

          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF14161C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildOfficialPaymentLogo(method?['id'] ?? 'fib'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rasedi Payment Gateway 🔒',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white60),
                      onPressed: () => Navigator.pop(sheetCtx),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Selected Plan:',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                          Text(
                            plan['title'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Amount Due:',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                          Text(
                            '${plan['price']} IQD',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.white.withValues(alpha: 0.06)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: statusColor),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              statusText,
                              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(sheetCtx);
                          final ok = await RasediPaymentService().openPaymentUrl(redirectUrl);
                          if (!ok && sheetCtx.mounted) {
                            await Clipboard.setData(ClipboardData(text: redirectUrl));
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Payment link copied to clipboard! 📋 Paste in browser.'),
                                backgroundColor: Color(0xFF0077B6),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 15),
                        label: const Text('Open / Copy Link', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: isChecking ? null : checkStatus,
                        icon: isChecking
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Verify Status', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog(
    Map<String, dynamic> plan, {
    bool isCashPayment = false,
    String? referenceCode,
  }) {
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
              Text(
                isCashPayment ? 'Plan Reserved! 🎉' : 'Payment Successful! 🎉',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isCashPayment
                    ? 'You have reserved ${plan['title']}. Please complete payment at the gym reception desk to get your stamp.'
                    : 'Your payment via Rasedi has been confirmed! You are now an active ${plan['title']} member.',
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
                      referenceCode != null ? 'Ref: #$referenceCode' : 'Total Amount:',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
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
                            onPressed: _isProcessing ? null : () => _showPaymentMethodPicker(_currentPlan),
                            child: _isProcessing
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                  )
                                : const Row(
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
