import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _reels = [
    {
      'trainer': 'Coach Bilal Fitness',
      'handle': '@bilal_coach',
      'title': 'ڕێگای دروست بۆ یاری Bench Press بەبێ برینداربوونی شان',
      'tags': '#gym #benchpress #chestworkout #fitnesskurd',
      'likes': '12.4K',
      'comments': '342',
      'shares': '850',
      'isLiked': true,
      'sound': 'Original Audio - Workout Beats 🎵',
      'image': 'assets/images/workout_back.jpg',
    },
    {
      'trainer': 'Arian Sherzad',
      'handle': '@arian_fit',
      'title': 'باشترین ٣ ڕاهێنان بۆ گەورەکردنی ماسولکەی باڵ (Biceps & Triceps)',
      'tags': '#biceps #armday #bodybuilding #motivation',
      'likes': '8.9K',
      'comments': '189',
      'shares': '420',
      'isLiked': false,
      'sound': 'Motivational Gym Mix • 140 BPM',
      'image': 'assets/images/onboarding_athlete.jpg',
    },
    {
      'trainer': 'Gym Base Kurdish',
      'handle': '@gymbase_official',
      'title': 'چۆن لە مانگێکدا چەوری سک لەناوببەیت؟ کلیلە سەرەکییەکان',
      'tags': '#sixpack #absworkout #fatloss #dietkurd',
      'likes': '24.1K',
      'comments': '780',
      'shares': '2.1K',
      'isLiked': false,
      'sound': 'High Energy Electronic • Bass Boost',
      'image': 'assets/images/splash_athlete.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        itemBuilder: (context, index) {
          final reel = _reels[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              // Background Video/Image
              Image.asset(
                reel['image'],
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),

              // Gradient Darkening for Text Readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.25, 0.6, 1.0],
                  ),
                ),
              ),

              // Top Bar (Reels Title & Search)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Reels',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined,
                            color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),

              // Right Floating Actions (Like, Comment, Share, Sound)
              Positioned(
                right: 16,
                bottom: 110,
                child: Column(
                  children: [
                    _buildActionButton(
                      icon: reel['isLiked']
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: reel['isLiked'] ? Colors.redAccent : Colors.white,
                      label: reel['likes'],
                      onTap: () {
                        setState(() {
                          reel['isLiked'] = !reel['isLiked'];
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                      label: reel['comments'],
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      icon: Icons.share_rounded,
                      color: Colors.white,
                      label: reel['shares'],
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      icon: Icons.bookmark_border_rounded,
                      color: Colors.white,
                      label: 'Save',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    // Rotating Disc Icon
                    Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                        gradient: AppColors.buttonGradient,
                      ),
                      child: const Icon(
                        Icons.music_note_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Details Overlay
              Positioned(
                left: 16,
                right: 80,
                bottom: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trainer info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              const AssetImage('assets/images/user_avatar.jpg'),
                          backgroundColor: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  reel['trainer'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  color: AppColors.primary,
                                  size: 15,
                                ),
                              ],
                            ),
                            Text(
                              reel['handle'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Reel Title / Description
                    Text(
                      reel['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Hashtags
                    Text(
                      reel['tags'],
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Sound Track Title
                    Row(
                      children: [
                        const Icon(
                          Icons.music_note,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            reel['sound'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
