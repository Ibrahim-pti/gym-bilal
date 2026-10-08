import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_base/core/services/api_service.dart';
import 'package:gym_base/core/theme/app_colors.dart';

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
  List<dynamic> _banners = [];

  final TextEditingController _memberSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
    final bannersRes = await ApiService().getAdminBanners();

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
        _banners = bannersRes;
        _isLoading = false;
      });
    }
  }

  // ==========================================
  // DIALOG BUILDERS
  // ==========================================

  void _showAddMemberDialog([dynamic member]) {
    final nameCtrl = TextEditingController(text: member?['name'] ?? '');
    final phoneCtrl = TextEditingController(text: member?['phone'] ?? '');
    final balanceCtrl = TextEditingController(text: member != null ? '${member['balance'] ?? 0}' : '0');
    final ageCtrl = TextEditingController(text: member != null && member['age'] != null ? '${member['age']}' : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1E24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          member == null ? 'زیادکردنی ئەندامی نوێ' : 'دەستکاریکردنی ئەندام',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField('ناوی سیانی', nameCtrl),
              const SizedBox(height: 12),
              _buildDialogField('ژمارەی مۆبایل', phoneCtrl, isPhone: true),
              const SizedBox(height: 12),
              _buildDialogField('باڵانس (دینار)', balanceCtrl, isNumber: true),
              const SizedBox(height: 12),
              _buildDialogField('تەمەن', ageCtrl, isNumber: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white60)),
          ),
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

  void _showAddBannerDialog([dynamic banner]) {
    final titleCtrl = TextEditingController(text: banner?['title'] ?? '');
    final subCtrl = TextEditingController(text: banner?['subtitle'] ?? '');
    final tagCtrl = TextEditingController(text: banner?['tag'] ?? 'PRO Offer');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1E24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          banner == null ? 'زیادکردنی کارۆسێلی نوێ' : 'دەستکاریکردنی کارۆسێل',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('سەردێڕی سەرەکی (Title)', titleCtrl),
            const SizedBox(height: 12),
            _buildDialogField('سەردێڕی دووەم (Subtitle)', subCtrl),
            const SizedBox(height: 12),
            _buildDialogField('تاگ (وەک: PRO Offer, Workout)', tagCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              await ApiService().saveBanner({
                if (banner != null) 'id': banner['id'],
                'title': titleCtrl.text.trim(),
                'subtitle': subCtrl.text.trim(),
                'tag': tagCtrl.text.trim(),
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
        backgroundColor: const Color(0xFF1C1E24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          workout == null ? 'زیادکردنی پلانی ڕاهێنان' : 'دەستکاریکردنی ڕاهێنان',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('ناوی ڕاهێنان (Title)', titleCtrl),
            const SizedBox(height: 12),
            _buildDialogField('ڕوونکردنەوە (Description)', descCtrl, maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white60))),
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
        backgroundColor: const Color(0xFF1C1E24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          reel == null ? 'زیادکردنی کورتەڤیدیۆ (Reel)' : 'دەستکاریکردنی ڕیڵز',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('ناوی ڤیدیۆ (Title)', titleCtrl),
            const SizedBox(height: 12),
            _buildDialogField('لینکی ڤیدیۆ (.mp4)', urlCtrl),
            const SizedBox(height: 12),
            _buildDialogField('ناوی ڕاهێنەر', coachCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white60))),
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
        backgroundColor: const Color(0xFF1C1E24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          trainer == null ? 'زیادکردنی ڕاهێنەری نوێ' : 'دەستکاریکردنی ڕاهێنەر',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('ناوی ڕاهێنەر', nameCtrl),
            const SizedBox(height: 12),
            _buildDialogField('مۆبایل', phoneCtrl, isPhone: true),
            const SizedBox(height: 12),
            _buildDialogField('پسپۆڕی', specCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white60))),
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
        backgroundColor: const Color(0xFF1C1E24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          plan == null ? 'زیادکردنی پلانی بەشداری' : 'دەستکاریکردنی پلان و نرخ',
          style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('ناوی پلان (وەک: مانگانە)', nameCtrl),
            const SizedBox(height: 12),
            _buildDialogField('نرخ بە دینار (IQD)', priceCtrl, isNumber: true),
            const SizedBox(height: 12),
            _buildDialogField('ماوە (بە ڕۆژ)', daysCtrl, isNumber: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('پەشیمانبوونەوە', style: GoogleFonts.notoSansArabic(color: Colors.white60))),
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
        fillColor: const Color(0xFF282B33),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  // ==========================================
  // MAIN BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            // Top Modern Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gym Bilal • Admin Hub',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'بەڕێوەبردنی تەواوەتی بەشەکانی ئەپەکە',
                        style: GoogleFonts.notoSansArabic(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                    onPressed: _fetchAllData,
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF181A20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.white60,
                labelStyle: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(icon: Icon(Icons.view_carousel_rounded), text: 'کارۆسێل'),
                  Tab(icon: Icon(Icons.people_alt_rounded), text: 'ئەندامان'),
                  Tab(icon: Icon(Icons.fitness_center_rounded), text: 'ڕاهێنانەکان'),
                  Tab(icon: Icon(Icons.video_library_rounded), text: 'ڕیڵز'),
                  Tab(icon: Icon(Icons.sports_rounded), text: 'ڕاهێنەران'),
                  Tab(icon: Icon(Icons.card_membership_rounded), text: 'پلان و نرخ'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildBannersTab(),
                        _buildMembersTab(),
                        _buildWorkoutsTab(),
                        _buildReelsTab(),
                        _buildTrainersTab(),
                        _buildPlansTab(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 0: CAROUSEL & BANNERS
  // ==========================================
  Widget _buildBannersTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => _showAddBannerDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('زیادکردنی سلاید', style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'سلایدەکانی کارۆسێلی سەرەکی (Home Carousel)',
                style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text('${_banners.length} سلاید', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          if (_banners.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Text('هیچ کارۆسێلێک تۆمارنەکراوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
            )
          else
            ..._banners.map((b) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E2128), Color(0xFF15171C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.view_carousel_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              b['tag'] ?? 'Featured',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(b['title'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          if (b['subtitle'] != null && b['subtitle'].isNotEmpty)
                            Text(b['subtitle'], style: GoogleFonts.notoSansArabic(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                      onPressed: () => _showAddBannerDialog(b),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () async {
                        final confirm = await _showConfirmDelete('ئەم سلایدە بسڕدرێتەوە؟');
                        if (confirm == true) {
                          await ApiService().deleteBanner(b['id']);
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
    );
  }

  // ==========================================
  // TAB 1: MEMBERS
  // ==========================================
  Widget _buildMembersTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => _showAddMemberDialog(),
          icon: const Icon(Icons.person_add_rounded, color: Colors.white),
          label: Text('ئەندامی نوێ', style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
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
              fillColor: const Color(0xFF181A20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'لیستی ئەندامانی جیم',
                style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_members.length} ئەندام • (${_stats['active_members'] ?? 0} کارا)',
                style: GoogleFonts.notoSansArabic(color: AppColors.primary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_members.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Text('هیچ ئەندامێک نەدۆزرایەوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
            )
          else
            ..._members.map((m) {
              final bool isActive = m['status'] == 'active';
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: isActive ? AppColors.primary.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                      child: Icon(Icons.person, color: isActive ? AppColors.primary : Colors.redAccent),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['name'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 3),
                          Text('${m['phone']} • ${m['plan']}', style: GoogleFonts.outfit(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
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
              );
            }),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: WORKOUTS
  // ==========================================
  Widget _buildWorkoutsTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => _showAddWorkoutDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('ڕاهێنانی نوێ', style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('پلانەکانی ڕاهێنانی ناو ئەپ', style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              Text('${_workouts.length} پلان', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          if (_workouts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Text('هیچ ڕاهێنانێک نییە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
            )
          else
            ..._workouts.map((w) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(18),
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
    );
  }

  // ==========================================
  // TAB 3: REELS
  // ==========================================
  Widget _buildReelsTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => _showAddReelDialog(),
          icon: const Icon(Icons.video_call_rounded, color: Colors.white),
          label: Text('ڕیڵزی نوێ', style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('کورتەڤیدیۆکان (Reels)', style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              Text('${_reels.length} ڤیدیۆ', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          if (_reels.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Text('هیچ ڤیدیۆیەک نییە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
            )
          else
            ..._reels.map((r) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(18),
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
    );
  }

  // ==========================================
  // TAB 4: TRAINERS
  // ==========================================
  Widget _buildTrainersTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => _showAddTrainerDialog(),
          icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
          label: Text('ڕاهێنەری نوێ', style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ڕاهێنەرانی جیم (Coaches)', style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              Text('${_trainers.length} ڕاهێنەر', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          if (_trainers.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Text('هیچ ڕاهێنەرێک تۆمارنەکراوە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
            )
          else
            ..._trainers.map((t) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(18),
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
    );
  }

  // ==========================================
  // TAB 5: PLANS & PRICING
  // ==========================================
  Widget _buildPlansTab() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => _showAddPlanDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('پلانی نوێ', style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('پلانەکانی بەشداری و نرخەکان', style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              Text('${_plans.length} پلان', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          if (_plans.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Text('هیچ پلانێک نییە', style: GoogleFonts.notoSansArabic(color: Colors.white54))),
            )
          else
            ..._plans.map((p) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: const Icon(Icons.card_membership_rounded, color: Colors.greenAccent, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['name'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                '${p['price']} دینار',
                                style: GoogleFonts.outfit(color: AppColors.primaryLight, fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                              const Text(' • ', style: TextStyle(color: Colors.white30)),
                              Text(
                                '${p['duration_days']} ڕۆژ',
                                style: GoogleFonts.notoSansArabic(color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),
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
    );
  }

  Future<bool?> _showConfirmDelete(String title) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1E24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
