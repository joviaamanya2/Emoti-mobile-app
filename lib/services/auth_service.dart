import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // FIX 1: Change Port from 18000 to 8000
  // FIX 2: Use '10.0.2.2' for Mobile/Emulator. Use '127.0.0.1' only for Web/Chrome.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api'; 
    } else {
      // This is for Android Emulator or iPhone Simulator
      return 'http://10.0.2.2:8000/api'; 
    }
  }
  
  static final storage = FlutterSecureStorage();

  // Helper method to handle errors consistently
  Map<String, dynamic> _handleError(dynamic e) {
    print("API Error: $e");
    return {
      'statusCode': 500,
      'message': 'Failed to fetch data. Is the server running on 127.0.0.1:8000?',
      'data': null,
    };
  }

  // ---------------- LOGIN ----------------
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    try {
      print("Attempting login to: $baseUrl/auth/login"); // Debug print
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['token'] != null) {
        await storage.write(key: 'token', value: decoded['token']);
      }

      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Login response received',
        'data': decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- REGISTER ----------------
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      print("Attempting register to: $baseUrl/auth/register"); // Debug print

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      final decoded = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Register response received',
        'data': decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- FORGOT PASSWORD ----------------
  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Reset link sent.',
        'data': decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- VERIFY OTP ----------------
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Code verified.',
        'data': decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- RESET PASSWORD ----------------
  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Password reset successful.',
        'data': decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- GET USER ----------------
  Future<Map<String, dynamic>> getUser() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('User not logged in');

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['user'] ?? data;
      } else {
        throw Exception('Failed to fetch user');
      }
    } catch (e) {
      print("GetUser Error: $e");
      rethrow;
    }
  }

  // ---------------- GET JOURNALS ----------------
  Future<List<dynamic>> getJournals() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('User not logged in');

      final response = await http.get(
        Uri.parse('$baseUrl/journals'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? data;
      } else {
        throw Exception('Failed to fetch journals');
      }
    } catch (e) {
      print("GetJournals Error: $e");
      rethrow;
    }
  }
}