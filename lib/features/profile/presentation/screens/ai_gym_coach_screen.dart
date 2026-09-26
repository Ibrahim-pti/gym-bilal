import 'package:flutter/material.dart';
import 'package:gym_base/core/theme/app_colors.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class AiGymCoachScreen extends StatefulWidget {
  const AiGymCoachScreen({super.key});

  @override
  State<AiGymCoachScreen> createState() => _AiGymCoachScreenState();
}

class _AiGymCoachScreenState extends State<AiGymCoachScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    const ChatMessage(
      text:
          'سڵاو کاک ئاریان! من Coach Bilal AIـم، ڕاهێنەری زیرەکی دەستکردی هۆڵەکەت 🤖💪.\nدەتوانیت هەر پرسیارێکت لەسەر خشتەی ڕاهێنان، تەکنیکی یارییەکان، یان ڕێجیم و پرۆتین هەیە لێم بپرسیت.',
      isUser: false,
      time: '10:00 AM',
    ),
  ];

  final List<String> _suggestedPrompts = [
    'خشتەیەکی ٤ ڕۆژە بۆ گەورەکردنی ماسولکە دابنێ 🏋️',
    'شانم لە بێنچ پرێس ئازاری هەیە، چی بکەم؟ ⚠️',
    'باشترین ژەمی پێش وەرزش چییە بۆ وزەی بەرز؟ 🍌',
    'چۆن زۆرترین کێش بە سکوات هەڵگرم (PR)? 🚀',
  ];

  void _sendMessage(String query) {
    if (query.trim().isEmpty) return;

    final now = TimeOfDay.now();
    final timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true, time: timeStr));
      _textController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Generate intelligent AI response after short delay
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final reply = _generateAiResponse(query);
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(text: reply, isUser: false, time: timeStr));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateAiResponse(String query) {
    final lower = query.toLowerCase();

    if (lower.contains('٤ ڕۆژ') || lower.contains('خشتە') || lower.contains('split') || lower.contains('4-day')) {
      return '''🔥 **خشتەی ٤ ڕۆژەی پێشنیارکراو (Upper / Lower Hypertrophy Split):**

• **ڕۆژی ١ (Upper Body A - هێز):**
- Incline Barbell Bench Press: 4 سێت × 6-8 دووبارە
- Barbell Bent-Over Row: 4 سێت × 6-8 دووبارە
- Dumbbell Lateral Raises: 3 سێت × 12 دووبارە
- Tricep Dips & Bicep Curls: 3 سێت × 10 دووبارە

• **ڕۆژی ٢ (Lower Body A - قاچ):**
- Barbell Squat: 4 سێت × 6-8 دووبارە
- Romanian Deadlift (RDL): 3 سێت × 8-10 دووبارە
- Leg Press: 3 سێت × 12 دووبارە
- Standing Calf Raises: 4 سێت × 15 دووبارە

• **ڕۆژی ٣: پشوو (Rest & Stretch)**
• **ڕۆژی ٤: Upper Body B (قەبارە و Hypertrophy)**
• **ڕۆژی ٥: Lower Body B (پشتەوەی قاچ و کۆر)**
• **ڕۆژی ٦ و ٧: پشوو**''';
    } else if (lower.contains('ئازار') || lower.contains('شان') || lower.contains('shoulder') || lower.contains('bench')) {
      return '''⚠️ **ئامۆژگاری بۆ ئازاری شان لە بێنچ پرێس:**

١. **پانی دەستەکانت کەمبکەرەوە (Narrow Grip):** زۆر پان گرتنی بارەکە فشاری زیاد دەخاتە سەر بەستەرەکانی پێشەوەی شان.
٢. **کۆکردنەوەی شان (Retract Scapula):** پێش داگرتنی بارەکە، شانت بەرەو دواوە بەرەو یەکتر ببەستە.
٣. **گۆشەی ئانیشکەکانت ٤٥ بۆ ٦٠ پلە بێت:** ئانیشکت مەهێنە هاوتای شانت (Flare out مەکە).
٤. ئەگەر بەردەوام بوو، بە شێوەیەکی کاتی بە **Dumbbell Neutral Grip** یاری بکە تا بەستەرەکان چاک دەبنەوە.''';
    } else if (lower.contains('ژەم') || lower.contains('خۆراک') || lower.contains('diet') || lower.contains('pre-workout') || lower.contains('پێش')) {
      return '''🍌 **باشترین ژەمی ١ بۆ ١.٥ کاتژمێر پێش وەرزش:**

• **کاربۆهیدراتی خێرا هەرسکراو + پرۆتین:**
- مۆزێک 🍌 لەگەڵ ٢ کەوچک شۆفان (Oatmeal) و ١ سکۆپ وی پرۆتین (Whey).
- یان: نانی تۆست لەگەڵ کەرەی فستق (Peanut Butter) و کەمێک هەنگوین.
- خواردنەوەی ٥٠٠ مل ئاو بۆ ئەوەی ماسولکەکانت لە کاتی ڕاهێنان وشک نەبنەوە.''';
    } else {
      return '''ئامۆژگاری پسپۆڕانە لەلایەن Coach Bilal:

بۆ بەدەستهێنانی باشترین ئەنجام لەم قۆناغەی ئێستاتدا:
١. دڵنیابەرەوە لە هەموو سێتێکدا تا نزیک هیلاکی (RPE 8-9) بڕۆیت.
٢. وەرگرتنی کەمترین ١.٨ بۆ ٢.٠ گرام پرۆتین بۆ هەر کیلۆیەکی کێشی لەشت.
٣. خەوتنی ٧ بۆ ٨ کاتژمێری شەوانە بۆ گەشەی تەواوی هۆرمۆنی تێستۆستیرۆن و چاکبوونەوەی ماسولکە.

ئەگەر پرسیارێکی وردترت هەیە لەسەر جووڵەیەکی دیاریکراو پێم بڵێ! 💪''';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16181E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFFEC4899)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF16181E), width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coach Bilal AI 🤖',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Always Active • Smart Fitness Advisor',
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Coach Bilal AI خەریکی وەڵامدانەوەیە...',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11.5),
                  ),
                ],
              ),
            ),

          // Quick Suggested Prompt Chips
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: _suggestedPrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final prompt = _suggestedPrompts[i];
                return GestureDetector(
                  onTap: () => _sendMessage(prompt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2129),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Text(
                      prompt,
                      style: const TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(14, 10, 14, MediaQuery.of(context).padding.bottom + 10),
            decoration: const BoxDecoration(
              color: Color(0xFF16181F),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222631),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'پرسیار لە کۆچ بیلال بکە...',
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_textController.text),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primary : const Color(0xFF1C1F28),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 18),
          ),
          border: msg.isUser ? null : Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.45),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                msg.time,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
