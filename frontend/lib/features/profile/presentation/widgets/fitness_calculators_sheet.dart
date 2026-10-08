import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class FitnessCalculatorsSheet extends StatefulWidget {
  final int initialTab;
  const FitnessCalculatorsSheet({super.key, this.initialTab = 0});

  @override
  State<FitnessCalculatorsSheet> createState() => _FitnessCalculatorsSheetState();
}

class _FitnessCalculatorsSheetState extends State<FitnessCalculatorsSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 1RM State
  double _liftWeight = 85.0;
  int _reps = 6;

  // Plate Calculator State
  double _targetWeight = 100.0;
  double _barWeight = 20.0; // Olympic barbell

  // Rest Timer State
  int _timerDuration = 60; // in seconds
  int _timerRemaining = 60;
  bool _isTimerRunning = false;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  // --- 1RM Calculation (Epley Formula) ---
  double get _oneRepMax {
    if (_reps <= 1) return _liftWeight;
    return _liftWeight * (1 + _reps / 30.0);
  }

  // --- Plate Calculator Calculation ---
  Map<double, int> get _calculatedPlates {
    final availablePlates = [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25];
    final result = <double, int>{};

    double weightPerSide = (_targetWeight - _barWeight) / 2.0;
    if (weightPerSide <= 0) return result;

    for (var plate in availablePlates) {
      if (weightPerSide >= plate) {
        int count = (weightPerSide / plate).floor();
        result[plate] = count;
        weightPerSide -= count * plate;
      }
    }
    return result;
  }

  // --- Timer Controls ---
  void _startTimer(int seconds) {
    _countdownTimer?.cancel();
    setState(() {
      _timerDuration = seconds;
      _timerRemaining = seconds;
      _isTimerRunning = true;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerRemaining > 0) {
        setState(() {
          _timerRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerRunning = false;
        });
      }
    });
  }

  void _pauseResumeTimer() {
    if (_isTimerRunning) {
      _countdownTimer?.cancel();
      setState(() => _isTimerRunning = false);
    } else if (_timerRemaining > 0) {
      setState(() => _isTimerRunning = true);
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerRemaining > 0) {
          setState(() {
            _timerRemaining--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isTimerRunning = false;
          });
        }
      });
    }
  }

  void _resetTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _timerRemaining = _timerDuration;
      _isTimerRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 14),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calculate_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fitness Tools & Calculators',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      '1RM, Barbell Plates & Rest Timer',
                      style: TextStyle(
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
          ),
          const SizedBox(height: 12),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            tabs: const [
              Tab(icon: Icon(Icons.fitness_center_rounded, size: 18), text: '1RM Max'),
              Tab(icon: Icon(Icons.line_weight_rounded, size: 18), text: 'Plate Calc'),
              Tab(icon: Icon(Icons.timer_outlined, size: 18), text: 'Rest Timer'),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOneRepMaxTab(),
                _buildPlateCalcTab(),
                _buildRestTimerTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= 1. ONE REP MAX (1RM) TAB =================
  Widget _buildOneRepMaxTab() {
    final oneRm = _oneRepMax;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Result Highlight Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B1D22), Color(0xFF131417)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'YOUR ESTIMATED 1-REP MAX (1RM)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    oneRm.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'KG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Text(
                'Based on ${_liftWeight.toStringAsFixed(0)} kg × $_reps reps',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Weight Input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lift Weight (kg)',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_liftWeight.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: _liftWeight,
          min: 10,
          max: 250,
          divisions: 48,
          activeColor: AppColors.primary,
          inactiveColor: Colors.grey.shade200,
          onChanged: (val) => setState(() => _liftWeight = val),
        ),
        const SizedBox(height: 14),

        // Reps Input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Repetitions Performed',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$_reps reps',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: _reps.toDouble(),
          min: 1,
          max: 15,
          divisions: 14,
          activeColor: AppColors.primary,
          inactiveColor: Colors.grey.shade200,
          onChanged: (val) => setState(() => _reps = val.round()),
        ),
        const SizedBox(height: 20),

        // Percentage Breakdown Table
        const Text(
          'Training Zones & Percentages 🎯',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _buildPercentageRow('100% - Absolute Max', (oneRm * 1.0).toStringAsFixed(1), '1 Rep', const Color(0xFFEF4444)),
        _buildPercentageRow('90% - Peak Strength', (oneRm * 0.9).toStringAsFixed(1), '3-4 Reps', const Color(0xFFF97316)),
        _buildPercentageRow('80% - Hypertrophy / Muscle', (oneRm * 0.8).toStringAsFixed(1), '6-8 Reps', const Color(0xFFEAB308)),
        _buildPercentageRow('70% - Volume & Form', (oneRm * 0.7).toStringAsFixed(1), '10-12 Reps', const Color(0xFF10B981)),
        _buildPercentageRow('60% - Endurance & Speed', (oneRm * 0.6).toStringAsFixed(1), '15+ Reps', const Color(0xFF06B6D4)),
      ],
    );
  }

  Widget _buildPercentageRow(String label, String kg, String reps, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          Text(
            reps,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(width: 16),
          Text(
            '$kg kg',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ================= 2. BARBELL PLATE CALCULATOR TAB =================
  Widget _buildPlateCalcTab() {
    final plates = _calculatedPlates;
    final perSide = (_targetWeight - _barWeight) / 2.0;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Target Weight Selector
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              const Text(
                'TARGET LIFT WEIGHT',
                style: TextStyle(
                  color: AppColors.lightTextSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_targetWeight > _barWeight + 2.5) {
                        setState(() => _targetWeight -= 2.5);
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_targetWeight.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      setState(() => _targetWeight += 2.5);
                    },
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Bar: ${_barWeight.toStringAsFixed(0)}kg • Load per side: ${perSide > 0 ? perSide.toStringAsFixed(1) : 0} kg',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Bar Weight Option
        Row(
          children: [
            const Text(
              'Barbell Type: ',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            const Spacer(),
            _buildBarOption(20.0, 'Olympic 20kg'),
            const SizedBox(width: 8),
            _buildBarOption(15.0, 'Women 15kg'),
            const SizedBox(width: 8),
            _buildBarOption(10.0, 'EZ 10kg'),
          ],
        ),
        const SizedBox(height: 20),

        // Visual Plates on Collar Representation
        const Text(
          'Plates on Each Side (هەردوو لا) 🏋️',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),

        if (plates.isEmpty || perSide <= 0)
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Just use the empty barbell! No plates needed.',
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1D22),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Plate stack representation
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Barbell Collar
                      Container(
                        width: 30,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 50,
                        color: Colors.grey.shade300,
                      ),
                      // Plates
                      ...plates.entries.expand((entry) {
                        return List.generate(entry.value, (i) {
                          return _buildPlateGraphic(entry.key);
                        });
                      }),
                      // Bar Tip
                      Container(
                        width: 40,
                        height: 14,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Breakdown list
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: plates.entries.map((e) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${e.value}× ${e.key} kg',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBarOption(double weight, String title) {
    final isSelected = _barWeight == weight;
    return GestureDetector(
      onTap: () => setState(() => _barWeight = weight),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildPlateGraphic(double plateWeight) {
    Color color;
    double height;
    if (plateWeight >= 25) {
      color = const Color(0xFFDC2626); // Red
      height = 76;
    } else if (plateWeight >= 20) {
      color = const Color(0xFF2563EB); // Blue
      height = 72;
    } else if (plateWeight >= 15) {
      color = const Color(0xFFEAB308); // Yellow
      height = 64;
    } else if (plateWeight >= 10) {
      color = const Color(0xFF16A34A); // Green
      height = 56;
    } else if (plateWeight >= 5) {
      color = Colors.white;
      height = 46;
    } else {
      color = Colors.grey.shade700;
      height = 36;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      width: 14,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.black45, width: 0.8),
      ),
    );
  }

  // ================= 3. REST INTERVAL TIMER TAB =================
  Widget _buildRestTimerTab() {
    double progress = _timerDuration > 0 ? (_timerRemaining / _timerDuration) : 0;
    int mins = _timerRemaining ~/ 60;
    int secs = _timerRemaining % 60;
    String timeString = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Preset Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetBtn(30, '30s'),
              _buildPresetBtn(60, '60s'),
              _buildPresetBtn(90, '90s'),
              _buildPresetBtn(120, '2m'),
              _buildPresetBtn(180, '3m'),
            ],
          ),
          const Spacer(),

          // Circular Timer Display
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timerRemaining <= 5 ? Colors.redAccent : AppColors.primary,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeString,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      _isTimerRunning
                          ? 'RESTING... ⏳'
                          : (_timerRemaining == 0 ? 'TIME TO LIFT! 🔥' : 'READY'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _timerRemaining == 0 ? Colors.green : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filled(
                iconSize: 26,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                ),
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh_rounded),
              ),
              const SizedBox(width: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _pauseResumeTimer,
                icon: Icon(_isTimerRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 24),
                label: Text(
                  _isTimerRunning ? 'Pause' : 'Start Timer',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPresetBtn(int seconds, String label) {
    final isSelected = _timerDuration == seconds;
    return GestureDetector(
      onTap: () => _startTimer(seconds),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
