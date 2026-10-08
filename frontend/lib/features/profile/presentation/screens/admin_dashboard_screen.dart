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

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _stats = {
    'total_members': 0,
    'today_checkins': 0,
    'active_members': 0,
    'expired_members': 0,
  };
  List<dynamic> _members = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _barcodeInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _barcodeInputController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final statsRes = await ApiService().getAdminStats();
    final membersList = await ApiService().getAdminMembers(search: _searchController.text.trim());

    if (mounted) {
      setState(() {
        if (statsRes['status'] == true && statsRes['stats'] != null) {
          _stats = statsRes['stats'];
        }
        _members = membersList;
        _isLoading = false;
      });
    }
  }

  void _showScanDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        bool scanning = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'سکانکردنی بارکۆد / QR Code',
                        style: GoogleFonts.notoSansArabic(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'کۆدی بارکۆد، ژمارەی مۆبایل، یان ناسنامەی ئەندام بنووسە یان بسکێنە:',
                    style: GoogleFonts.notoSansArabic(
                      color: AppColors.darkTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _barcodeInputController,
                    autofocus: true,
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'GB425551 یان 0750...',
                      hintStyle: GoogleFonts.outfit(color: Colors.white30),
                      prefixIcon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
                      filled: true,
                      fillColor: AppColors.darkCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: scanning
                        ? null
                        : () async {
                            final code = _barcodeInputController.text.trim();
                            if (code.isEmpty) return;

                            setModalState(() => scanning = true);
                            final res = await ApiService().scanAttendance(code);
                            setModalState(() => scanning = false);

                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            if (!mounted) return;
                            _barcodeInputController.clear();
                            _showScanResult(res);
                            _fetchData();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: scanning
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'تۆمارکردنی هاتنەژوورەوە',
                            style: GoogleFonts.notoSansArabic(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showScanResult(Map<String, dynamic> res) {
    final bool success = res['status'] == true;
    final member = res['member'];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(
                success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                color: success ? Colors.greenAccent : Colors.redAccent,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  success ? (res['message'] ?? 'سەرکەوتوو بوو') : 'هەڵە لە تۆمارکردن',
                  style: GoogleFonts.notoSansArabic(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          content: member != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ناوی ئەندام: ${member['name']}',
                        style: GoogleFonts.notoSansArabic(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('مۆبایل: ${member['phone']}', style: GoogleFonts.outfit(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text('جۆری بەشداری: ${member['plan_name']}',
                        style: GoogleFonts.notoSansArabic(color: AppColors.primaryLight)),
                    const SizedBox(height: 6),
                    Text('ڕۆژانی ماوە: ${member['days_left']} ڕۆژ',
                        style: GoogleFonts.notoSansArabic(
                            color: (member['days_left'] ?? 0) > 0 ? Colors.green : Colors.redAccent)),
                    const SizedBox(height: 6),
                    Text('کاتی تۆمارکردن: ${res['time'] ?? ''}', style: GoogleFonts.outfit(color: Colors.white54)),
                  ],
                )
              : Text(res['message'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('باشە', style: GoogleFonts.notoSansArabic(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }

  void _renewMember(dynamic member) async {
    final plans = await ApiService().getSubscriptionPlans();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'نوێکردنەوەی بەشداری بۆ ${member['name']}',
                style: GoogleFonts.notoSansArabic(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              if (plans.isEmpty)
                Text('هیچ پلانێک بەردەست نییە', style: GoogleFonts.notoSansArabic(color: Colors.white54))
              else
                ...plans.map((p) {
                  return Card(
                    color: AppColors.darkCard,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(p['name'] ?? '', style: GoogleFonts.notoSansArabic(color: Colors.white)),
                      subtitle: Text('${p['duration_days']} ڕۆژ - \$${p['price']}',
                          style: GoogleFonts.outfit(color: AppColors.primaryLight)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          final res = await ApiService().renewMemberSubscription(member['id'], p['id']);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res['message'] ?? 'نوێکرایەوە', style: GoogleFonts.notoSansArabic()),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _fetchData();
                        },
                        child: Text('هەڵبژاردن', style: GoogleFonts.notoSansArabic(color: Colors.white)),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
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
          'بەڕێوەبەری جیم (Admin Hub)',
          style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            tooltip: 'دۆخی ئەندام (User Mode)',
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Big QR Scanner Action Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _showScanDialog,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'سکانکردنی کارتی ئەندام',
                                        style: GoogleFonts.notoSansArabic(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'پشکنینی چوونەژوورەوەی جیم بە بارکۆد',
                                        style: GoogleFonts.notoSansArabic(
                                          fontSize: 13,
                                          color: Colors.white.withValues(alpha: 0.85),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Metrics Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'کۆی ئەندامان',
                            value: '${_stats['total_members'] ?? 0}',
                            icon: Icons.people_alt_rounded,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'هاتنی ئەمڕۆ',
                            value: '${_stats['today_checkins'] ?? 0}',
                            icon: Icons.how_to_reg_rounded,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'بەشداری کارا',
                            value: '${_stats['active_members'] ?? 0}',
                            icon: Icons.verified_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'بەسەرچوو',
                            value: '${_stats['expired_members'] ?? 0}',
                            icon: Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search Members
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'لیستی ئەندامان',
                          style: GoogleFonts.notoSansArabic(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${_members.length} ئەندام',
                          style: GoogleFonts.outfit(color: AppColors.darkTextSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 14),
                      onChanged: (_) => _fetchData(),
                      decoration: InputDecoration(
                        hintText: 'گەڕان بە ناو، مۆبایل، یان بارکۆد...',
                        hintStyle: GoogleFonts.notoSansArabic(color: Colors.white30, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                        filled: true,
                        fillColor: AppColors.darkSurface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Members List
                    if (_members.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Center(
                          child: Text(
                            'هیچ ئەندامێک نەدۆزرایەوە',
                            style: GoogleFonts.notoSansArabic(color: Colors.white54),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _members.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (ctx, index) {
                          final m = _members[index];
                          final bool isActive = m['status'] == 'active';
                          return Container(
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
                              title: Text(
                                m['name'] ?? '',
                                style: GoogleFonts.notoSansArabic(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${m['phone']} • ${m['barcode'] ?? ''}',
                                style: GoogleFonts.outfit(color: AppColors.darkTextSecondary, fontSize: 12),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () => _renewMember(m),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkCard,
                                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  'نوێکردنەوە',
                                  style: GoogleFonts.notoSansArabic(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSansArabic(color: AppColors.darkTextSecondary, fontSize: 12),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
