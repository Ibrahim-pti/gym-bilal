import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Determine local API host
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

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('member_token');
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

  Future<Map<String, dynamic>> getDietPlans({int? memberId}) async {
    try {
      final query = memberId != null ? '?member_id=$memberId' : '';
      final res = await http.get(Uri.parse('$_baseUrl/diet-plans$query'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (_) {}
    return {'status': false, 'diet_plans': []};
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

  // --- Admin API ---

  Future<Map<String, dynamic>> scanAttendance(String barcode) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/admin/scan-attendance'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'barcode': barcode}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'status': false, 'message': 'هەڵە لە پەیوەندی بە سێرڤەر: $e'};
    }
  }

  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/admin/dashboard-stats'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (_) {}
    return {'status': false};
  }

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
}
