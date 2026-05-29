import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // ---------------- BASE URL ----------------
  static String get baseUrl {
    const apiBase = 'http://127.0.0.1:8001/api';
    return apiBase;
  }

  static final storage = const FlutterSecureStorage();

  // ---------------- SAFE JSON PARSER ----------------
  dynamic _safeJson(String body) {
    try {
      return body.isNotEmpty ? jsonDecode(body) : {};
    } catch (e) {
      print("❌ JSON PARSE ERROR: $e");
      print("RAW BODY: $body");
      return {"raw": body};
    }
  }

  // ---------------- ERROR HANDLER ----------------
  Map<String, dynamic> _handleError(dynamic e) {
    print("❌ API ERROR: $e");
    return {
      'statusCode': 500,
      'message': e.toString(),
      'data': null,
    };
  }

  // ---------------- LOGIN ----------------
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    try {
      final url = '$baseUrl/auth/login';
      print("➡️ LOGIN URL: $url");
      print("➡️ REQUEST: ${jsonEncode(data)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print("⬅️ STATUS: ${response.statusCode}");
      print("⬅️ BODY: ${response.body}");

      final decoded = _safeJson(response.body);

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
      final url = '$baseUrl/auth/register';

      print("➡️ REGISTER URL: $url");
      print("➡️ REQUEST: ${jsonEncode(data)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print("⬅️ STATUS: ${response.statusCode}");
      print("⬅️ BODY: ${response.body}");

      final decoded = _safeJson(response.body);

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
  // Sends a 6-digit verification code to the user's email
  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print("⬅️ FORGOT PASSWORD STATUS: ${response.statusCode}");
      print("⬅️ FORGOT PASSWORD BODY: ${response.body}");

      final decoded = _safeJson(response.body);

      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Verification code sent.',
        'data': decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- SEND VERIFICATION CODE ----------------
  // Alias that calls the same forgot-password endpoint
  // Used by the verification code flow
  Future<Map<String, dynamic>> sendVerificationCode(Map<String, dynamic> data) async {
    return await forgotPassword(data);
  }

  // ---------------- VERIFY OTP ----------------
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print("⬅️ VERIFY OTP STATUS: ${response.statusCode}");
      print("⬅️ VERIFY OTP BODY: ${response.body}");

      final decoded = _safeJson(response.body);

      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Code verified.',
        'data': decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- VERIFY CODE ----------------
  // Alias that calls the same verify-otp endpoint
  // Used by the verification code screen
  Future<Map<String, dynamic>> verifyCode(Map<String, dynamic> data) async {
    return await verifyOtp(data);
  }

  // ---------------- RESET PASSWORD ----------------
  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print("⬅️ RESET PASSWORD STATUS: ${response.statusCode}");
      print("⬅️ RESET PASSWORD BODY: ${response.body}");

      final decoded = _safeJson(response.body);

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

      if (token == null) {
        throw Exception('User not logged in');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("⬅️ USER STATUS: ${response.statusCode}");
      print("⬅️ USER BODY: ${response.body}");

      final decoded = _safeJson(response.body);

      return decoded;
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- GET JOURNALS ----------------
  Future<List<dynamic>> getJournals() async {
    try {
      final token = await storage.read(key: 'token');

      if (token == null) {
        throw Exception('User not logged in');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/journals'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("⬅️ JOURNALS STATUS: ${response.statusCode}");
      print("⬅️ JOURNALS BODY: ${response.body}");

      final decoded = _safeJson(response.body);

      return decoded['data'] ?? decoded;
    } catch (e) {
      print("❌ GetJournals Error: $e");
      rethrow;
    }
  }
    // ---------------- UPDATE PROFILE ----------------
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      final response = await http.put(
        Uri.parse('$baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      final decoded = _safeJson(response.body);

      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Profile updated.',
        'data': decoded['data'] ?? decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- CHANGE PASSWORD ----------------
  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> data) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      final response = await http.put(
        Uri.parse('$baseUrl/user/password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      final decoded = _safeJson(response.body);

      return {
        'statusCode': response.statusCode,
        'message': decoded['message'] ?? 'Password changed.',
        'data' : decoded,
      };
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    try {
      final token = await storage.read(key: 'token');
      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
      await storage.delete(key: 'token');
    } catch (e) {
      // Still delete local token even if API call fails
      await storage.delete(key: 'token');
    }
  }

}