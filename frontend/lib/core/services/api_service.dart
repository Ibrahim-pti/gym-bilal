import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static String get defaultBaseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api/v1';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000/api/v1';
    return 'http://127.0.0.1:8000/api/v1';
  }

  String _baseUrl = defaultBaseUrl;
  String get baseUrl => _baseUrl;

  void setCustomBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? '${url}api/v1' : '$url/api/v1';
  }

  // --- Auth / Member ---

  Future<Map<String, dynamic>> loginOrRegister({
    required String name,
    required String phone,
    String? adminPin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/member/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'name': name.trim(),
          'phone': phone.trim(),
          if (adminPin != null && adminPin.isNotEmpty) 'admin_pin': adminPin.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        if (data['token'] != null) {
          await prefs.setString('member_token', data['token']);
        }
        await prefs.setString('member_data', jsonEncode(data['member']));
        await prefs.setBool('is_admin', data['is_admin'] == true);
        return data;
      } else {
        return {'status': false, 'message': data['message'] ?? 'هەڵەیەک ڕوویدا'};
      }
    } catch (e) {
      return {'status': false, 'message': 'پەیوەندی بە سێرڤەر نەکرا: $e'};
    }
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
    try {
      final res = await http.get(Uri.parse('$_baseUrl/plans'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['plans'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> getWorkouts({int? memberId}) async {
    try {
      final query = memberId != null ? '?member_id=$memberId' : '';
      final res = await http.get(Uri.parse('$_baseUrl/workouts$query'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (_) {}
    return {'status': false, 'workouts': []};
  }

  Future<List<dynamic>> getLeaderboard() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/leaderboard'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['leaderboard'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  // --- Admin API Management ---

  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/admin/dashboard-stats'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (_) {}
    return {'status': false};
  }

  // Members
  Future<List<dynamic>> getAdminMembers({String? search}) async {
    try {
      final q = search != null && search.isNotEmpty ? '?search=$search' : '';
      final res = await http.get(Uri.parse('$_baseUrl/admin/members$q'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['members'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> saveMember(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/admin/members/save'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> deleteMember(int id) async {
    try {
      final res = await http.delete(Uri.parse('$_baseUrl/admin/members/$id'));
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> renewMemberSubscription(int memberId, int planId) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/admin/renew-subscription'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'member_id': memberId, 'plan_id': planId}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  // Workouts
  Future<List<dynamic>> getAdminWorkouts() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/admin/workouts'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['workouts'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> saveWorkout(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/admin/workouts/save'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> deleteWorkout(int id) async {
    try {
      final res = await http.delete(Uri.parse('$_baseUrl/admin/workouts/$id'));
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  // Reels
  Future<List<dynamic>> getAdminReels() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/admin/reels'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['reels'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> saveReel(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/admin/reels/save'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> deleteReel(int id) async {
    try {
      final res = await http.delete(Uri.parse('$_baseUrl/admin/reels/$id'));
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  // Trainers
  Future<List<dynamic>> getAdminTrainers() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/admin/trainers'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['trainers'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> saveTrainer(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/admin/trainers/save'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> deleteTrainer(int id) async {
    try {
      final res = await http.delete(Uri.parse('$_baseUrl/admin/trainers/$id'));
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  // Plans & Pricing
  Future<List<dynamic>> getAdminPlans() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/admin/plans'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['plans'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> savePlan(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/admin/plans/save'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> deletePlan(int id) async {
    try {
      final res = await http.delete(Uri.parse('$_baseUrl/admin/plans/$id'));
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  // Banners / Carousel
  Future<List<dynamic>> getBanners() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/banners'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['banners'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<List<dynamic>> getAdminBanners() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/admin/banners'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['banners'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> saveBanner(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/admin/banners/save'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> deleteBanner(int id) async {
    try {
      final res = await http.delete(Uri.parse('$_baseUrl/admin/banners/$id'));
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': '$e'};
    }
  }
}
