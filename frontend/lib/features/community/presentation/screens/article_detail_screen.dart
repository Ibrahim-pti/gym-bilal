import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late bool _isLiked;
  late int _likes;
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.article['isLiked'] as bool? ?? false;
    _likes = widget.article['likes'] as int? ?? 120;
    _isBookmarked = widget.article['isBookmarked'] as bool? ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.article['title'] as String? ?? 'Training Guide';
    final author = widget.article['author'] as String? ?? 'Coach Bilal';
    final role = widget.article['role'] as String? ?? 'Elite Strength Coach';
    final avatar = widget.article['avatar'] as String? ?? 'assets/images/user_avatar.jpg';
    final time = widget.article['time'] as String? ?? '2 hours ago';
    final readTime = widget.article['readTime'] as String? ?? '4 min read';
    final fullArticle = widget.article['fullArticle'] as String? ??
        'Proper recovery and mechanical tension are the most critical factors for muscle hypertrophy...';
    final List<String> tags = (widget.article['tags'] as List?)?.cast<String>() ?? ['Hypertrophy', 'Recovery'];
    final List<String>? keyTakeaways = (widget.article['takeaways'] as List?)?.cast<String>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          tags.isNotEmpty ? tags.first : 'Article',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppColors.primary : AppColors.lightTextPrimary,
            ),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
                widget.article['isBookmarked'] = _isBookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isBookmarked ? 'Article bookmarked! 🔖' : 'Removed from bookmarks'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.lightTextPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Article link copied: "$title"'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category & Read Time Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tags.isNotEmpty ? tags.first.toUpperCase() : 'GUIDE',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•  $readTime',
                  style: const TextStyle(
                    color: AppColors.lightTextSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.lightTextPrimary,
                height: 1.25,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Author Header Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(avatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              author,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.lightTextPrimary,
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
                        const SizedBox(height: 2),
                        Text(
                          '$role • $time',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tags chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, width: 0.8),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Key Takeaways Highlight Box
            if (keyTakeaways != null && keyTakeaways.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      const Color(0xFFFFF7ED),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bolt_rounded, color: AppColors.primary, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'KEY COACHING TAKEAWAYS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...keyTakeaways.map((takeaway) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('⚡ ', style: TextStyle(fontSize: 12)),
                              Expanded(
                                child: Text(
                                  takeaway,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.lightTextPrimary,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Article Body Text
            Text(
              fullArticle,
              style: const TextStyle(
                fontSize: 15.5,
                height: 1.7,
                color: Color(0xFF2D3748),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 24),

            // Coach Quote Block
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2024),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '"Intensity without consistency is meaningless. Master the basic compound lifts, eat in a slight surplus, and allow your body the rest it needs."',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontStyle: FontStyle.italic,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '— $author',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLiked = !_isLiked;
                  _likes += _isLiked ? 1 : -1;
                  widget.article['isLiked'] = _isLiked;
                  widget.article['likes'] = _likes;
                });
              },
              child: Row(
                children: [
                  Icon(
                    _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _isLiked ? Colors.redAccent : Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_likes Likes',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  '${widget.article['comments'] ?? 18} Comments',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening discussion thread...'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              icon: const Icon(Icons.forum_rounded, size: 16),
              label: const Text('Discuss', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}
