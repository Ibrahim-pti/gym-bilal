import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_base/core/services/api_service.dart';
import 'package:gym_base/core/theme/app_colors.dart';
import 'package:gym_base/features/layout/presentation/screens/main_layout.dart';
import 'package:gym_base/features/profile/presentation/screens/admin_dashboard_screen.dart';

class MemberLoginScreen extends StatefulWidget {
  const MemberLoginScreen({super.key});

  @override
  State<MemberLoginScreen> createState() => _MemberLoginScreenState();
}

class _MemberLoginScreenState extends State<MemberLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _adminPinController = TextEditingController();

  bool _isLoading = false;
  bool _showAdminPin = false;
  int _logoTapCount = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _adminPinController.dispose();
    super.dispose();
  }

  void _onLogoTapped() {
    _logoTapCount++;
    if (_logoTapCount >= 3) {
      setState(() {
        _showAdminPin = !_showAdminPin;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _showAdminPin ? 'دۆخی ئەدمین (Admin Mode) کرایەوە' : 'دۆخی ئەدمین داخرا',
            style: GoogleFonts.notoSansArabic(),
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
      _logoTapCount = 0;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final res = await ApiService().loginOrRegister(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      adminPin: _showAdminPin ? _adminPinController.text.trim() : null,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (res['status'] == true) {
      final bool isAdmin = res['is_admin'] == true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAdmin ? 'بەخێربێیت بەڕێوەبەر! بە سەرکەوتوویی چوویتە ژوورەوە' : 'بەخێربێیت! بە سەرکەوتوویی چوویتە ژوورەوە',
            style: GoogleFonts.notoSansArabic(),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, _, _) => const MainLayout(),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res['message'] ?? 'هەڵەیەک ڕوویدا لە کاتی پەیوەندی',
            style: GoogleFonts.notoSansArabic(),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Gym Bilal Logo (Tap 3 times to reveal Admin PIN)
                      GestureDetector(
                        onTap: _onLogoTapped,
                        child: Hero(
                          tag: 'gym_logo',
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.45),
                                  blurRadius: 25,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.fitness_center_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title & Subtitle
                      Text(
                        'GYM BILAL',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'چوونەژوورەوەی ئەندامان و بەشداربووان',
                        style: GoogleFonts.notoSansArabic(
                          fontSize: 15,
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Glass Form Container
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Name Label & Field
                            Text(
                              'ناوی سیانی (Full Name)',
                              style: GoogleFonts.notoSansArabic(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              style: GoogleFonts.notoSansArabic(color: Colors.white),
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                hintText: 'بۆ نموونە: کاردۆ ئەحمەد',
                                hintStyle: GoogleFonts.notoSansArabic(
                                  color: Colors.white30,
                                  fontSize: 13,
                                ),
                                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                                filled: true,
                                fillColor: AppColors.darkCard,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'تکایە ناوت بنووسە';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),

                            // Phone Number Label & Field
                            Text(
                              'ژمارەی مۆبایل (Phone Number)',
                              style: GoogleFonts.notoSansArabic(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: GoogleFonts.outfit(color: Colors.white, fontSize: 15),
                              decoration: InputDecoration(
                                hintText: '0750 000 0000',
                                hintStyle: GoogleFonts.outfit(
                                  color: Colors.white30,
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(Icons.phone_iphone_rounded, color: AppColors.primary),
                                filled: true,
                                fillColor: AppColors.darkCard,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'تکایە ژمارەی مۆبایل بنووسە';
                                }
                                if (val.trim().length < 8) {
                                  return 'ژمارەی مۆبایل ناتەواوە';
                                }
                                return null;
                              },
                            ),

                            // Hidden / Secret Admin PIN Input
                            if (_showAdminPin) ...[
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  const Icon(Icons.shield_outlined, color: Colors.amber, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'کۆدی ئەدمین (Admin PIN: 1234)',
                                    style: GoogleFonts.notoSansArabic(
                                      color: Colors.amber,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _adminPinController,
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.outfit(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'کۆدی ئەدمین بنووسە...',
                                  hintStyle: GoogleFonts.notoSansArabic(color: Colors.white30, fontSize: 13),
                                  prefixIcon: const Icon(Icons.vpn_key_rounded, color: Colors.amber),
                                  filled: true,
                                  fillColor: AppColors.darkCard,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Colors.amber),
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 26),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: AppColors.buttonGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.35),
                                      blurRadius: 18,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'چوونەژوورەوە',
                                              style: GoogleFonts.notoSansArabic(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Text(
                        'بەبێ پێویستی بە وشەی نهێنی یان کۆدی کورتەپەیام',
                        style: GoogleFonts.notoSansArabic(
                          color: AppColors.darkTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
