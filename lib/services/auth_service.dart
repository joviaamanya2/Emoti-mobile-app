import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;

class AuthService {
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

  // ──────────────────────────────────────────────
  //  🔒 ROLE & AUTH HELPERS
  // ──────────────────────────────────────────────

  Future<void> saveUserRole(String role) async {
    await storage.write(key: 'user_role', value: role);
  }

  Future<String> getUserRole() async {
    return await storage.read(key: 'user_role') ?? 'patient';
  }

  Future<void> saveUserName(String name) async {
    await storage.write(key: 'user_name', value: name);
  }

  Future<String> getUserName() async {
    return await storage.read(key: 'user_name') ?? '';
  }

  Future<void> saveUserEmail(String email) async {
    await storage.write(key: 'user_email', value: email);
  }

  Future<String> getUserEmail() async {
    return await storage.read(key: 'user_email') ?? '';
  }

  Future<void> saveUserId(String id) async {
    await storage.write(key: 'user_id', value: id);
  }

  Future<String> getUserId() async {
    return await storage.read(key: 'user_id') ?? '';
  }

  Future<bool> isCounselor() async => (await getUserRole()).toLowerCase() == 'counselor';
  Future<bool> isPatient() async => (await getUserRole()).toLowerCase() == 'patient';
  Future<bool> isAdmin() async => (await getUserRole()).toLowerCase() == 'admin';

  Future<void> clearAuthData() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'user_role');
    await storage.delete(key: 'user_name');
    await storage.delete(key: 'user_email');
    await storage.delete(key: 'user_id');
  }

  // 🔒 HELPER: Try every possible key name for the role field
  String? _extractRole(Map<String, dynamic> data) {
    // Check all common key names your backend might use
    for (final key in [
      'role',
      'user_role',
      'userRole',
      'type',
      'user_type',
      'userType',
      'account_type',
      'accountType',
    ]) {
      final value = data[key];
      if (value != null && value.toString().isNotEmpty) {
        print('🔑 Found role in key "$key" = "${value.toString()}"');
        return value.toString();
      }
    }
    return null;
  }

  // ──────────────────────────────────────────────
  //  AUTH ENDPOINTS
  // ──────────────────────────────────────────────

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

        // 🔒 SECURITY: Aggressively find and save the role
        final userData = decoded['user'] ?? decoded['data'] ?? decoded;

        final role = _extractRole(userData) ?? _extractRole(decoded) ?? '';
        if (role.isNotEmpty) {
          await saveUserRole(role);
          print('🔑 LOGIN: Saved role = "$role"');
        }

        final name = userData['name']?.toString() ?? decoded['name']?.toString() ?? '';
        final email = userData['email']?.toString() ?? decoded['email']?.toString() ?? '';
        final id = userData['id']?.toString() ?? decoded['id']?.toString() ?? '';

        if (name.isNotEmpty) await saveUserName(name);
        if (email.isNotEmpty) await saveUserEmail(email);
        if (id.isNotEmpty) await saveUserId(id);

        print('🔑 LOGIN: Final saved role = "${await getUserRole()}"');
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

      // 🔒 SECURITY: Save role from response OR from the registration data
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = decoded['user'] ?? decoded['data'] ?? decoded;

        // Try to extract role from the API response first
        final role = _extractRole(userData) ?? _extractRole(decoded) ?? '';
        if (role.isNotEmpty) {
          await saveUserRole(role);
          print('🔑 REGISTER: Saved role from response = "$role"');
        } else {
          // Fallback: use the role from the registration form data
          final dataRole = data['role']?.toString() ??
              data['user_type']?.toString() ??
              data['type']?.toString() ??
              '';
          if (dataRole.isNotEmpty) {
            await saveUserRole(dataRole);
            print('🔑 REGISTER: Saved role from request data = "$dataRole"');
          }
        }

        // Save name, email, id from response or request
        final name = userData['name']?.toString() ?? data['name']?.toString() ?? '';
        final email = userData['email']?.toString() ?? data['email']?.toString() ?? '';
        final id = userData['id']?.toString() ?? '';

        if (name.isNotEmpty) await saveUserName(name);
        if (email.isNotEmpty) await saveUserEmail(email);
        if (id.isNotEmpty) await saveUserId(id);

        // If registration also returns a token (auto-login), save it
        if (decoded['token'] != null) {
          await storage.write(key: 'token', value: decoded['token']);
        }

        print('🔑 REGISTER: Final saved role = "${await getUserRole()}"');
      }

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

      if (response.statusCode == 200) {
        // 🔒 SECURITY: Update persisted role from latest user data
        final userData = decoded['user'] ?? decoded['data'] ?? decoded;

        final role = _extractRole(userData) ?? _extractRole(decoded) ?? '';
        if (role.isNotEmpty) {
          await saveUserRole(role);
          print('🔑 GET USER: Updated role = "$role"');
        }

        if (userData['name'] != null) await saveUserName(userData['name'].toString());
        if (userData['email'] != null) await saveUserEmail(userData['email'].toString());
        if (userData['id'] != null) await saveUserId(userData['id'].toString());

        print('🔑 GET USER: Final saved role = "${await getUserRole()}"');
      }

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
        'data': decoded,
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
      await clearAuthData();
    } catch (e) {
      await clearAuthData();
    }
  }

  // ──────────────────────────────────────────────
  //  🔒 COUNSELOR ENDPOINTS
  // ──────────────────────────────────────────────

  // ---------------- FETCH COUNSELORS ----------------
  Future<List<dynamic>> fetchCounselors() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      print("➡️ FETCH COUNSELORS URL: $baseUrl/counselors");

      final response = await http.get(
        Uri.parse('$baseUrl/counselors'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("⬅️ COUNSELORS STATUS: ${response.statusCode}");

      final decoded = _safeJson(response.body);

      if (response.statusCode == 200) {
        return decoded['data'] ?? decoded is List ? decoded : [];
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch counselors');
      }
    } catch (e) {
      print("❌ FetchCounselors Error: $e");
      rethrow;
    }
  }

  // ---------------- FETCH COUNSELOR APPOINTMENTS ----------------
  Future<List<dynamic>> fetchCounselorAppointments() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      final role = await getUserRole();
      if (role.toLowerCase() != 'counselor' && role.toLowerCase() != 'admin') {
        throw Exception('Unauthorized: Only counselors can view counselor appointments');
      }

      print("➡️ FETCH COUNSELOR APPOINTMENTS URL: $baseUrl/counselor/appointments");

      final response = await http.get(
        Uri.parse('$baseUrl/counselor/appointments'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("⬅️ COUNSELOR APPOINTMENTS STATUS: ${response.statusCode}");

      final decoded = _safeJson(response.body);

      if (response.statusCode == 200) {
        return decoded['data'] ?? decoded is List ? decoded : [];
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You do not have counselor privileges');
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch counselor appointments');
      }
    } catch (e) {
      print("❌ FetchCounselorAppointments Error: $e");
      rethrow;
    }
  }

  // ---------------- FETCH USER APPOINTMENTS ----------------
  Future<List<dynamic>> fetchUserAppointments() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      print("➡️ FETCH USER APPOINTMENTS URL: $baseUrl/appointments");

      final response = await http.get(
        Uri.parse('$baseUrl/appointments'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("⬅️ USER APPOINTMENTS STATUS: ${response.statusCode}");

      final decoded = _safeJson(response.body);

      if (response.statusCode == 200) {
        return decoded['data'] ?? decoded is List ? decoded : [];
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch your appointments');
      }
    } catch (e) {
      print("❌ FetchUserAppointments Error: $e");
      rethrow;
    }
  }

  // ---------------- BOOK APPOINTMENT ----------------
  Future<bool> bookAppointment({
    required int counselorId,
    required String contactNumber,
    required String email,
    required String address,
    required String notes,
    required String service,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      final body = {
        'counselor_id': counselorId,
        'contact_number': contactNumber,
        'email': email,
        'address': address,
        'notes': notes,
        'service': service,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
      };

      print("➡️ BOOK APPOINTMENT URL: $baseUrl/appointments");
      print("➡️ BODY: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("⬅️ BOOK APPOINTMENT STATUS: ${response.statusCode}");
      print("⬅️ BODY: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        final decoded = _safeJson(response.body);
        throw Exception(decoded['message'] ?? 'Failed to book appointment');
      }
    } catch (e) {
      print("❌ BookAppointment Error: $e");
      rethrow;
    }
  }

  // ---------------- UPDATE APPOINTMENT STATUS ----------------
  Future<bool> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      final role = await getUserRole();
      if (role.toLowerCase() != 'counselor' && role.toLowerCase() != 'admin') {
        throw Exception('Unauthorized: Only counselors can update appointment status');
      }

      final body = {'status': status};

      print("➡️ UPDATE APPOINTMENT URL: $baseUrl/appointments/$appointmentId/status");
      print("➡️ BODY: ${jsonEncode(body)}");

      final response = await http.put(
        Uri.parse('$baseUrl/appointments/$appointmentId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("⬅️ UPDATE APPOINTMENT STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You do not have permission to update this appointment');
      } else {
        final decoded = _safeJson(response.body);
        throw Exception(decoded['message'] ?? 'Failed to update appointment');
      }
    } catch (e) {
      print("❌ UpdateAppointmentStatus Error: $e");
      rethrow;
    }
  }

  // ---------------- SUBMIT COUNSELOR SESSION LOG ----------------
  Future<bool> submitCounselorSessionLog({
    required String counselorName,
    required String counselorEmail,
    required String counselorContact,
    required String clientName,
    required String specification,
    required String sessionNotes,
    required File screenshotFile,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      final role = await getUserRole();
      if (role.toLowerCase() != 'counselor' && role.toLowerCase() != 'admin') {
        throw Exception('Unauthorized: Only counselors can submit session logs');
      }

      final uri = Uri.parse('$baseUrl/counselor/session-logs');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['counselor_name'] = counselorName;
      request.fields['counselor_email'] = counselorEmail;
      request.fields['counselor_contact'] = counselorContact;
      request.fields['client_name'] = clientName;
      request.fields['specification'] = specification;
      request.fields['session_notes'] = sessionNotes;

      final extension = path.extension(screenshotFile.path).toLowerCase();
      String mimeType = 'image/jpeg';
      if (extension == '.png') {
        mimeType = 'image/png';
      } else if (extension == '.webp') {
        mimeType = 'image/webp';
      } else if (extension == '.heic') {
        mimeType = 'image/heic';
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'screenshot',
          screenshotFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      print("➡️ SUBMIT SESSION LOG URL: $baseUrl/counselor/session-logs");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("⬅️ SESSION LOG STATUS: ${response.statusCode}");
      print("⬅️ BODY: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You do not have counselor privileges');
      } else {
        final decoded = _safeJson(response.body);
        throw Exception(decoded['message'] ?? 'Failed to submit session log');
      }
    } catch (e) {
      print("❌ SubmitCounselorSessionLog Error: $e");
      rethrow;
    }
  }

  // ---------------- FETCH COUNSELOR SESSION LOGS ----------------
  Future<List<dynamic>> fetchCounselorSessionLogs() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Not logged in');

      final role = await getUserRole();
      if (role.toLowerCase() != 'counselor' && role.toLowerCase() != 'admin') {
        throw Exception('Unauthorized: Only counselors can view session logs');
      }

      print("➡️ FETCH SESSION LOGS URL: $baseUrl/counselor/session-logs");

      final response = await http.get(
        Uri.parse('$baseUrl/counselor/session-logs'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("⬅️ SESSION LOGS STATUS: ${response.statusCode}");

      final decoded = _safeJson(response.body);

      if (response.statusCode == 200) {
        return decoded['data'] ?? decoded is List ? decoded : [];
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You do not have counselor privileges');
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch session logs');
      }
    } catch (e) {
      print("❌ FetchCounselorSessionLogs Error: $e");
      rethrow;
    }
  }
}