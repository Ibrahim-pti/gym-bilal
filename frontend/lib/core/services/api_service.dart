import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Standalone Offline-First Service
/// هەموو داتاکان بە تەواوی لەسەر فرۆنت ئێند و مۆبایلەکە بە شێوەی خۆماڵی (Local) هەڵدەگیرێن
/// بەبێ پێویستی بە هیچ سێرڤەر و باکێند و ئینتەرنێتێک.
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // --- Auth / Member Session ---

  Future<Map<String, dynamic>> loginOrRegister({
    required String name,
    required String phone,
    String? adminPin,
  }) async {
    // ئەگەر پینی ئەدمین نووسرابێت (1234 یان admin یان 0000)
    final bool isAdmin = adminPin != null &&
        adminPin.isNotEmpty &&
        (adminPin == '1234' || adminPin == 'admin' || adminPin == '0000' || adminPin == '1111');

    final prefs = await SharedPreferences.getInstance();

    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final barcodeId = cleanPhone.isNotEmpty ? cleanPhone : '7701234567';

    final member = {
      'id': DateTime.now().millisecondsSinceEpoch % 100000,
      'name': name.trim(),
      'phone': phone.trim(),
      'barcode': 'GYM-$barcodeId',
      'status': 'active',
      'subscription_plan': isAdmin ? 'بەڕێوەبەری سەرەکی' : 'ئەندامێتی مانگانە VIP',
      'remaining_days': 30,
      'join_date': '2026-10-01',
      'expire_date': '2026-11-01',
      'is_admin': isAdmin,
    };

    await prefs.setString('member_token', 'local_jwt_token_${member['id']}');
    await prefs.setString('member_data', jsonEncode(member));
    await prefs.setBool('is_admin', isAdmin);

    // ئەندامەکە دەخەینە ناو لیستی ئەندامە لۆکاڵییەکانیش ئەگەر نەبوو
    final members = await _loadList('local_members', _defaultMembers);
    final existingIndex = members.indexWhere((m) => m['phone'] == phone.trim());
    if (existingIndex >= 0) {
      members[existingIndex] = member;
    } else {
      members.insert(0, member);
    }
    await _saveList('local_members', members);

    return {
      'status': true,
      'is_admin': isAdmin,
      'member': member,
      'token': 'local_jwt_token_${member['id']}',
      'message': 'بە سەرکەوتوویی چوویتە ژوورەوە',
    };
  }

  Future<Map<String, dynamic>?> getSavedMember() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('member_data');
    if (jsonStr == null) return null;
    try {
      return jsonDecode(jsonStr);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_admin') ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('member_token');
    await prefs.remove('member_data');
    await prefs.remove('is_admin');
  }

  // --- Gym Features ---

  Future<List<dynamic>> getSubscriptionPlans() async {
    return _loadList('local_plans', _defaultPlans);
  }

  Future<Map<String, dynamic>> getWorkouts({int? memberId}) async {
    final workouts = await _loadList('local_workouts', _defaultWorkouts);
    return {'status': true, 'workouts': workouts};
  }

  Future<List<dynamic>> getLeaderboard() async {
    final members = await _loadList('local_members', _defaultMembers);
    // Sort or return mock ranked leaderboard
    return members.take(10).toList();
  }

  Future<List<dynamic>> getBanners() async {
    return _loadList('local_banners', _defaultBanners);
  }

  // --- Admin API Management (100% Local Storage) ---

  Future<Map<String, dynamic>> getAdminStats() async {
    final members = await _loadList('local_members', _defaultMembers);
    final workouts = await _loadList('local_workouts', _defaultWorkouts);
    final trainers = await _loadList('local_trainers', _defaultTrainers);
    final reels = await _loadList('local_reels', _defaultReels);
    final plans = await _loadList('local_plans', _defaultPlans);

    final activeCount = members.where((m) => m['status'] == 'active').length;
    final expiredCount = members.where((m) => m['status'] == 'expired').length;

    final stats = {
      'total_members': members.length,
      'active_members': activeCount,
      'expired_members': expiredCount,
      'total_workouts': workouts.length,
      'total_trainers': trainers.length,
      'total_reels': reels.length,
      'total_plans': plans.length,
      'monthly_revenue': '1,850,000 د.ع',
      'daily_attendance': 46,
    };

    return {
      'status': true,
      'stats': stats,
      ...stats,
    };
  }

  // Members Management
  Future<List<dynamic>> getAdminMembers({String? search}) async {
    final members = await _loadList('local_members', _defaultMembers);
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      return members.where((m) {
        final name = (m['name'] ?? '').toString().toLowerCase();
        final phone = (m['phone'] ?? '').toString().toLowerCase();
        final barcode = (m['barcode'] ?? '').toString().toLowerCase();
        return name.contains(q) || phone.contains(q) || barcode.contains(q);
      }).toList();
    }
    return members;
  }

  Future<Map<String, dynamic>> saveMember(Map<String, dynamic> data) async {
    final members = await _loadList('local_members', _defaultMembers);
    final id = data['id'];

    if (id != null) {
      final idx = members.indexWhere((m) => m['id'] == id);
      if (idx >= 0) {
        members[idx] = {...members[idx], ...data};
      } else {
        members.add(data);
      }
    } else {
      final newMember = {
        ...data,
        'id': DateTime.now().millisecondsSinceEpoch % 100000,
        'barcode': data['barcode'] ?? 'GYM-${DateTime.now().millisecondsSinceEpoch % 10000}',
        'status': data['status'] ?? 'active',
        'remaining_days': data['remaining_days'] ?? 30,
      };
      members.insert(0, newMember);
    }

    await _saveList('local_members', members);
    return {'status': true, 'message': 'ئەندام بە سەرکەوتوویی پاشەکەوت کرا'};
  }

  Future<Map<String, dynamic>> deleteMember(int id) async {
    final members = await _loadList('local_members', _defaultMembers);
    members.removeWhere((m) => m['id'] == id);
    await _saveList('local_members', members);
    return {'status': true, 'message': 'ئەندام بە سەرکەوتوویی سڕایەوە'};
  }

  Future<Map<String, dynamic>> renewMemberSubscription(int memberId, int planId) async {
    final members = await _loadList('local_members', _defaultMembers);
    final plans = await _loadList('local_plans', _defaultPlans);
    final plan = plans.firstWhere((p) => p['id'] == planId, orElse: () => null);

    final idx = members.indexWhere((m) => m['id'] == memberId);
    if (idx >= 0) {
      members[idx]['status'] = 'active';
      members[idx]['remaining_days'] = 30;
      if (plan != null) {
        members[idx]['subscription_plan'] = plan['name'];
      }
      await _saveList('local_members', members);
    }
    return {'status': true, 'message': 'ئابوونەی ئەندام نوێکرایەوە'};
  }

  // Workouts Management
  Future<List<dynamic>> getAdminWorkouts() async {
    return _loadList('local_workouts', _defaultWorkouts);
  }

  Future<Map<String, dynamic>> saveWorkout(Map<String, dynamic> data) async {
    final list = await _loadList('local_workouts', _defaultWorkouts);
    final id = data['id'];
    if (id != null) {
      final idx = list.indexWhere((w) => w['id'] == id);
      if (idx >= 0) {
        list[idx] = {...list[idx], ...data};
      } else {
        list.add(data);
      }
    } else {
      final newW = {
        ...data,
        'id': DateTime.now().millisecondsSinceEpoch % 100000,
      };
      list.insert(0, newW);
    }
    await _saveList('local_workouts', list);
    return {'status': true, 'message': 'ڕاهێنان پاشەکەوت کرا'};
  }

  Future<Map<String, dynamic>> deleteWorkout(int id) async {
    final list = await _loadList('local_workouts', _defaultWorkouts);
    list.removeWhere((w) => w['id'] == id);
    await _saveList('local_workouts', list);
    return {'status': true, 'message': 'ڕاهێنان سڕایەوە'};
  }

  // Reels Management
  Future<List<dynamic>> getAdminReels() async {
    return _loadList('local_reels', _defaultReels);
  }

  Future<Map<String, dynamic>> saveReel(Map<String, dynamic> data) async {
    final list = await _loadList('local_reels', _defaultReels);
    final id = data['id'];
    if (id != null) {
      final idx = list.indexWhere((r) => r['id'] == id);
      if (idx >= 0) {
        list[idx] = {...list[idx], ...data};
      } else {
        list.add(data);
      }
    } else {
      final newR = {
        ...data,
        'id': DateTime.now().millisecondsSinceEpoch % 100000,
      };
      list.insert(0, newR);
    }
    await _saveList('local_reels', list);
    return {'status': true, 'message': 'ڤیدیۆ پاشەکەوت کرا'};
  }

  Future<Map<String, dynamic>> deleteReel(int id) async {
    final list = await _loadList('local_reels', _defaultReels);
    list.removeWhere((r) => r['id'] == id);
    await _saveList('local_reels', list);
    return {'status': true, 'message': 'ڤیدیۆ سڕایەوە'};
  }

  // Trainers Management
  Future<List<dynamic>> getAdminTrainers() async {
    return _loadList('local_trainers', _defaultTrainers);
  }

  Future<Map<String, dynamic>> saveTrainer(Map<String, dynamic> data) async {
    final list = await _loadList('local_trainers', _defaultTrainers);
    final id = data['id'];
    if (id != null) {
      final idx = list.indexWhere((t) => t['id'] == id);
      if (idx >= 0) {
        list[idx] = {...list[idx], ...data};
      } else {
        list.add(data);
      }
    } else {
      final newT = {
        ...data,
        'id': DateTime.now().millisecondsSinceEpoch % 100000,
      };
      list.insert(0, newT);
    }
    await _saveList('local_trainers', list);
    return {'status': true, 'message': 'ڕاهێنەر پاشەکەوت کرا'};
  }

  Future<Map<String, dynamic>> deleteTrainer(int id) async {
    final list = await _loadList('local_trainers', _defaultTrainers);
    list.removeWhere((t) => t['id'] == id);
    await _saveList('local_trainers', list);
    return {'status': true, 'message': 'ڕاهێنەر سڕایەوە'};
  }

  // Plans Management
  Future<List<dynamic>> getAdminPlans() async {
    return _loadList('local_plans', _defaultPlans);
  }

  Future<Map<String, dynamic>> savePlan(Map<String, dynamic> data) async {
    final list = await _loadList('local_plans', _defaultPlans);
    final id = data['id'];
    if (id != null) {
      final idx = list.indexWhere((p) => p['id'] == id);
      if (idx >= 0) {
        list[idx] = {...list[idx], ...data};
      } else {
        list.add(data);
      }
    } else {
      final newP = {
        ...data,
        'id': DateTime.now().millisecondsSinceEpoch % 100000,
      };
      list.insert(0, newP);
    }
    await _saveList('local_plans', list);
    return {'status': true, 'message': 'پلانی ئابوونە پاشەکەوت کرا'};
  }

  Future<Map<String, dynamic>> deletePlan(int id) async {
    final list = await _loadList('local_plans', _defaultPlans);
    list.removeWhere((p) => p['id'] == id);
    await _saveList('local_plans', list);
    return {'status': true, 'message': 'پلان سڕایەوە'};
  }

  // Banners Management
  Future<List<dynamic>> getAdminBanners() async {
    return _loadList('local_banners', _defaultBanners);
  }

  Future<Map<String, dynamic>> saveBanner(Map<String, dynamic> data) async {
    final list = await _loadList('local_banners', _defaultBanners);
    final id = data['id'];
    if (id != null) {
      final idx = list.indexWhere((b) => b['id'] == id);
      if (idx >= 0) {
        list[idx] = {...list[idx], ...data};
      } else {
        list.add(data);
      }
    } else {
      final newB = {
        ...data,
        'id': DateTime.now().millisecondsSinceEpoch % 100000,
      };
      list.insert(0, newB);
    }
    await _saveList('local_banners', list);
    return {'status': true, 'message': 'بانەر پاشەکەوت کرا'};
  }

  Future<Map<String, dynamic>> deleteBanner(int id) async {
    final list = await _loadList('local_banners', _defaultBanners);
    list.removeWhere((b) => b['id'] == id);
    await _saveList('local_banners', list);
    return {'status': true, 'message': 'بانەر سڕایەوە'};
  }

  // --- Local Storage Helpers ---

  Future<List<dynamic>> _loadList(String key, List<dynamic> defaultData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(key);
    if (jsonStr == null || jsonStr.isEmpty) {
      await prefs.setString(key, jsonEncode(defaultData));
      return List<dynamic>.from(defaultData);
    }
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) return decoded;
    } catch (_) {}
    return List<dynamic>.from(defaultData);
  }

  Future<void> _saveList(String key, List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  // --- Initial Default Rich Data ---

  static final List<dynamic> _defaultPlans = [
    {
      'id': 1,
      'name': 'ئەندامێتی مانگانە - ستاندارد',
      'price': 40000,
      'duration_days': 30,
      'description': 'دەستڕاگەیشتن بە تەواوی ئامێرەکانی هۆڵ، دۆش، ڕاهێنانی گشتی',
    },
    {
      'id': 2,
      'name': 'ئەندامێتی VIP زێڕین',
      'price': 65000,
      'duration_days': 30,
      'description': 'تایبەت بە ساونا، جاکوزی، پلانی خۆراکی و ڕاهێنەری تایبەت',
    },
    {
      'id': 3,
      'name': 'ئەندامێتی ٣ مانگ',
      'price': 105000,
      'duration_days': 90,
      'description': 'داشکاندنی ١٥٪ لەگەڵ ئامۆژگاری مانگانەی تەندروستی',
    },
    {
      'id': 4,
      'name': 'ئەندامێتی ٦ مانگ پڕۆ',
      'price': 190000,
      'duration_days': 180,
      'description': 'داشکاندنی تایبەت لەگەڵ بەشداری بێبەرامبەر لە پاڵەوانێتی',
    },
  ];

  static final List<dynamic> _defaultMembers = [
    {
      'id': 101,
      'name': 'ئەحمەد فەرهاد',
      'phone': '07501234567',
      'barcode': 'GYM-07501234567',
      'status': 'active',
      'subscription_plan': 'ئەندامێتی VIP زێڕین',
      'remaining_days': 24,
      'score': 1840,
    },
    {
      'id': 102,
      'name': 'ڕێبین محەمەد',
      'phone': '07709876543',
      'barcode': 'GYM-07709876543',
      'status': 'active',
      'subscription_plan': 'ئەندامێتی مانگانە - ستاندارد',
      'remaining_days': 16,
      'score': 1520,
    },
    {
      'id': 103,
      'name': 'سۆران عەلی',
      'phone': '07512348765',
      'barcode': 'GYM-07512348765',
      'status': 'active',
      'subscription_plan': 'ئەندامێتی ٣ مانگ',
      'remaining_days': 72,
      'score': 1290,
    },
    {
      'id': 104,
      'name': 'کاروان حسێن',
      'phone': '07715678901',
      'barcode': 'GYM-07715678901',
      'status': 'expired',
      'subscription_plan': 'ئەندامێتی مانگانە - ستاندارد',
      'remaining_days': 0,
      'score': 950,
    },
  ];

  static final List<dynamic> _defaultWorkouts = [
    {
      'id': 1,
      'title': 'ڕاهێنانی سینگ و باسک (Chest & Triceps)',
      'description': 'پڕۆگرامی چڕ بۆ بنیاتنانی ماسوولکەکانی سینگ و پشتەوەی قۆڵ',
      'level': 'پێشکەوتوو',
      'duration_minutes': 60,
      'exercises_count': 6,
    },
    {
      'id': 2,
      'title': 'ڕاهێنانی پشت و قۆڵ (Back & Biceps)',
      'description': 'بەهێزکردنی پەیکەری پشت و لاتیماس و ماسوولکەی پێشەوەی دەست',
      'level': 'ناوەند',
      'duration_minutes': 55,
      'exercises_count': 7,
    },
    {
      'id': 3,
      'title': 'ڕۆژی قاچ و سک (Legs & Core Power)',
      'description': 'سکوات، هاک سکوات، و وەرزشی پتەوکردنی کەمەر و بەشی ناوەند',
      'level': 'هەموو ئاستەکان',
      'duration_minutes': 50,
      'exercises_count': 5,
    },
    {
      'id': 4,
      'title': 'شاندەر و تەڵاقی (Shoulders & Traps)',
      'description': 'فشاری سەروو سەر، دانسانی شانەکان بۆ شێوەی V-Taper نموونەیی',
      'level': 'پێشکەوتوو',
      'duration_minutes': 45,
      'exercises_count': 6,
    },
  ];

  static final List<dynamic> _defaultTrainers = [
    {
      'id': 1,
      'name': 'کاپتن بیلال کەریم',
      'specialty': 'ڕاهێنەری سەرەکی لەشجوانی و فیزیك',
      'phone': '07504443322',
      'experience_years': 9,
      'active_clients': 38,
    },
    {
      'id': 2,
      'name': 'ڕاهێنەر دارا عومەر',
      'specialty': 'پسپۆڕی کێش دابەزاندن و کاردیۆ چڕ',
      'phone': '07705556677',
      'experience_years': 6,
      'active_clients': 24,
    },
    {
      'id': 3,
      'name': 'ڕاهێنەر هێمن عەزیز',
      'specialty': 'ڕاهێنەری هێز و بەرزکردنەوەی قورسایی',
      'phone': '07519998877',
      'experience_years': 7,
      'active_clients': 19,
    },
  ];

  static final List<dynamic> _defaultReels = [
    {
      'id': 1,
      'title': 'تەکنیکی دروستی سکوات بۆ پاراستنی چۆک',
      'trainer': 'کاپتن بیلال',
      'likes': 428,
      'video_url': 'assets/videos/workout_1.mp4',
    },
    {
      'id': 2,
      'title': '٥ هەڵەی باو لە کاتی بەرزکردنەوەی بەرمیلەی سینگ',
      'trainer': 'ڕاهێنەر هێمن',
      'likes': 612,
      'video_url': 'assets/videos/workout_2.mp4',
    },
    {
      'id': 3,
      'title': 'ڕێنمایی گرنگ بۆ دەستپێکەران لە هۆڵی وەرزش',
      'trainer': 'کاپتن بیلال',
      'likes': 389,
      'video_url': 'assets/videos/workout_3.mp4',
    },
  ];

  static final List<dynamic> _defaultBanners = [
    {
      'id': 1,
      'title': 'داشکاندنی وەرزی پاییزی هۆڵی بیلال',
      'subtitle': 'بەشداری ٣ مانگ بکە و مانگێک دیاری وەربگرە',
      'image_url': 'assets/images/banner_autumn.jpg',
      'link': 'plans',
    },
    {
      'id': 2,
      'title': 'کۆرسە نوێیەکانی ڕاهێنانی تایبەتی VIP',
      'subtitle': 'لەگەڵ باشترین شارەزایانی لەشجوانی کوردستان',
      'image_url': 'assets/images/banner_vip.jpg',
      'link': 'trainers',
    },
  ];
}
