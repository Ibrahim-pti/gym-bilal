import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  State<CalorieScreen> createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  int _consumedCalories = 1680;
  final int _targetCalories = 2400;
  int _waterGlasses = 6; // out of 8

  final List<Map<String, dynamic>> _meals = [
    {
      'title': 'ژەمی بەیانی (Breakfast)',
      'food': '٣ هێلکەی کوڵاو + نانی تیری + چای بێ شەکر',
      'cal': 360,
      'protein': '26g',
      'carbs': '32g',
      'fat': '14g',
      'time': '08:30 AM',
      'icon': Icons.wb_sunny_outlined,
    },
    {
      'title': 'ژەمی نیوەڕۆ (Lunch)',
      'food': 'سینگی مریشکی برژاو لەگەڵ برنجی کوردی و زەڵاتە',
      'cal': 680,
      'protein': '52g',
      'carbs': '70g',
      'fat': '18g',
      'time': '01:45 PM',
      'icon': Icons.restaurant_rounded,
    },
    {
      'title': 'پێش ڕاهێنان (Pre-workout Snack)',
      'food': 'مۆزێک + کەرەی فستق + قاوەی تاڵ',
      'cal': 240,
      'protein': '7g',
      'carbs': '35g',
      'fat': '9g',
      'time': '04:30 PM',
      'icon': Icons.flash_on_rounded,
    },
    {
      'title': 'ژەمی ئێوارە (Dinner)',
      'food': 'یاپراخی کوردی (٣ دەنک) لەگەڵ ماست',
      'cal': 400,
      'protein': '18g',
      'carbs': '42g',
      'fat': '15g',
      'time': '08:00 PM',
      'icon': Icons.nightlight_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final remaining = _targetCalories - _consumedCalories;
    final progress = (_consumedCalories / _targetCalories).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'کالۆری و خواردن (Calorie Tracker)',
          style: TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined,
                color: AppColors.lightTextPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
        children: [
          // AI Food Scanner Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C241D), Color(0xFF1E1A17)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'پشکنەری ژەمەکان بە AI 📸',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'وێنەی خواردنەکەت بگرە، ڕاستەوخۆ کالۆری و پرۆتینەکەی دەردێنێت',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Calorie Progress Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Circular Radial Progress
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 9,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$remaining',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                            const Text(
                              'ماوە kcal',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),

                    // Calorie Breakdown
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCalorieStatRow(
                            'ئامانجی ڕۆژانە',
                            '$_targetCalories kcal',
                            Colors.grey.shade700,
                          ),
                          const SizedBox(height: 8),
                          _buildCalorieStatRow(
                            'خوراوی ئەمڕۆ',
                            '$_consumedCalories kcal',
                            AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          _buildCalorieStatRow(
                            'سووتاوی وەرزش',
                            '420 kcal 🔥',
                            Colors.green.shade600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),

                // Macronutrients Bar (Protein, Carbs, Fats)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMacroItem('پرۆتین', '103g / 150g', 0.68, Colors.orange),
                    _buildMacroItem('کاربۆهیدرات', '179g / 220g', 0.81, Colors.blue),
                    _buildMacroItem('چەوری سوودبەخش', '56g / 70g', 0.80, Colors.purple),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Water Tracker Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'خواردنەوەی ئاو (Water Tracker)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$_waterGlasses لە ٨ پەرداخ (1.5L / 2.5L)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_waterGlasses < 8) _waterGlasses++;
                    });
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Meals of the Day Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ژەمەکانی ئەمڕۆ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                label: const Text(
                  'زیادکردنی ژەم',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Meals List
          ..._meals.map((meal) => _buildMealCard(meal)),
        ],
      ),
    );
  }

  Widget _buildCalorieStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroItem(
      String label, String amount, double progress, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.lightTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tagCardio,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  meal['icon'],
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      meal['time'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${meal['cal']} kcal',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meal['food'],
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMacroChip('P: ${meal['protein']}', Colors.orange),
              const SizedBox(width: 8),
              _buildMacroChip('C: ${meal['carbs']}', Colors.blue),
              const SizedBox(width: 8),
              _buildMacroChip('F: ${meal['fat']}', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
