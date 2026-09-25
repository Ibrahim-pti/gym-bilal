import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ReelsViewerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> reels;
  final int initialIndex;

  const ReelsViewerScreen({
    super.key,
    required this.reels,
    this.initialIndex = 0,
  });

  @override
  State<ReelsViewerScreen> createState() => _ReelsViewerScreenState();
}

class _ReelsViewerScreenState extends State<ReelsViewerScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  bool _isPlaying = true;
  bool _isMuted = false;
  double _playbackProgress = 0.0;
  Timer? _progressTimer;

  // Heart pop animation on double tap
  bool _showHeartAnimation = false;
  Offset _heartPosition = Offset.zero;
  late AnimationController _heartAnimController;
  late Animation<double> _heartScaleAnimation;
  late Animation<double> _heartOpacityAnimation;

  // Vinyl disc rotation animation
  late AnimationController _discAnimController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _heartScaleAnimation = Tween<double>(begin: 0.2, end: 1.3).animate(
      CurvedAnimation(parent: _heartAnimController, curve: Curves.elasticOut),
    );
    _heartOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _heartAnimController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _discAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _startProgressSimulator();
  }

  void _startProgressSimulator() {
    _progressTimer?.cancel();
    _playbackProgress = 0.0;
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPlaying && mounted) {
        setState(() {
          _playbackProgress += 0.01;
          if (_playbackProgress >= 1.0) {
            _playbackProgress = 0.0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _pageController.dispose();
    _heartAnimController.dispose();
    _discAnimController.dispose();
    super.dispose();
  }

  void _onDoubleTap(TapDownDetails details) {
    final currentReel = widget.reels[_currentIndex];
    setState(() {
      if (!(currentReel['isLiked'] as bool? ?? false)) {
        currentReel['isLiked'] = true;
        currentReel['likes'] = (currentReel['likes'] as int? ?? 0) + 1;
      }
      _heartPosition = details.localPosition;
      _showHeartAnimation = true;
    });

    _heartAnimController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _showHeartAnimation = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _discAnimController.repeat();
      } else {
        _discAnimController.stop();
      }
    });
  }

  void _openCommentsSheet(Map<String, dynamic> reel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CommentsBottomSheet(reel: reel),
    );
  }

  void _shareReel(Map<String, dynamic> reel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Reel link copied to clipboard: "${reel['title'] ?? 'Gym Reel'}"',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vertical PageView of Reels
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: widget.reels.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _isPlaying = true;
              });
              _discAnimController.repeat();
              _startProgressSimulator();
            },
            itemBuilder: (context, index) {
              final reel = widget.reels[index];
              return _buildReelItem(reel);
            },
          ),

          // Double Tap Popping Heart Animation
          if (_showHeartAnimation)
            Positioned(
              left: _heartPosition.dx - 48,
              top: _heartPosition.dy - 48,
              child: AnimatedBuilder(
                animation: _heartAnimController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _heartScaleAnimation.value,
                    child: Opacity(
                      opacity: _heartOpacityAnimation.value,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.redAccent,
                        size: 96,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Top Header (Back, Audio Mute, Live indicator)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Reels Title & Live Pulse
                    Row(
                      children: [
                        const Text(
                          'Reels',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: Color(0xFFFF5252),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'FITNESS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Mute / Unmute
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isMuted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Play/Pause Center Indicator (when paused)
          if (!_isPlaying)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 54,
                ),
              ),
            ),

          // Bottom Linear Playback Progress Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              value: _playbackProgress,
              minHeight: 2.5,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReelItem(Map<String, dynamic> reel) {
    final isLiked = reel['isLiked'] as bool? ?? false;
    final isBookmarked = reel['isBookmarked'] as bool? ?? false;
    final likesCount = reel['likes'] as int? ?? 1200;
    final commentsCount = reel['comments'] as int? ?? 45;
    final String imagePath = reel['videoThumbnail'] ?? 'assets/images/workout_back.jpg';
    final String author = reel['author'] ?? 'Coach Bilal';
    final String avatar = reel['avatar'] ?? 'assets/images/user_avatar.jpg';
    final String caption = reel['caption'] ?? 'Workout routine';
    final String audioTrack = reel['audioTrack'] ?? 'Original Gym Audio • High Energy';
    final String? exerciseTag = reel['exerciseTag'];

    return GestureDetector(
      onTap: _togglePlayPause,
      onDoubleTapDown: _onDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Video Still / Simulation
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),

          // Gradient Vignette for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.0, 0.2, 0.65, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Right Floating Action Column
          Positioned(
            right: 14,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Coach Avatar with Follow '+' button
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: AssetImage(avatar),
                      ),
                    ),
                    Positioned(
                      bottom: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Like Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      reel['isLiked'] = !isLiked;
                      reel['likes'] = likesCount + (reel['isLiked'] ? 1 : -1);
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isLiked ? Colors.redAccent : Colors.white,
                        size: 32,
                        shadows: const [
                          Shadow(color: Colors.black54, blurRadius: 8),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatNumber(reel['likes'] as int? ?? likesCount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Comments Button
                GestureDetector(
                  onTap: () => _openCommentsSheet(reel),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white,
                        size: 30,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 8),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatNumber(commentsCount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Bookmark / Save
                GestureDetector(
                  onTap: () {
                    setState(() {
                      reel['isBookmarked'] = !isBookmarked;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          reel['isBookmarked'] ? 'Saved to your Workout Vault 🔖' : 'Removed from Saved',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(
                        isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isBookmarked ? const Color(0xFFFFB800) : Colors.white,
                        size: 30,
                        shadows: const [
                          Shadow(color: Colors.black54, blurRadius: 8),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Share Button
                GestureDetector(
                  onTap: () => _shareReel(reel),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 28,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 8),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Spinning Vinyl Music Disc
                RotationTransition(
                  turns: _discAnimController,
                  child: Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF222222), Color(0xFF111111)],
                      ),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(avatar),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Left Content Info
          Positioned(
            left: 16,
            right: 84,
            bottom: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Author row with verified tick
                Row(
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF3897F0),
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Caption text
                Text(
                  caption,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    height: 1.35,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 10),

                // Tagged Exercise Chip (if any)
                if (exerciseTag != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.fitness_center_rounded,
                          color: AppColors.primary,
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          exerciseTag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 9,
                        ),
                      ],
                    ),
                  ),

                // Audio Track Ticker
                Row(
                  children: [
                    const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        audioTrack,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          shadows: const [Shadow(color: Colors.black87, blurRadius: 4)],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return '$number';
  }
}

// ----------------------------------------------------
// Comments Bottom Sheet
// ----------------------------------------------------
class _CommentsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> reel;

  const _CommentsBottomSheet({required this.reel});

  @override
  State<_CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<_CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      'user': 'Sardar Kurdish',
      'avatar': 'assets/images/user_avatar.jpg',
      'time': '12m ago',
      'text': 'Insane form! The lockout speed is phenomenal 🔥💪',
      'likes': 42,
      'isLiked': false,
    },
    {
      'user': 'Coach Halgurd',
      'avatar': 'assets/images/splash_athlete.jpg',
      'time': '45m ago',
      'text': 'Perfect hip hinge mechanics. Everyone should study this setup!',
      'likes': 28,
      'isLiked': true,
    },
    {
      'user': 'Shano Fitness',
      'avatar': 'assets/images/female_fitness_banner.jpg',
      'time': '2h ago',
      'text': 'What brand lifting belt is that? Looks sturdy 🏋️‍♀️',
      'likes': 9,
      'isLiked': false,
    },
    {
      'user': 'Zana Hawleri',
      'avatar': 'assets/images/onboarding_athlete.jpg',
      'time': '4h ago',
      'text': 'Road to 260kg brother! Keep crushing it 🚀',
      'likes': 15,
      'isLiked': false,
    },
  ];

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.insert(0, {
        'user': 'Aryan Rathore',
        'avatar': 'assets/images/user_avatar.jpg',
        'time': 'Just now',
        'text': text,
        'likes': 0,
        'isLiked': false,
      });
      _commentController.clear();
      widget.reel['comments'] = (widget.reel['comments'] as int? ?? 0) + 1;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Color(0xFF1E2024),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments (${_comments.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),

          // Comments List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _comments.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                final isLiked = comment['isLiked'] as bool;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundImage: AssetImage(comment['avatar']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment['user'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                comment['time'],
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            comment['text'],
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          comment['isLiked'] = !isLiked;
                          comment['likes'] = (comment['likes'] as int) + (comment['isLiked'] ? 1 : -1);
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 16,
                            color: isLiked ? Colors.redAccent : Colors.white54,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${comment['likes']}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Add Comment Input Field
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF16171A),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 17,
                  backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white, fontSize: 13.5),
                      decoration: InputDecoration(
                        hintText: 'Add a gym tip or comment...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _addComment(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addComment,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
