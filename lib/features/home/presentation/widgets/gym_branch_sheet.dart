import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class GymBranchData {
  final String id;
  final String name;
  final String kurdishName;
  final String address;
  final String openHours;
  final bool isOpenNow;
  final String headCoach;
  final String phone;
  final String image;
  final List<String> amenities;

  const GymBranchData({
    required this.id,
    required this.name,
    required this.kurdishName,
    required this.address,
    required this.openHours,
    required this.isOpenNow,
    required this.headCoach,
    required this.phone,
    required this.image,
    required this.amenities,
  });
}

class GymBranchSheet extends StatelessWidget {
  final GymBranchData branch;

  const GymBranchSheet({super.key, required this.branch});

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
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      branch.kurdishName,
                      style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Branch Image
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(branch.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: branch.isOpenNow ? const Color(0xFF10B981) : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      branch.isOpenNow ? 'OPEN NOW 🟢' : 'CLOSED 🔴',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Key Info (Address, Hours, Head Coach)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.location_on_outlined, 'Address', branch.address),
                const Divider(height: 16, color: Colors.black12),
                _buildInfoRow(Icons.access_time_rounded, 'Opening Hours', branch.openHours),
                const Divider(height: 16, color: Colors.black12),
                _buildInfoRow(Icons.person_pin_rounded, 'Head Coach', branch.headCoach),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Amenities
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Branch Facilities & Amenities (تایبەتمەندی و خزمەتگوزارییەکان):',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: AppColors.lightTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: branch.amenities.map((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF2563EB)),
                      const SizedBox(width: 4),
                      Text(
                        amenity,
                        style: const TextStyle(color: Color(0xFF1E40AF), fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons: Call & Directions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling Reception: ${branch.phone}... 📞')),
                    );
                  },
                  icon: const Icon(Icons.call_rounded, size: 18),
                  label: const Text('Call Reception', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  foregroundColor: AppColors.lightTextPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening Google Maps location for ${branch.name}... 🗺️')),
                  );
                },
                icon: const Icon(Icons.directions_rounded, size: 18, color: AppColors.primary),
                label: const Text('Directions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: Colors.black54),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }
}
