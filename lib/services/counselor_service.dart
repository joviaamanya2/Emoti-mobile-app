import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CounselorService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api';
    }
  }

  static final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> getAssignedCounselor() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(CounselorService.baseUrl + '/counselors/user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? data;
      }
      return null;
    } catch (e) {
      debugPrint('getAssignedCounselor error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> requestCounselor(String notes) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final response = await http.post(
        Uri.parse(CounselorService.baseUrl + '/counselors/request'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'notes': notes}),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': data['message'] ?? 'Request sent',
        'data': data,
      };
    } catch (e) {
      debugPrint('requestCounselor error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }
}

