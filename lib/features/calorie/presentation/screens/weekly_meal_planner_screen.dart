import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class GroceryItem {
  final String id;
  final String name;
  final String kurdishName;
  final String quantity;
  final String category;
  bool isChecked;

  GroceryItem({
    required this.id,
    required this.name,
    required this.kurdishName,
    required this.quantity,
    required this.category,
    this.isChecked = false,
  });
}

class MealPlanItem {
  final String title;
  final String kurdishTitle;
  final String food;
  final int calories;
  final String protein;
  final String carbs;
  final String fat;
  final String prepTime;
  final IconData icon;

  const MealPlanItem({
    required this.title,
    required this.kurdishTitle,
    required this.food,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.prepTime,
    required this.icon,
  });
}

class WeeklyMealPlannerScreen extends StatefulWidget {
  const WeeklyMealPlannerScreen({super.key});

  @override
  State<WeeklyMealPlannerScreen> createState() => _WeeklyMealPlannerScreenState();
}

class _WeeklyMealPlannerScreenState extends State<WeeklyMealPlannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Goal: 'bulking' vs 'cutting'
  String _selectedGoal = 'bulking';
  int _selectedDayIndex = 0;

  final List<String> _weekDays = [
    'Saturday (شەممە)',
    'Sunday (یەکشەممە)',
    'Monday (دووشەممە)',
    'Tuesday (سێشەممە)',
    'Wednesday (چوارشەممە)',
    'Thursday (پێنجشەممە)',
    'Friday (هەینی)',
  ];

  // Grocery Checklist State
  late List<GroceryItem> _groceries;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _groceries = [
      // Proteins
      GroceryItem(id: '1', name: 'Eggs (Carton of 30)', kurdishName: 'هێلکەی تازە', quantity: '30 Eggs', category: 'Proteins 🥩', isChecked: true),
      GroceryItem(id: '2', name: 'Boneless Chicken Breast', kurdishName: 'سنگی مریشکی بێ ئێسک', quantity: '2.5 kg', category: 'Proteins 🥩', isChecked: true),
      GroceryItem(id: '3', name: 'Lean Ground Beef (90/10)', kurdishName: 'گۆشتی قیمەی بێ چەوری', quantity: '1.2 kg', category: 'Proteins 🥩'),
      GroceryItem(id: '4', name: 'Fresh Salmon Fillet', kurdishName: 'ماسی سەلەمونی تازە', quantity: '600 g', category: 'Proteins 🥩'),
      GroceryItem(id: '5', name: 'Greek Yogurt 0% Fat', kurdishName: 'ماستی یۆنانی کەم چەوری', quantity: '1 kg', category: 'Proteins 🥩', isChecked: true),

      // Carbs
      GroceryItem(id: '6', name: 'Rolled Oats', kurdishName: 'شۆفانی تەواو', quantity: '1.5 kg', category: 'Carbohydrates 🍚', isChecked: true),
      GroceryItem(id: '7', name: 'Basmati / Jasmine Rice', kurdishName: 'برنجی بۆندار', quantity: '2 kg', category: 'Carbohydrates 🍚', isChecked: true),
      GroceryItem(id: '8', name: 'Sweet Potatoes', kurdishName: 'پەتاتەی شیرین', quantity: '2 kg', category: 'Carbohydrates 🍚'),
      GroceryItem(id: '9', name: 'Whole Wheat Toast', kurdishName: 'نانی جۆ یان تۆست', quantity: '2 Packs', category: 'Carbohydrates 🍚', isChecked: true),

      // Fats & Superfoods
      GroceryItem(id: '10', name: 'Natural Peanut Butter', kurdishName: 'کەرەی فستقی بێ شەکر', quantity: '1 Jar', category: 'Fats & Superfoods 🥑', isChecked: true),
      GroceryItem(id: '11', name: 'Raw Almonds & Walnuts', kurdishName: 'بادام و گوێزی کاڵ', quantity: '400 g', category: 'Fats & Superfoods 🥑'),
      GroceryItem(id: '12', name: 'Extra Virgin Olive Oil', kurdishName: 'زەیتی زەیتوونی ئەسڵی', quantity: '750 ml', category: 'Fats & Superfoods 🥑', isChecked: true),
      GroceryItem(id: '13', name: 'Fresh Hass Avocados', kurdishName: 'ئەڤۆکادۆ', quantity: '4 Pieces', category: 'Fats & Superfoods 🥑'),

      // Greens & Fruits
      GroceryItem(id: '14', name: 'Fresh Bananas', kurdishName: 'مۆزی تازە', quantity: '2 kg', category: 'Greens & Fruits 🍌', isChecked: true),
      GroceryItem(id: '15', name: 'Baby Spinach & Broccoli', kurdishName: 'سپێناغ و برۆکلی', quantity: '1.5 kg', category: 'Greens & Fruits 🍌'),
      GroceryItem(id: '16', name: 'Fresh Blueberries', kurdishName: 'تووتڕک و بلوبێری', quantity: '300 g', category: 'Greens & Fruits 🍌'),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Meal Plans Data ---
  List<MealPlanItem> get _currentMealPlan {
    if (_selectedGoal == 'bulking') {
      return const [
        MealPlanItem(
          title: 'Power Breakfast',
          kurdishTitle: 'ژەمی بەیانی: هێزی ماسولکە',
          food: '4 Whole Eggs + 2 Whites + 100g Rolled Oats with Honey & Blueberries',
          calories: 720,
          protein: '46g',
          carbs: '82g',
          fat: '24g',
          prepTime: '15 min',
          icon: Icons.wb_sunny_rounded,
        ),
        MealPlanItem(
          title: 'Mid-Morning Mass Shake',
          kurdishTitle: 'ژەمی نێوان: شەیكی وزەبەخش',
          food: '1 Scoop Whey Protein + 1 Banana + 40g Oats + 2 tbsp Peanut Butter with Milk',
          calories: 580,
          protein: '42g',
          carbs: '65g',
          fat: '18g',
          prepTime: '5 min',
          icon: Icons.blender_rounded,
        ),
        MealPlanItem(
          title: 'Heavy Anabolic Lunch',
          kurdishTitle: 'ژەمی نیوەڕۆ: سنگی مریشک و برنج',
          food: '250g Grilled Chicken Breast + 220g Jasmine Rice + Steamed Broccoli with Olive Oil',
          calories: 820,
          protein: '68g',
          carbs: '95g',
          fat: '16g',
          prepTime: '25 min',
          icon: Icons.restaurant_rounded,
        ),
        MealPlanItem(
          title: 'Pre-Workout Energy Boost',
          kurdishTitle: 'ژەمی پێش وەرزش: کاربۆهیدراتی خێرا',
          food: '4 Rice Cakes + Peanut Butter + Sliced Banana + Black Espresso Coffee',
          calories: 340,
          protein: '11g',
          carbs: '54g',
          fat: '10g',
          prepTime: '5 min',
          icon: Icons.bolt_rounded,
        ),
        MealPlanItem(
          title: 'Night Recovery Dinner',
          kurdishTitle: 'ژەمی ئێوارە: سەلەمون و پەتاتەی شیرین',
          food: '220g Grilled Salmon + 250g Baked Sweet Potato + Mixed Green Salad',
          calories: 740,
          protein: '54g',
          carbs: '62g',
          fat: '28g',
          prepTime: '30 min',
          icon: Icons.nightlight_round,
        ),
      ];
    } else {
      // Cutting / Shred Diet
      return const [
        MealPlanItem(
          title: 'Lean High-Protein Breakfast',
          kurdishTitle: 'ژەمی بەیانی: پرۆتینی بەرز و کەم چەوری',
          food: '5 Egg Whites + 1 Whole Egg + 50g Oats + Spinach Omelette',
          calories: 410,
          protein: '38g',
          carbs: '34g',
          fat: '12g',
          prepTime: '12 min',
          icon: Icons.wb_sunny_rounded,
        ),
        MealPlanItem(
          title: 'Mid-Morning Protein Fuel',
          kurdishTitle: 'ژەمی نێوان: وی پرۆتین و بادام',
          food: '1 Scoop Whey Isolate in Water + 15 Raw Almonds + 1 Green Apple',
          calories: 260,
          protein: '30g',
          carbs: '18g',
          fat: '8g',
          prepTime: '3 min',
          icon: Icons.blender_rounded,
        ),
        MealPlanItem(
          title: 'Clean Shred Lunch',
          kurdishTitle: 'ژەمی نیوەڕۆ: مریشک و برنجی قاوەیی',
          food: '220g Skinless Chicken Breast + 120g Brown Rice + Huge Cucumber & Greens Bowl',
          calories: 520,
          protein: '58g',
          carbs: '48g',
          fat: '9g',
          prepTime: '20 min',
          icon: Icons.restaurant_rounded,
        ),
        MealPlanItem(
          title: 'Pre-Workout Pump Snack',
          kurdishTitle: 'ژەمی پێش ڕاهێنان',
          food: '1 Medium Banana + Double Shot Espresso + 5g Creatine',
          calories: 110,
          protein: '2g',
          carbs: '27g',
          fat: '0g',
          prepTime: '2 min',
          icon: Icons.bolt_rounded,
        ),
        MealPlanItem(
          title: 'Metabolic Fat-Loss Dinner',
          kurdishTitle: 'ژەمی ئێوارە: گۆشتی بێ چەوری و سەوزە',
          food: '200g Lean Beef Mince 95/5 + Sautéed Zucchini, Peppers & Asparagus',
          calories: 460,
          protein: '52g',
          carbs: '14g',
          fat: '16g',
          prepTime: '20 min',
          icon: Icons.nightlight_round,
        ),
      ];
    }
  }

  void _showAddGroceryDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    String category = 'Proteins 🥩';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('Add Grocery Item 🛒', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Item Name (e.g. Tuna, Spinach)',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: qtyCtrl,
                decoration: InputDecoration(
                  labelText: 'Quantity (e.g. 500g, 2 packs)',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                items: const [
                  DropdownMenuItem(value: 'Proteins 🥩', child: Text('Proteins 🥩')),
                  DropdownMenuItem(value: 'Carbohydrates 🍚', child: Text('Carbohydrates 🍚')),
                  DropdownMenuItem(value: 'Fats & Superfoods 🥑', child: Text('Fats & Superfoods 🥑')),
                  DropdownMenuItem(value: 'Greens & Fruits 🍌', child: Text('Greens & Fruits 🍌')),
                ],
                onChanged: (val) {
                  if (val != null) setDlgState(() => category = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _groceries.add(
                      GroceryItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameCtrl.text.trim(),
                        kurdishName: nameCtrl.text.trim(),
                        quantity: qtyCtrl.text.trim().isEmpty ? '1 Item' : qtyCtrl.text.trim(),
                        category: category,
                        isChecked: false,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add to List'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = _groceries.length;
    int checkedItems = _groceries.where((item) => item.isChecked).length;
    double progress = totalItems > 0 ? (checkedItems / totalItems) : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.lightTextPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Meal Planner & Groceries 🥗',
          style: TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: [
            const Tab(icon: Icon(Icons.restaurant_menu_rounded, size: 18), text: 'Weekly Meal Plan'),
            Tab(
              icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 18),
              text: 'Grocery List ($checkedItems/$totalItems)',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMealPlanTab(),
          _buildGroceryListTab(progress, checkedItems, totalItems),
        ],
      ),
    );
  }

  // ================= 1. WEEKLY MEAL PLAN TAB =================
  Widget _buildMealPlanTab() {
    final meals = _currentMealPlan;
    int totalCal = meals.fold(0, (sum, m) => sum + m.calories);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        // Goal Switcher (Bulking vs Cutting)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedGoal = 'bulking'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedGoal == 'bulking' ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.fitness_center_rounded, size: 15, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'BULKING (کێش & ماسولکە)',
                          style: TextStyle(
                            color: _selectedGoal == 'bulking' ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedGoal = 'cutting'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedGoal == 'cutting' ? const Color(0xFF10B981) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department_rounded, size: 15, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'CUTTING (دابەزاندنی چەوری)',
                          style: TextStyle(
                            color: _selectedGoal == 'cutting' ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Plan Summary Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _selectedGoal == 'bulking'
                  ? [const Color(0xFF1E2430), const Color(0xFF11141A)]
                  : [const Color(0xFF0F261E), const Color(0xFF091410)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedGoal == 'bulking' ? 'MASS GAIN NUTRITION PROTOCOL 🔥' : 'LEAN SHRED & DEFICIT PROTOCOL ⚡',
                    style: TextStyle(
                      color: _selectedGoal == 'bulking' ? AppColors.primary : const Color(0xFF10B981),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$totalCal kcal/day',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _selectedGoal == 'bulking'
                    ? 'Designed for rapid muscle growth, high mechanical recovery & maximum strength.'
                    : 'Engineered for fat loss while preserving 100% of lean muscle mass.',
                style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMacroCircle('Protein', _selectedGoal == 'bulking' ? '220g' : '205g', const Color(0xFF38BDF8)),
                  _buildMacroCircle('Carbs', _selectedGoal == 'bulking' ? '380g' : '170g', const Color(0xFFFBBF24)),
                  _buildMacroCircle('Healthy Fats', _selectedGoal == 'bulking' ? '85g' : '45g', const Color(0xFFF43F5E)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Week Day Selector Horizontal Pills
        const Text(
          'Select Day of Week (ڕۆژی هەفتە) 🗓️',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _weekDays.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final isSelected = _selectedDayIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedDayIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _weekDays[i].split(' ').first,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),

        // List of Meals for this day
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Meals Schedule (${meals.length} Meals) 🍽️',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.lightTextPrimary,
              ),
            ),
            Text(
              _weekDays[_selectedDayIndex].split(' ').first,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ...meals.map((meal) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(meal.icon, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.title,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                          ),
                          Text(
                            meal.kurdishTitle,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${meal.calories} kcal',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.lightTextPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  meal.food,
                  style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.35, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPill('P: ${meal.protein}', const Color(0xFF0284C7)),
                    const SizedBox(width: 6),
                    _buildPill('C: ${meal.carbs}', const Color(0xFFD97706)),
                    const SizedBox(width: 6),
                    _buildPill('F: ${meal.fat}', const Color(0xFFDC2626)),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          meal.prepTime,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMacroCircle(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }

  // ================= 2. GROCERY SHOPPING LIST TAB =================
  Widget _buildGroceryListTab(double progress, int checkedItems, int totalItems) {
    // Group groceries by category
    final categories = ['Proteins 🥩', 'Carbohydrates 🍚', 'Fats & Superfoods 🥑', 'Greens & Fruits 🍌'];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        // Grocery Progress Banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shopping_cart_checkout_rounded, color: Color(0xFF10B981), size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weekly Market Checklist 🛒', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                          Text('Fresh prep ingredients for the gym week', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '$checkedItems/$totalItems',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF10B981)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Action button: Add Custom Item
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Shopping Items By Category',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: AppColors.lightTextPrimary),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _showAddGroceryDialog,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add Item', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Categorized list
        ...categories.map((cat) {
          final items = _groceries.where((item) => item.category == cat).toList();
          if (items.isEmpty) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...items.map((item) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.isChecked ? const Color(0xFFF0FDF4) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: item.isChecked,
                          activeColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          onChanged: (val) {
                            setState(() {
                              item.isChecked = val ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                  color: item.isChecked ? Colors.grey : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                item.kurdishName,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.quantity,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: item.isChecked ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
