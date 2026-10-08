import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Standalone Offline-First Service
/// هەموو داتاکان بە تەواوی لەسەر فرۆنت ئێند و مۆبایلەکە بە شێوەی خۆماڵی (Local) هەڵدەگیرێن
/// بەبێ پێویستی بە هیچ سێرڤەر و باکێندێک.
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // --- Auth / Member Session ---

  Future<Map<String, dynamic>> loginOrRegister({
    required String name,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final barcodeId = cleanPhone.isNotEmpty ? cleanPhone : '7701234567';

    final member = {
      'id': DateTime.now().millisecondsSinceEpoch % 100000,
      'name': name.trim(),
      'phone': phone.trim(),
      'barcode': 'GYM-$barcodeId',
      'status': 'active',
      'subscription_plan': 'ئەندامێتی مانگانە VIP',
      'remaining_days': 30,
      'join_date': '2026-10-01',
      'expire_date': '2026-11-01',
    };

    await prefs.setString('member_token', 'local_jwt_token_${member['id']}');
    await prefs.setString('member_data', jsonEncode(member));

    return {
      'status': true,
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('member_token');
    await prefs.remove('member_data');
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
    return _defaultMembers;
  }

  Future<List<dynamic>> getBanners() async {
    return _loadList('local_banners', _defaultBanners);
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
