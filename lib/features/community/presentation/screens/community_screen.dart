import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/community/presentation/screens/reels_viewer_screen.dart';
import 'package:gym_base/features/community/presentation/screens/article_detail_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Selected filter: 'all', 'reels', 'photos', 'articles'
  String _selectedFilter = 'all';

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchOpen = false;

  // Complete Content Feed (Reels, Photos, Articles)
  final List<Map<String, dynamic>> _feedItems = [
    // 1. REEL: Deadlift PR
    {
      'id': 'reel_1',
      'type': 'reel',
      'title': 'Heavy Barbell Deadlift PR 240kg Form Check',
      'author': 'Coach Bilal',
      'role': 'Master Trainer • Pro Athlete',
      'avatar': 'assets/images/user_avatar.jpg',
      'time': '1 hour ago',
      'videoThumbnail': 'assets/images/workout_back.jpg',
      'duration': '0:34',
      'views': '48.2k',
      'audioTrack': 'Gym Phonk High Voltage • 160 BPM',
      'exerciseTag': 'Barbell Deadlift',
      'caption':
          'Clean lockout, tight core, lats packed tight before pulling. Always focus on driving feet through the platform! 💪🔥 #DeadliftPR #BackDay',
      'likes': 3840,
      'isLiked': true,
      'comments': 248,
      'isBookmarked': false,
    },

    // 2. ARTICLE: Hypertrophy Science
    {
      'id': 'art_1',
      'type': 'article',
      'title': 'The Science of Hypertrophy: Rest Periods vs Volume',
      'author': 'Dr. Karwan Fitness',
      'role': 'Sports Science & Nutrition Ph.D.',
      'avatar': 'assets/images/male_fitness_banner.jpg',
      'time': '3 hours ago',
      'readTime': '4 min read',
      'tags': ['Hypertrophy', 'Science', 'Rest Periods'],
      'caption':
          'Why resting 2-3 minutes on heavy compound lifts produces significantly greater muscle mass than rushing through 45-second intervals.',
      'takeaways': [
        'Full 2.5-3 min rest allows 95%+ ATP-CP system replenishment.',
        'Higher mechanical tension per set drives faster myofibrillar growth.',
        'Short rest leads to premature cardiovascular fatigue rather than muscular failure.',
      ],
      'fullArticle':
          'Many gym-goers believe that shorter rest intervals burn more calories and accelerate muscle hypertrophy due to the severe pump and burning sensation. However, multiple recent peer-reviewed meta-analyses have overturned this misconception.\n\nWhen training for hypertrophy on multi-joint compound exercises (such as squats, flat bench presses, and barbell rows), resting at least 2 to 3 minutes between working sets enables complete central nervous system recovery and replenishes intra-muscular ATP and creatine phosphate stores.\n\nThis allows you to maintain optimal load intensity and bar velocity across all working sets. Ultimately, volume load multiplied by mechanical tension is the primary stimulus for muscular development.',
      'likes': 1120,
      'isLiked': false,
      'comments': 84,
      'isBookmarked': true,
    },

    // 3. PHOTO POST: Transformation
    {
      'id': 'photo_1',
      'type': 'photo',
      'title': '6 Months Natural Body Transformation',
      'author': 'Renas Hawrami',
      'role': 'Athlete • Sulaymaniyah',
      'avatar': 'assets/images/splash_athlete.jpg',
      'time': '5 hours ago',
      'image': 'assets/images/onboarding_athlete.jpg',
      'category': 'Transformation',
      'caption':
          'Strict 2.2g protein per kg of bodyweight, 8 hours of uninterrupted sleep, and progressive overload on compound lifts. No shortcuts, just pure dedication! 🏋️‍♂️💯',
      'likes': 2140,
      'isLiked': false,
      'comments': 156,
      'isBookmarked': false,
    },

    // 4. REEL: Incline Dumbbell Press Form
    {
      'id': 'reel_2',
      'type': 'reel',
      'title': 'Upper Pec Clavicular Squeeze • Incline Dumbbell Press',
      'author': 'Alex Hunter',
      'role': 'Chest & Shoulder Specialist',
      'avatar': 'assets/images/male_fitness_banner.jpg',
      'time': '8 hours ago',
      'videoThumbnail': 'assets/images/card_gym_full.png',
      'duration': '0:42',
      'views': '31.5k',
      'audioTrack': 'Heavy Bass Workout Mix • DJ Hype',
      'exerciseTag': 'Incline Dumbbell Press',
      'caption':
          'Set your bench to 30 degrees (not 45). Keep elbows tucked at 45-60 degrees to preserve shoulder health while maximizing upper chest activation! 🔥',
      'likes': 2890,
      'isLiked': false,
      'comments': 112,
      'isBookmarked': true,
    },

    // 5. PHOTO POST: Post-Workout Meal Prep
    {
      'id': 'photo_2',
      'type': 'photo',
      'title': '680 kcal High-Protein Muscle Fuel',
      'author': 'Sara Nutrition',
      'role': 'Certified Sports Dietitian',
      'avatar': 'assets/images/female_fitness_banner.jpg',
      'time': '10 hours ago',
      'image': 'assets/images/card_nutrition_full.png',
      'category': 'Nutrition',
      'caption':
          'Grilled chicken breast with basmati rice, avocado slices, and steamed broccoli. Packed with 52g protein and essential micronutrients for peak muscle repair! 🥗🍗',
      'likes': 1430,
      'isLiked': true,
      'comments': 93,
      'isBookmarked': false,
    },

    // 6. ARTICLE: Shoulder Health & Rotator Cuff
    {
      'id': 'art_2',
      'type': 'article',
      'title': '5 Critical Fixes For Shoulder Pain During Bench Press',
      'author': 'Coach Bilal',
      'role': 'Master Trainer • Pro Athlete',
      'avatar': 'assets/images/user_avatar.jpg',
      'time': '14 hours ago',
      'readTime': '5 min read',
      'tags': ['Injury Prevention', 'Bench Press', 'Shoulder Care'],
      'caption':
          'Eliminate anterior shoulder impingement with these five biomechanical adjustments before your next push workout.',
      'takeaways': [
        'Retract and depress your scapulae into the bench pad before un-racking.',
        'Avoid excessive 90-degree elbow flares; tuck them to approximately 75 degrees.',
        'Incorporate external rotation warm-ups with light resistance cables.',
      ],
      'fullArticle':
          'Shoulder pain during flat bench pressing is one of the most common complaints among weightlifters. Almost universally, this stems from pressing with a flat upper back and allowing the elbows to flare perpendicular to the torso (90 degrees).\n\nWhen your shoulders internally rotate under heavy load, the subacromial space narrows, pinching the supraspinatus tendon. To safeguard your joints, pull your shoulder blades together and tuck them downward as if putting them in your back pockets. Lower the barbell to the lower sternum rather than your collarbones.',
      'likes': 980,
      'isLiked': false,
      'comments': 62,
      'isBookmarked': false,
    },

    // 7. REEL: Pull-Up Progression
    {
      'id': 'reel_3',
      'type': 'reel',
      'title': 'Wide-Grip Pull-Up V-Taper Mastery',
      'author': 'Maya Stone',
      'role': 'Calisthenics Coach',
      'avatar': 'assets/images/female_fitness_banner.jpg',
      'time': '1 day ago',
      'videoThumbnail': 'assets/images/pullup_figure.jpg',
      'duration': '0:28',
      'views': '54.1k',
      'audioTrack': 'Deep Focus Instrumental • Beats',
      'exerciseTag': 'Wide-Grip Pull Up',
      'caption':
          'Stop kicking your legs! Engage your hollow body position, pull your chest towards the bar, and pause for a 1-second peak contraction at the top! ⚡🧗‍♀️',
      'likes': 4210,
      'isLiked': true,
      'comments': 310,
      'isBookmarked': true,
    },

    // 8. PHOTO POST: Leg Day Intensity
    {
      'id': 'photo_3',
      'type': 'photo',
      'title': 'Quad Pump After 5 Sets of Heavy Barbell Squats',
      'author': 'Zana Hawleri',
      'role': 'Powerlifter',
      'avatar': 'assets/images/onboarding_athlete.jpg',
      'time': '1 day ago',
      'image': 'assets/images/card_progress_full.png',
      'category': 'Leg Day',
      'caption':
          'Squat depth to parallel or below every single repetition. Building tree trunk legs requires patience and heavy iron! 🦵💥',
      'likes': 1870,
      'isLiked': false,
      'comments': 104,
      'isBookmarked': false,
    },
  ];

  // Helper list of all Reels for the viewer
  List<Map<String, dynamic>> get _allReels =>
      _feedItems.where((item) => item['type'] == 'reel').toList();

  List<Map<String, dynamic>> get _filteredFeed {
    return _feedItems.where((item) {
      // Filter by category
      if (_selectedFilter == 'reels' && item['type'] != 'reel') return false;
      if (_selectedFilter == 'photos' && item['type'] != 'photo') return false;
      if (_selectedFilter == 'articles' && item['type'] != 'article') return false;

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final title = (item['title'] as String? ?? '').toLowerCase();
        final author = (item['author'] as String? ?? '').toLowerCase();
        final caption = (item['caption'] as String? ?? '').toLowerCase();
        return title.contains(query) || author.contains(query) || caption.contains(query);
      }

      return true;
    }).toList();
  }

  void _openReelsViewer(int reelIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReelsViewerScreen(
          reels: _allReels,
          initialIndex: reelIndex,
        ),
      ),
    );
  }

  void _openArticleDetail(Map<String, dynamic> article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }

  void _showCreatePostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CreatePostSheet(
        onPostCreated: (newPost) {
          setState(() {
            _feedItems.insert(0, newPost);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Your post has been published to the community!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredFeed;
    final reelsList = _allReels;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: AppColors.lightTextPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search reels, photos, articles...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.lightTextSecondary, fontSize: 13.5),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
              )
            : const Row(
                children: [
                  Text(
                    'Community & Reels',
                    style: TextStyle(
                      color: AppColors.lightTextPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('🔥', style: TextStyle(fontSize: 16)),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchOpen ? Icons.close_rounded : Icons.search_rounded,
              color: AppColors.lightTextPrimary,
            ),
            onPressed: () {
              setState(() {
                _isSearchOpen = !_isSearchOpen;
                if (!_isSearchOpen) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          // Direct button to launch Reels viewer instantly
          GestureDetector(
            onTap: () => _openReelsViewer(0),
            child: Container(
              margin: const EdgeInsets.only(right: 14, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Reels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePostModal,
        backgroundColor: AppColors.primary,
        elevation: 6,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
        label: const Text(
          'Create Post',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // 1. Stories Bar (Top)
          Container(
            color: Colors.white,
            height: 108,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildAddStoryItem(),
                _buildStoryItem(
                  'Coach Bilal',
                  'assets/images/user_avatar.jpg',
                  isLive: true,
                  onTap: () => _openReelsViewer(0),
                ),
                _buildStoryItem(
                  'Maya',
                  'assets/images/female_fitness_banner.jpg',
                  isLive: false,
                  onTap: () => _openReelsViewer(2),
                ),
                _buildStoryItem(
                  'Alex',
                  'assets/images/male_fitness_banner.jpg',
                  isLive: false,
                  onTap: () => _openReelsViewer(1),
                ),
                _buildStoryItem(
                  'Renas',
                  'assets/images/splash_athlete.jpg',
                  isLive: false,
                  onTap: () {},
                ),
                _buildStoryItem(
                  'Zana',
                  'assets/images/onboarding_athlete.jpg',
                  isLive: false,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 2. Segmented Filter Pills (All Feed / Reels / Photos / Articles)
          _buildFilterTabs(),

          // 3. Featured Reels Carousel (Shown when filter is 'all' or 'reels')
          if ((_selectedFilter == 'all' || _selectedFilter == 'reels') && _searchQuery.isEmpty) ...[
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.video_collection_rounded, color: AppColors.primary, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Trending Reels',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.lightTextPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _openReelsViewer(0),
                    child: const Text(
                      'Watch All 🎬',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 185,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: reelsList.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final reel = reelsList[index];
                  return _buildReelSpotlightCard(reel, index);
                },
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Section Title for Feed
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Text(
              _getFilterTitle(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.lightTextPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 4. Feed Stream (Reels, Photos, Articles)
          if (filteredList.isEmpty)
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text(
                    'No posts found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Try changing your filter or search keywords.',
                    style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
            )
          else
            ...filteredList.map((item) {
              if (item['type'] == 'reel') {
                final reelIdx = _allReels.indexWhere((r) => r['id'] == item['id']);
                return _buildReelFeedCard(item, reelIdx >= 0 ? reelIdx : 0);
              } else if (item['type'] == 'photo') {
                return _buildPhotoFeedCard(item);
              } else {
                return _buildArticleFeedCard(item);
              }
            }),
        ],
      ),
    );
  }

  String _getFilterTitle() {
    switch (_selectedFilter) {
      case 'reels':
        return 'Workout Reels & Shorts 🎬';
      case 'photos':
        return 'Photo Posts & Transformations 📸';
      case 'articles':
        return 'Articles, Guides & Science 📝';
      default:
        return 'Latest Community Posts 💬';
    }
  }

  // ----------------------------------------------------
  // Stories Bar Item
  // ----------------------------------------------------
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
                  color: Colors.grey.shade100,
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
            'Your Story',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(
    String name,
    String imagePath, {
    required bool isLive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isLive
                    ? const LinearGradient(
                        colors: [Color(0xFFFF3366), Color(0xFFFF9933)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [AppColors.primary, const Color(0xFFFFB347)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: CircleAvatar(
                radius: 27,
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLive)
                  Container(
                    margin: const EdgeInsets.only(right: 3),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3366),
                      shape: BoxShape.circle,
                    ),
                  ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // Filter Tabs
  // ----------------------------------------------------
  Widget _buildFilterTabs() {
    final filters = [
      {'id': 'all', 'label': 'All Posts', 'icon': Icons.dynamic_feed_rounded},
      {'id': 'reels', 'label': 'Reels 🎬', 'icon': Icons.video_collection_rounded},
      {'id': 'photos', 'label': 'Photos 📸', 'icon': Icons.photo_library_rounded},
      {'id': 'articles', 'label': 'Articles 📝', 'icon': Icons.article_rounded},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final isSelected = _selectedFilter == f['id'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = f['id'] as String;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade200,
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
                child: Row(
                  children: [
                    Icon(
                      f['icon'] as IconData,
                      size: 15,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      f['label'] as String,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // Horizontal Reel Spotlight Card
  // ----------------------------------------------------
  Widget _buildReelSpotlightCard(Map<String, dynamic> reel, int index) {
    final imagePath = reel['videoThumbnail'] as String? ?? 'assets/images/workout_back.jpg';
    final views = reel['views'] as String? ?? '20k';
    final author = reel['author'] as String? ?? 'Coach';
    final title = reel['title'] as String? ?? 'Reel';

    return GestureDetector(
      onTap: () => _openReelsViewer(index),
      child: Container(
        width: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Dark Gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Top Duration & Sound Chip
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      reel['duration'] ?? '0:30',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center Play Icon Overlay
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),

            // Bottom Info
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 9.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.visibility_outlined, color: Colors.white70, size: 10),
                      const SizedBox(width: 3),
                      Text(
                        views,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // REEL Feed Card
  // ----------------------------------------------------
  Widget _buildReelFeedCard(Map<String, dynamic> item, int reelIndex) {
    final isLiked = item['isLiked'] as bool? ?? false;
    final isBookmarked = item['isBookmarked'] as bool? ?? false;
    final likes = item['likes'] as int? ?? 1000;
    final comments = item['comments'] as int? ?? 50;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(item['avatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item['author'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF3897F0),
                            size: 15,
                          ),
                        ],
                      ),
                      Text(
                        '${item['role']} • ${item['time']}',
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5252).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.movie_filter_rounded, size: 12, color: Color(0xFFFF5252)),
                      SizedBox(width: 4),
                      Text(
                        'REEL',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF5252),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              item['caption'],
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Video Thumbnail Preview with Play Overlay
          GestureDetector(
            onTap: () => _openReelsViewer(reelIndex),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  item['videoThumbnail'],
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                ),
                // Gradient bottom strip
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Big Play Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                // Bottom Reel Info (Duration & Audio)
                Positioned(
                  left: 14,
                  bottom: 12,
                  right: 14,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.music_note_rounded, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              item['audioTrack'] ?? 'Audio',
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Tap to watch full reel 🎬',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Row (Like, Comment, Share, Bookmark)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isLiked'] = !isLiked;
                      item['likes'] = likes + (item['isLiked'] ? 1 : -1);
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isLiked ? Colors.redAccent : Colors.grey.shade700,
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$likes',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () => _openReelsViewer(reelIndex),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$comments',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Icon(
                  Icons.send_rounded,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isBookmarked'] = !isBookmarked;
                    });
                  },
                  child: Icon(
                    isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: isBookmarked ? AppColors.primary : Colors.grey.shade700,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // PHOTO Feed Card
  // ----------------------------------------------------
  Widget _buildPhotoFeedCard(Map<String, dynamic> item) {
    final isLiked = item['isLiked'] as bool? ?? false;
    final isBookmarked = item['isBookmarked'] as bool? ?? false;
    final likes = item['likes'] as int? ?? 500;
    final comments = item['comments'] as int? ?? 30;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(item['avatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['author'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5,
                        ),
                      ),
                      Text(
                        '${item['role']} • ${item['time']}',
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt_rounded, size: 12, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        item['category'] ?? 'PHOTO',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              item['caption'],
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Photo Image
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                if (!isLiked) {
                  item['isLiked'] = true;
                  item['likes'] = likes + 1;
                }
              });
            },
            child: Image.asset(
              item['image'],
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
            ),
          ),

          // Action Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isLiked'] = !isLiked;
                      item['likes'] = likes + (item['isLiked'] ? 1 : -1);
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isLiked ? Colors.redAccent : Colors.grey.shade700,
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$likes',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.grey.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$comments',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Icon(
                  Icons.send_rounded,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isBookmarked'] = !isBookmarked;
                    });
                  },
                  child: Icon(
                    isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: isBookmarked ? AppColors.primary : Colors.grey.shade700,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // ARTICLE / TEXT Feed Card
  // ----------------------------------------------------
  Widget _buildArticleFeedCard(Map<String, dynamic> item) {
    final isLiked = item['isLiked'] as bool? ?? false;
    final isBookmarked = item['isBookmarked'] as bool? ?? false;
    final likes = item['likes'] as int? ?? 300;
    final comments = item['comments'] as int? ?? 15;
    final tags = (item['tags'] as List?)?.cast<String>() ?? ['Science'];

    return GestureDetector(
      onTap: () => _openArticleDetail(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row (Category Badge & Read Time)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        tags.first.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item['readTime'] ?? '3 min read',
                  style: const TextStyle(
                    color: AppColors.lightTextSecondary,
                    fontSize: 11.5,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: AppColors.lightTextSecondary,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Article Title
            Text(
              item['title'],
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.lightTextPrimary,
                height: 1.3,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),

            // Article Summary Snippet Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                item['caption'],
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF4B5563),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Author & Engagement Row
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: AssetImage(item['avatar']),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${item['author']} • ${item['time']}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isLiked'] = !isLiked;
                      item['likes'] = likes + (item['isLiked'] ? 1 : -1);
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isLiked ? Colors.redAccent : Colors.grey.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$likes',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$comments',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isBookmarked'] = !isBookmarked;
                    });
                  },
                  child: Icon(
                    isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: isBookmarked ? AppColors.primary : Colors.grey.shade600,
                    size: 19,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// Create Post Modal Bottom Sheet
// ----------------------------------------------------
class _CreatePostSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostCreated;

  const _CreatePostSheet({required this.onPostCreated});

  @override
  State<_CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<_CreatePostSheet> {
  String _postType = 'reel'; // 'reel', 'photo', 'article'
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _submit() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text or description!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newPost = <String, dynamic>{
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'type': _postType,
      'title': title.isNotEmpty ? title : 'New Community Update',
      'author': 'Aryan Rathore',
      'role': 'Pro Member • Erbil',
      'avatar': 'assets/images/user_avatar.jpg',
      'time': 'Just now',
      'caption': content,
      'likes': 0,
      'isLiked': false,
      'comments': 0,
      'isBookmarked': false,
    };

    if (_postType == 'reel') {
      newPost['videoThumbnail'] = 'assets/images/workout_back.jpg';
      newPost['duration'] = '0:30';
      newPost['views'] = '1';
      newPost['audioTrack'] = 'Original Gym Sound • Aryan';
    } else if (_postType == 'photo') {
      newPost['image'] = 'assets/images/onboarding_athlete.jpg';
      newPost['category'] = 'Community';
    } else {
      newPost['readTime'] = '2 min read';
      newPost['tags'] = ['Discussion', 'Training'];
      newPost['fullArticle'] = content;
    }

    widget.onPostCreated(newPost);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Create New Post',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Post Type Selector Buttons
          Row(
            children: [
              _buildTypeButton('reel', '🎬 Reel'),
              const SizedBox(width: 8),
              _buildTypeButton('photo', '📸 Photo'),
              const SizedBox(width: 8),
              _buildTypeButton('article', '📝 Article'),
            ],
          ),
          const SizedBox(height: 16),

          // Title Input
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title / Subject',
              hintText: _postType == 'reel' ? 'e.g. Squat PR 180kg' : 'e.g. 5 Nutrition Hacks',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),

          // Content Input
          TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Caption or Content',
              hintText: 'Share your workout progress, coaching tip, or question...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 18),

          // Publish Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text(
                'Publish Post',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type, String label) {
    final isSelected = _postType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _postType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
