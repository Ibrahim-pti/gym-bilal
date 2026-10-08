import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class CoachData {
  final String id;
  final String name;
  final String title;
  final String branchName;
  final String experience;
  final String rating;
  final int athletesCount;
  final String image;
  final String bio;
  final List<String> specialties;
  final String phone;

  const CoachData({
    required this.id,
    required this.name,
    required this.title,
    required this.branchName,
    required this.experience,
    required this.rating,
    required this.athletesCount,
    required this.image,
    required this.bio,
    required this.specialties,
    required this.phone,
  });
}

class CoachProfileSheet extends StatelessWidget {
  final CoachData coach;

  const CoachProfileSheet({super.key, required this.coach});

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

          // Header with Avatar and Basic Info
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage(coach.image),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coach.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      coach.title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            coach.branchName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
          const SizedBox(height: 20),

          // Stats Row (Experience, Rating, Athletes)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Experience', coach.experience, Icons.timeline_rounded),
                Container(width: 1, height: 28, color: Colors.grey.shade300),
                _buildStatItem('Rating', '${coach.rating} ⭐', Icons.star_rounded),
                Container(width: 1, height: 28, color: Colors.grey.shade300),
                _buildStatItem('Athletes', '${coach.athletesCount}+', Icons.groups_rounded),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bio / Description
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              coach.bio,
              style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),

          // Specialties Tags
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Specialties & Focus (تایبەتمەندییەکان):',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.lightTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: coach.specialties.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    s,
                    style: const TextStyle(color: AppColors.primary, fontSize: 11.5, fontWeight: FontWeight.w800),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons: WhatsApp & Call
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening WhatsApp with ${coach.name}... 💬')),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                  label: const Text('WhatsApp Chat', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${coach.name}: ${coach.phone}... 📞')),
                  );
                },
                icon: const Icon(Icons.call_rounded, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.lightTextPrimary)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
