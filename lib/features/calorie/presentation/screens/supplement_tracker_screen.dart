import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/core/services/notification_service.dart';

class SupplementTrackerScreen extends StatefulWidget {
  const SupplementTrackerScreen({super.key});

  @override
  State<SupplementTrackerScreen> createState() => _SupplementTrackerScreenState();
}

class _SupplementTrackerScreenState extends State<SupplementTrackerScreen> {
  // Selected category filter: 'all', 'pre', 'post', 'daily'
  String _selectedCategory = 'all';

  // Daily Supplements List with reminder times
  final List<Map<String, dynamic>> _supplements = [
    {
      'id': 1,
      'name': 'Creatine Monohydrate',
      'brand': 'Creapure Micronized',
      'dosage': '5g',
      'timing': 'Pre / Post Workout',
      'timeWindow': '45m before workout',
      'category': 'pre',
      'taken': true,
      'color': const Color(0xFF3B82F6),
      'icon': Icons.bolt_rounded,
      'instructions': 'Dissolve in 300ml of water or fruit juice. Increases intramuscular phosphocreatine for raw strength output.',
      'streak': 18,
      'reminderEnabled': true,
      'reminderHour': 16,
      'reminderMinute': 30,
      'reminderTime': '04:30 PM',
    },
    {
      'id': 2,
      'name': 'Whey Isolate Protein',
      'brand': '100% Hydrolyzed Whey',
      'dosage': '30g Protein (1 Scoop)',
      'timing': 'Post-Workout Anabolic Window',
      'timeWindow': 'Within 30m after training',
      'category': 'post',
      'taken': true,
      'color': AppColors.primary,
      'icon': Icons.fitness_center_rounded,
      'instructions': 'Mix with cold water or almond milk. Rapid leucine spike to maximize Muscle Protein Synthesis (MPS).',
      'streak': 24,
      'reminderEnabled': true,
      'reminderHour': 18,
      'reminderMinute': 0,
      'reminderTime': '06:00 PM',
    },
    {
      'id': 3,
      'name': 'Pre-Workout Ignition',
      'brand': 'High Voltage Pump & Focus',
      'dosage': '1 Scoop (200mg Caffeine + 3g Citrulline)',
      'timing': 'Pre-Workout Energy',
      'timeWindow': '30m prior to heavy lifts',
      'category': 'pre',
      'taken': false,
      'color': const Color(0xFFFF5252),
      'icon': Icons.local_fire_department_rounded,
      'instructions': 'Enhances nitric oxide blood flow, muscular endurance, and neurological drive.',
      'streak': 9,
      'reminderEnabled': true,
      'reminderHour': 16,
      'reminderMinute': 0,
      'reminderTime': '04:00 PM',
    },
    {
      'id': 4,
      'name': 'Omega-3 Fish Oil (EPA / DHA)',
      'brand': 'Triple Strength Molecular Distilled',
      'dosage': '2 Capsules (1200mg EPA + 900mg DHA)',
      'timing': 'Morning Breakfast',
      'timeWindow': 'With first fatty meal',
      'category': 'daily',
      'taken': true,
      'color': const Color(0xFFF59E0B),
      'icon': Icons.favorite_rounded,
      'instructions': 'Supports joint cartilage integrity, reduces systemic inflammation, and accelerates muscle recovery.',
      'streak': 30,
      'reminderEnabled': true,
      'reminderHour': 8,
      'reminderMinute': 30,
      'reminderTime': '08:30 AM',
    },
    {
      'id': 5,
      'name': 'Multivitamin + Vitamin D3 & K2',
      'brand': 'Elite Athletic Spectrum',
      'dosage': '1 Tablet + 5000 IU D3',
      'timing': 'Morning Health',
      'timeWindow': 'With breakfast',
      'category': 'daily',
      'taken': true,
      'color': const Color(0xFF10B981),
      'icon': Icons.eco_rounded,
      'instructions': 'Replenishes essential micronutrients lost during heavy sweat sessions.',
      'streak': 28,
      'reminderEnabled': true,
      'reminderHour': 8,
      'reminderMinute': 30,
      'reminderTime': '08:30 AM',
    },
    {
      'id': 6,
      'name': 'ZMA (Zinc, Magnesium & B6)',
      'brand': 'Nighttime Deep Sleep Formula',
      'dosage': '3 Capsules (30mg Zn + 450mg Mg)',
      'timing': 'Night Recovery',
      'timeWindow': '30-45m before sleep on empty stomach',
      'category': 'post',
      'taken': false,
      'color': const Color(0xFF8B5CF6),
      'icon': Icons.bedtime_rounded,
      'instructions': 'Promotes deep stage 4 REM sleep, nervous system relaxation, and natural testosterone synthesis.',
      'streak': 14,
      'reminderEnabled': true,
      'reminderHour': 22,
      'reminderMinute': 30,
      'reminderTime': '10:30 PM',
    },
  ];

  int get _takenCount => _supplements.where((s) => s['taken'] == true).length;
  double get _completionPercent => _supplements.isEmpty ? 0.0 : _takenCount / _supplements.length;

  List<Map<String, dynamic>> get _filteredSupplements {
    if (_selectedCategory == 'all') return _supplements;
    return _supplements.where((s) => s['category'] == _selectedCategory).toList();
  }

  void _toggleTaken(Map<String, dynamic> supp) {
    setState(() {
      supp['taken'] = !(supp['taken'] as bool);
      if (supp['taken'] == true) {
        supp['streak'] = (supp['streak'] as int) + 1;
      } else {
        supp['streak'] = (supp['streak'] as int) - 1;
      }
    });
  }

  // --- Pick & Schedule Local Notification ---
  Future<void> _pickReminderTime(Map<String, dynamic> supp) async {
    final initialHour = supp['reminderHour'] as int? ?? 8;
    final initialMinute = supp['reminderMinute'] as int? ?? 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      helpText: 'Select daily reminder time for ${supp['name']}',
    );

    if (picked != null) {
      final hourStr = picked.hourOfPeriod == 0 ? '12' : picked.hourOfPeriod.toString().padLeft(2, '0');
      final minuteStr = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final formattedTime = '$hourStr:$minuteStr $period';

      setState(() {
        supp['reminderHour'] = picked.hour;
        supp['reminderMinute'] = picked.minute;
        supp['reminderTime'] = formattedTime;
        supp['reminderEnabled'] = true;
      });

      // Schedule with local notifications
      await NotificationService().scheduleDailySupplementNotification(
        id: supp['id'] as int,
        title: 'Time for ${supp['name']} 💊',
        body: 'Take ${supp['dosage']} • ${supp['instructions']}',
        hour: picked.hour,
        minute: picked.minute,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Daily reminder set for ${supp['name']} at $formattedTime 🔔',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  OverlayEntry? _bannerOverlay;

  @override
  void dispose() {
    _bannerOverlay?.remove();
    _bannerOverlay = null;
    super.dispose();
  }

  void _showTopNotificationBanner({
    required String title,
    required String subtitle,
    required String body,
    IconData icon = Icons.notifications_active_rounded,
  }) {
    _bannerOverlay?.remove();
    _bannerOverlay = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _TopBannerOverlayWidget(
        title: title,
        subtitle: subtitle,
        body: body,
        icon: icon,
        onDismiss: () {
          entry.remove();
          if (_bannerOverlay == entry) _bannerOverlay = null;
        },
      ),
    );

    _bannerOverlay = entry;
    overlay.insert(entry);
  }

  // --- Trigger Instant Test Notification ---
  Future<void> _triggerTestNotification() async {
    // 1. Send native OS system notification
    await NotificationService().showInstantNotification(
      id: 999,
      title: 'Gym Base • Supplement Reminder 💊',
      body: 'Time to take your 5g Creatine Monohydrate with 300ml water! Stay consistent! 🔥',
    );

    // 2. Also pop interactive iOS-style top banner in-app
    if (mounted) {
      _showTopNotificationBanner(
        title: 'Gym Base • Supplement Reminder',
        subtitle: 'Creatine Monohydrate (5g)',
        body: 'Time to take your 5g Creatine Monohydrate with 300ml water! Stay consistent! 🔥',
        icon: Icons.bolt_rounded,
      );
    }
  }

  void _showAddSupplementModal() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    String category = 'daily';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                'Add Custom Supplement 💊',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Supplement Name',
                  hintText: 'e.g. Ashwagandha KSM-66',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dosageController,
                decoration: InputDecoration(
                  labelText: 'Dosage & Unit',
                  hintText: 'e.g. 600mg (1 capsule)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildModalCategoryChip('pre', 'Pre-Workout', category, (cat) => setModalState(() => category = cat)),
                  const SizedBox(width: 8),
                  _buildModalCategoryChip('post', 'Post-Workout', category, (cat) => setModalState(() => category = cat)),
                  const SizedBox(width: 8),
                  _buildModalCategoryChip('daily', 'Daily Health', category, (cat) => setModalState(() => category = cat)),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final dosage = dosageController.text.trim();
                    if (name.isEmpty) return;

                    setState(() {
                      _supplements.add({
                        'id': _supplements.length + 1,
                        'name': name,
                        'brand': 'Personal Stack',
                        'dosage': dosage.isNotEmpty ? dosage : '1 Serving',
                        'timing': 'Custom Schedule',
                        'timeWindow': 'As directed',
                        'category': category,
                        'taken': false,
                        'color': AppColors.primary,
                        'icon': Icons.medication_rounded,
                        'instructions': 'Take with water consistently.',
                        'streak': 0,
                        'reminderEnabled': true,
                        'reminderHour': 9,
                        'reminderMinute': 0,
                        'reminderTime': '09:00 AM',
                      });
                    });
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Add to Stack', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalCategoryChip(String id, String label, String currentSelected, Function(String) onSelect) {
    final isSelected = currentSelected == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taken = _takenCount;
    final total = _supplements.length;
    final percent = _completionPercent;
    final list = _filteredSupplements;

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
              'Supplement Reminders',
              style: TextStyle(
                color: AppColors.lightTextPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(width: 6),
            Text('💊', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          // Instant Test Local Notification Trigger
          IconButton(
            tooltip: 'Test Local Notification',
            icon: const Icon(Icons.notifications_active_rounded, color: AppColors.primary),
            onPressed: _triggerTestNotification,
          ),
          IconButton(
            tooltip: 'Add Custom Supplement',
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.lightTextPrimary),
            onPressed: _showAddSupplementModal,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 50),
        children: [
          const SizedBox(height: 14),

          // 1. Hero Daily Stack Progress Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B1D22), Color(0xFF141518)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Circular Progress Ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          value: percent,
                          strokeWidth: 6.5,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      Text(
                        '${(percent * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$taken of $total Taken',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5252).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFFF5252), width: 1),
                              ),
                              child: const Row(
                                children: [
                                  Text('🔥', style: TextStyle(fontSize: 11)),
                                  SizedBox(width: 3),
                                  Text(
                                    '14 Day Streak',
                                    style: TextStyle(
                                      color: Color(0xFFFF8585),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          percent >= 1.0
                              ? '🏆 All supplements completed today!'
                              : 'Keep your anabolic recovery primed on time.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Filter Category Pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryFilter('all', 'All Stack ($total)'),
                  const SizedBox(width: 8),
                  _buildCategoryFilter('pre', 'Pre-Workout ⚡'),
                  const SizedBox(width: 8),
                  _buildCategoryFilter('post', 'Post-Workout 🏋️‍♂️'),
                  const SizedBox(width: 8),
                  _buildCategoryFilter('daily', 'Daily Health 🥗'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 3. Supplement Items List
          ...list.map((supp) => _buildSupplementCard(supp)),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(String id, String label) {
    final isSelected = _selectedCategory == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildSupplementCard(Map<String, dynamic> supp) {
    final isTaken = supp['taken'] as bool;
    final color = supp['color'] as Color;
    final icon = supp['icon'] as IconData;
    final reminderTime = supp['reminderTime'] as String? ?? 'Set Time';
    final reminderEnabled = supp['reminderEnabled'] as bool? ?? false;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isTaken ? color.withValues(alpha: 0.35) : Colors.grey.shade200,
          width: isTaken ? 1.5 : 1,
        ),
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
          // Top Row: Icon + Name & Brand + Check Toggle Button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supp['name'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightTextPrimary,
                        decoration: isTaken ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${supp['dosage']} • ${supp['brand']}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _toggleTaken(supp),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isTaken ? color : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isTaken ? color : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isTaken ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: isTaken ? Colors.white : Colors.grey.shade600,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isTaken ? 'Taken' : 'Take Now',
                        style: TextStyle(
                          color: isTaken ? Colors.white : Colors.grey.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Timing Strip & Local Notification Alarm Picker
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          supp['timeWindow'] as String,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Local Notification Reminder Button
              GestureDetector(
                onTap: () => _pickReminderTime(supp),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  decoration: BoxDecoration(
                    color: reminderEnabled ? AppColors.primary.withValues(alpha: 0.12) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: reminderEnabled ? AppColors.primary.withValues(alpha: 0.4) : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        reminderEnabled ? Icons.notifications_active_rounded : Icons.notifications_outlined,
                        size: 14,
                        color: reminderEnabled ? AppColors.primary : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        reminderTime,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: reminderEnabled ? AppColors.primary : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Coaching Advice
          Text(
            supp['instructions'] as String,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Interactive In-App Notification Banner (iOS Dynamic Island / Push Banner Style)
// -----------------------------------------------------------------------------
class _TopBannerOverlayWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String body;
  final IconData icon;
  final VoidCallback onDismiss;

  const _TopBannerOverlayWidget({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_TopBannerOverlayWidget> createState() => _TopBannerOverlayWidgetState();
}

class _TopBannerOverlayWidgetState extends State<_TopBannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Auto dismiss after 4.5 seconds
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta != null && details.primaryDelta! < -4) {
                    _dismiss();
                  }
                },
                onTap: _dismiss,
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14161A).withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.16),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.45),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 16,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    widget.icon,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'GYM BASE',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: const BoxDecoration(
                                    color: Colors.white38,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'now',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _dismiss,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Title & Body
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.body,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
