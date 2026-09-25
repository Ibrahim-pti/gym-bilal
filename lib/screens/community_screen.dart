import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'Karwan Hawrami',
      'role': 'Fitness Coach • Erbil',
      'avatar': 'assets/images/user_avatar.jpg',
      'time': '٢ کاتژمێر پێش ئێستا',
      'content':
          'ئەمڕۆ لەگەڵ بەشداربووانی جیم توانیمان کێشی پێوانەیی تۆمار بکەین! کلیلەکە بەردەوامی و ڕێکخستنی خواردن و خەوە. بە هیچ شێوەیەک نائومێد مەبن لە سەرەتادا. 💪🔥',
      'image': 'assets/images/workout_back.jpg',
      'likes': 148,
      'isLiked': true,
      'comments': 24,
    },
    {
      'author': 'Renas Fitness',
      'role': 'Bodybuilder • Sulaymaniyah',
      'avatar': 'assets/images/user_avatar.jpg',
      'time': '٥ کاتژمێر پێش ئێستا',
      'content':
          'گۆڕانکاری ٦ مانگ بێ هیچ وەرگرتنی هۆڕمۆن، تەنها پرۆتین و ڕاهێنانی چڕ و خواردنی تەندروست. کێ ئامادەیە ڕکابەری بکات؟ 🏋️‍♂️',
      'image': 'assets/images/onboarding_athlete.jpg',
      'likes': 312,
      'isLiked': false,
      'comments': 56,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'کۆمەڵگەی فیتنس (Community)',
          style: TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: AppColors.lightTextPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded,
                color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // Stories Section
          Container(
            height: 105,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildAddStoryItem(),
                _buildStoryItem('دیار', 'assets/images/user_avatar.jpg', true),
                _buildStoryItem('ڕاهێنەر بیلال', 'assets/images/splash_athlete.jpg', true),
                _buildStoryItem('ئاریان', 'assets/images/onboarding_athlete.jpg', false),
                _buildStoryItem('محەمەد', 'assets/images/workout_back.jpg', false),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Create Post Prompt Box
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'پرسیارێک بکە، یان پێشکەوتنەکەت بڵاو بکەرەوە...',
                      style: TextStyle(
                        color: AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.photo_library_outlined,
                      color: AppColors.primary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Posts Feed
          ..._posts.map((post) => _buildPostCard(post)),
        ],
      ),
    );
  }

  Widget _buildAddStoryItem() {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/user_avatar.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'ستۆری تۆ',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(String name, String imagePath, bool isLive) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isLive ? AppColors.primaryGradient : null,
              border: !isLive
                  ? Border.all(color: Colors.grey.shade300, width: 2)
                  : null,
            ),
            child: CircleAvatar(
              radius: 27,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(post['avatar']),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['author'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${post['role']} • ${post['time']}',
                      style: const TextStyle(
                        color: AppColors.lightTextSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Content Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post['content'],
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Post Image
          if (post['image'] != null)
            ClipRRect(
              child: Image.asset(
                post['image'],
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),

          // Action Buttons (Like, Comment, Share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      post['isLiked'] = !post['isLiked'];
                      post['likes'] += post['isLiked'] ? 1 : -1;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        post['isLiked']
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: post['isLiked'] ? Colors.red : Colors.grey.shade600,
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post['likes']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${post['comments']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.bookmark_border_rounded,
                  color: Colors.grey.shade600,
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
