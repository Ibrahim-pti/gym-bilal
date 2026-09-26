import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class PrTrackerSheet extends StatefulWidget {
  final Map<String, double> initialPrs;
  final Function(Map<String, double>)? onSave;

  const PrTrackerSheet({super.key, required this.initialPrs, this.onSave});

  @override
  State<PrTrackerSheet> createState() => _PrTrackerSheetState();
}

class _PrTrackerSheetState extends State<PrTrackerSheet> {
  late Map<String, double> _prs;

  @override
  void initState() {
    super.initState();
    _prs = Map.from(widget.initialPrs);
  }

  void _showEditPrDialog(String exercise, double currentWeight) {
    final controller = TextEditingController(text: currentWeight.toStringAsFixed(1));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Update PR: $exercise', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your new personal record in KG:'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                suffixText: 'kg',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                setState(() => _prs[exercise] = val);
                widget.onSave?.call(_prs);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save PR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalTotal = _prs.values.fold(0.0, (sum, val) => sum + val);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFD97706), size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Records (PRs) 🏆',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Your all-time lifetime best lifts',
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
          const SizedBox(height: 16),

          // Big 3 Total Lift Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFEDD5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: Color(0xFFEA580C)),
                    SizedBox(width: 8),
                    Text(
                      'Combined Total Strength',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF9A3412)),
                    ),
                  ],
                ),
                Text(
                  '${totalTotal.toStringAsFixed(0)} kg',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFFEA580C)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // PR Items List
          ..._prs.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        Text(
                          'Tap pencil to update record',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${entry.value.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                    onPressed: () => _showEditPrDialog(entry.key, entry.value),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
