import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class SupplementTrackerScreen extends StatefulWidget {
  const SupplementTrackerScreen({super.key});

  @override
  State<SupplementTrackerScreen> createState() => _SupplementTrackerScreenState();
}

class _SupplementTrackerScreenState extends State<SupplementTrackerScreen> {
  // Selected category filter: 'all', 'pre', 'post', 'daily'
  String _selectedCategory = 'all';

  // Daily Supplements List
  final List<Map<String, dynamic>> _supplements = [
    {
      'id': 'supp_1',
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
    },
    {
      'id': 'supp_2',
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
    },
    {
      'id': 'supp_3',
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
    },
    {
      'id': 'supp_4',
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
    },
    {
      'id': 'supp_5',
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
    },
    {
      'id': 'supp_6',
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
                        'id': 'supp_${DateTime.now().millisecondsSinceEpoch}',
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
              'Daily Supplements Stack',
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
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
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

          // Timing Strip & Instructions
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.alarm_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  supp['timeWindow'] as String,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '🔥 ${supp['streak']}d streak',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
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
