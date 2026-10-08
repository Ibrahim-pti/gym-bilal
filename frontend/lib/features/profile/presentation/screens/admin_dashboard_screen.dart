import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_base/core/services/api_service.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/layout/presentation/screens/main_layout.dart';
import 'package:gym_base/features/onboarding/presentation/screens/member_login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  Map<String, dynamic> _stats = {};
  List<dynamic> _members = [];
  List<dynamic> _workouts = [];
  List<dynamic> _reels = [];
  List<dynamic> _trainers = [];
  List<dynamic> _plans = [];

  final TextEditingController _memberSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _memberSearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllData() async {
    setState(() => _isLoading = true);

    final statsRes = await ApiService().getAdminStats();
    final membersRes = await ApiService().getAdminMembers(search: _memberSearchController.text.trim());
    final workoutsRes = await ApiService().getAdminWorkouts();
    final reelsRes = await ApiService().getAdminReels();
    final trainersRes = await ApiService().getAdminTrainers();
    final plansRes = await ApiService().getAdminPlans();

    if (mounted) {
      setState(() {
        if (statsRes['status'] == true && statsRes['stats'] != null) {
          _stats = statsRes['stats'];
        }
        _members = membersRes;
        _workouts = workoutsRes;
        _reels = reelsRes;
        _trainers = trainersRes;
        _plans = plansRes;
        _isLoading = false;
      });
    }
  }

  // ==========================================
  // ADD / EDIT MODALS
  // ==========================================

  void _showAddMemberDialog([dynamic member]) {
    final nameCtrl = TextEditingController(text: member?['name'] ?? '');
    final phoneCtrl = TextEditingController(text: member?['phone'] ?? '');
    final balanceCtrl = TextEditingController(text: member != null ? '${member['balance'] ?? 0}' : '0');
    final ageCtrl = TextEditingController(text: member != null && member['age'] != null ? '${member['age']}' : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          member == null ? 'زیادکردنی ئەندامی نوێ' : 'دەستکاریکردنی ئەندام',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField('ناوی سیانی', nameCtrl),
              const SizedBox(height: 10),
              _buildDialogField('ژمارەی مۆبایل', phoneCtrl, isPhone: true),
              const SizedBox(height: 10),
              _buildDialogField('باڵانس (IQD)', balanceCtrl, isNumber: true),
              const SizedBox(height: 10),
              _buildDialogField('تەمەن', ageCtrl, isNumber: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              await ApiService().saveMember({
                if (member != null) 'id': member['id'],
                'name': nameCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'balance': double.tryParse(balanceCtrl.text) ?? 0,
                'age': int.tryParse(ageCtrl.text),
              });
              _fetchAllData();
            },
            child: Text('سەیڤکردن', style: GoogleFonts.notoSansArabic(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddWorkoutDialog([dynamic workout]) {
    final titleCtrl = TextEditingController(text: workout?['title'] ?? '');
    final descCtrl = TextEditingController(text: workout?['description'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          workout == null ? 'زیادکردنی پلانی ڕاهێنان' : 'دەستکاریکردنی ڕاهێنان',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('ناوی ڕاهێنان (Title)', titleCtrl),
            const SizedBox(height: 10),
            _buildDialogField('ڕوونکردنەوە (Description)', descCtrl, maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              await ApiService().saveWorkout({
                if (workout != null) 'id': workout['id'],
                'title': titleCtrl.text.trim(),
                'description': descCtrl.text.trim(),
              });
              _fetchAllData();
            },
            child: Text('سەیڤکردن', style: GoogleFonts.notoSansArabic(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddReelDialog([dynamic reel]) {
    final titleCtrl = TextEditingController(text: reel?['title'] ?? '');
    final urlCtrl = TextEditingController(text: reel?['video_url'] ?? '');
    final coachCtrl = TextEditingController(text: reel?['coach_name'] ?? 'Coach Bilal');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          reel == null ? 'زیادکردنی کورتەڤیدیۆ (Reel)' : 'دەستکاریکردنی ڕیڵز',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('ناوی ڤیدیۆ (Title)', titleCtrl),
            const SizedBox(height: 10),
            _buildDialogField('لینکی ڤیدیۆ (Video URL .mp4)', urlCtrl),
            const SizedBox(height: 10),
            _buildDialogField('ناوی ڕاهێنەر (Coach)', coachCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty || urlCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              await ApiService().saveReel({
                if (reel != null) 'id': reel['id'],
                'title': titleCtrl.text.trim(),
                'video_url': urlCtrl.text.trim(),
                'coach_name': coachCtrl.text.trim(),
              });
              _fetchAllData();
            },
            child: Text('سەیڤکردن', style: GoogleFonts.notoSansArabic(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddTrainerDialog([dynamic trainer]) {
    final nameCtrl = TextEditingController(text: trainer?['name'] ?? '');
    final phoneCtrl = TextEditingController(text: trainer?['phone'] ?? '');
    final specCtrl = TextEditingController(text: trainer?['specialty'] ?? 'Bodybuilding Coach');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          trainer == null ? 'زیادکردنی ڕاهێنەری نوێ' : 'دەستکاریکردنی ڕاهێنەر',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('ناوی ڕاهێنەر', nameCtrl),
            const SizedBox(height: 10),
            _buildDialogField('مۆبایل', phoneCtrl, isPhone: true),
            const SizedBox(height: 10),
            _buildDialogField('پسپۆڕی (Specialty)', specCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              await ApiService().saveTrainer({
                if (trainer != null) 'id': trainer['id'],
                'name': nameCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'specialty': specCtrl.text.trim(),
              });
              _fetchAllData();
            },
            child: Text('سەیڤکردن', style: GoogleFonts.notoSansArabic(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddPlanDialog([dynamic plan]) {
    final nameCtrl = TextEditingController(text: plan?['name'] ?? '');
    final priceCtrl = TextEditingController(text: plan != null ? '${plan['price'] ?? 0}' : '25000');
    final daysCtrl = TextEditingController(text: plan != null ? '${plan['duration_days'] ?? 30}' : '30');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          plan == null ? 'زیادکردنی پلانی بەشداریکردن' : 'دەستکاریکردنی پلان و نرخ',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('ناوی پلان (وەک: مانگانە)', nameCtrl),
            const SizedBox(height: 10),
            _buildDialogField('نرخ (IQD)', priceCtrl, isNumber: true),
            const SizedBox(height: 10),
            _buildDialogField('ماوە (ڕۆژ)', daysCtrl, isNumber: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              await ApiService().savePlan({
                if (plan != null) 'id': plan['id'],
                'name': nameCtrl.text.trim(),
                'price': double.tryParse(priceCtrl.text) ?? 25000,
                'duration_days': int.tryParse(daysCtrl.text) ?? 30,
              });
              _fetchAllData();
            },
            child: Text('سەیڤکردن', style: GoogleFonts.notoSansArabic(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, TextEditingController ctrl, {bool isPhone = false, bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isPhone ? TextInputType.phone : (isNumber ? TextInputType.number : TextInputType.text),
      style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.notoSansArabic(color: Colors.white60, fontSize: 13),
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: Text(
          'بەڕێوەبەری ئەپ (Gym Bilal Hub)',
          style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            tooltip: 'دۆخی ئەندام (User App)',
            icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainLayout()),
              );
            },
          ),
          IconButton(
            tooltip: 'چوونەدەرەوە',
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () async {
              await ApiService().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MemberLoginScreen()),
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.people_alt_rounded), text: 'ئەندامان'),
            Tab(icon: Icon(Icons.fitness_center_rounded), text: 'ڕاهێنانەکان'),
            Tab(icon: Icon(Icons.video_library_rounded), text: 'ڕیڵز و کورتەڤیدیۆ'),
            Tab(icon: Icon(Icons.sports_rounded), text: 'ڕاهێنەران'),
            Tab(icon: Icon(Icons.card_membership_rounded), text: 'پلان و نرخەکان'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMembersTab(),
                _buildWorkoutsTab(),
                _buildReelsTab(),
                _buildTrainersTab(),
                _buildPlansTab(),
              ],
            ),
    );
  }

  // ==========================================
  // TAB 1: MEMBERS
  // ==========================================
  Widget _buildMembersTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddMemberDialog(),
        child: const Icon(Icons.person_add_rounded, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _fetchAllData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _memberSearchController,
              style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 14),
              onChanged: (_) => _fetchAllData(),
              decoration: InputDecoration(
                hintText: 'گەڕان بە ناو، مۆبایل، بارکۆد...',
                hintStyle: GoogleFonts.notoSansArabic(color: Colors.white30, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.darkSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '${_members.length} ئەندام تۆمارکراوە • (${_stats['active_members'] ?? 0} بەشداری کارا)',
              style: GoogleFonts.notoSansArabic(color: AppColors.darkTextSecondary, fontSize: 13),
            ),
            const SizedBox(height: 10),
            if (_members.isEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(child: Text('هیچ ئەندامێک نەدۆزرایەوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
              )
            else
              ..._members.map((m) {
                final bool isActive = m['status'] == 'active';
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isActive ? AppColors.primary.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                      child: Icon(Icons.person, color: isActive ? AppColors.primary : Colors.redAccent),
                    ),
                    title: Text(m['name'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('${m['phone']} • ${m['plan']}', style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                          onPressed: () => _showAddMemberDialog(m),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () async {
                            final confirm = await _showConfirmDelete('ئەم ئەندامە بسڕدرێتەوە؟');
                            if (confirm == true) {
                              await ApiService().deleteMember(m['id']);
                              _fetchAllData();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2: WORKOUTS
  // ==========================================
  Widget _buildWorkoutsTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddWorkoutDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _fetchAllData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('پلانەکانی ڕاهێنانی ئەپ', style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${_workouts.length} پلان', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            if (_workouts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(child: Text('هیچ پلانێکی ڕاهێنان نییە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
              )
            else
              ..._workouts.map((w) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(w['title'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(w['description'] ?? 'بێ ڕوونکردنەوە', style: GoogleFonts.notoSansArabic(color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                        onPressed: () => _showAddWorkoutDialog(w),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          final confirm = await _showConfirmDelete('ئەم پلانە بسڕدرێتەوە؟');
                          if (confirm == true) {
                            await ApiService().deleteWorkout(w['id']);
                            _fetchAllData();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 3: REELS
  // ==========================================
  Widget _buildReelsTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddReelDialog(),
        child: const Icon(Icons.video_call_rounded, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _fetchAllData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('کورتەڤیدیۆکانی ناو ئەپ (Reels)', style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${_reels.length} ڤیدیۆ', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            if (_reels.isEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(child: Text('هیچ ڤیدیۆیەک نییە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
              )
            else
              ..._reels.map((r) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.purpleAccent, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r['title'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('${r['coach_name']} • ${r['likes_count'] ?? 0} Likes', style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                        onPressed: () => _showAddReelDialog(r),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          final confirm = await _showConfirmDelete('ئەم ڤیدیۆیە بسڕدرێتەوە؟');
                          if (confirm == true) {
                            await ApiService().deleteReel(r['id']);
                            _fetchAllData();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 4: TRAINERS
  // ==========================================
  Widget _buildTrainersTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddTrainerDialog(),
        child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _fetchAllData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ڕاهێنەرانی جیم (Coaches)', style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${_trainers.length} ڕاهێنەر', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            if (_trainers.isEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(child: Text('هیچ ڕاهێنەرێک تۆمارنەکراوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
              )
            else
              ..._trainers.map((t) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.sports_rounded, color: Colors.amber, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t['name'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text('${t['specialty'] ?? ''} • ${t['phone'] ?? ''}', style: GoogleFonts.notoSansArabic(color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                        onPressed: () => _showAddTrainerDialog(t),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          final confirm = await _showConfirmDelete('ئەم ڕاهێنەرە بسڕدرێتەوە؟');
                          if (confirm == true) {
                            await ApiService().deleteTrainer(t['id']);
                            _fetchAllData();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 5: PLANS & PRICING
  // ==========================================
  Widget _buildPlansTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddPlanDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _fetchAllData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('پلانەکانی بەشداری و نرخەکان', style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${_plans.length} پلان', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            if (_plans.isEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(child: Text('هیچ پلانێک نییە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
              )
            else
              ..._plans.map((p) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.payments_rounded, color: Colors.greenAccent, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['name'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text('${p['duration_days']} ڕۆژ • ${p['price']} IQD', style: GoogleFonts.outfit(color: AppColors.primaryLight, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                        onPressed: () => _showAddPlanDialog(p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          final confirm = await _showConfirmDelete('ئەم پلانە بسڕدرێتەوە؟');
                          if (confirm == true) {
                            await ApiService().deletePlan(p['id']);
                            _fetchAllData();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDelete(String title) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(title, style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('نەخێر', style: GoogleFonts.notoSansArabic(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('سڕینەوە', style: GoogleFonts.notoSansArabic(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
