import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  static const String baseUrl = 'http://127.0.0.1:8001/api';

  // ==============================
  // TOKEN HANDLING
  // ==============================
  Future<String?> _getToken() async {
    return storage.read(key: 'token');
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> clearToken() async {
    await storage.delete(key: 'token');
  }

  // ==============================
  // HEADERS
  // ==============================
  Future<Map<String, String>> _authHeaders({
    bool jsonType = true,
  }) async {
    final token = await _getToken();

    return {
      if (jsonType) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  dynamic _safeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  // ==============================
  // COUNSELORS
  // ==============================
  Future<List<dynamic>> fetchCounselors() async {
    final res = await http.get(
      Uri.parse('$baseUrl/counselors'),
      headers: await _authHeaders(),
    );

    if (res.statusCode == 200) {
      final data = _safeJson(res.body);

      if (data is Map && data['data'] != null) {
        return data['data'];
      }

      if (data is List) {
        return data;
      }
    }

    throw Exception('Failed to load counselors');
  }

  // ==============================
  // USER APPOINTMENTS
  // ==============================
  Future<List<dynamic>> fetchUserAppointments() async {
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Not logged in');
      }

      final res = await http.get(
        Uri.parse('$baseUrl/appointments/user'),
        headers: await _authHeaders(),
      );

      print("⬅️ USER APPOINTMENTS STATUS: ${res.statusCode}");

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final list = decoded['data'];

        if (list is List) {
          return list;
        }
      }

      throw Exception('Failed to load user appointments');
    } catch (e) {
      throw Exception('Failed to load user appointments: $e');
    }
  }

  // ==============================
  // COUNSELOR APPOINTMENTS
  // ==============================
  Future<List<dynamic>> fetchCounselorAppointments() async {
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Not logged in');
      }

      final res = await http.get(
        Uri.parse('$baseUrl/appointments/counselor'),
        headers: await _authHeaders(),
      );

      print("⬅️ COUNSELOR APPOINTMENTS STATUS: ${res.statusCode}");

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final list = decoded['data'];

        if (list is List) {
          return list;
        }
      }

      throw Exception('Failed to load counselor appointments');
    } catch (e) {
      throw Exception('Failed to load counselor appointments: $e');
    }
  }

  // ==============================
  // UPDATE APPOINTMENT STATUS
  // ==============================
  Future<bool> updateAppointmentStatus(
    String appointmentId,
    String status,
  ) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return false;
      }

      final res = await http.put(
        Uri.parse('$baseUrl/appointments/$appointmentId'),
        headers: await _authHeaders(),
        body: jsonEncode({
          'status': status,
        }),
      );

      print("⬅️ UPDATE STATUS STATUS: ${res.statusCode}");
      print("⬅️ UPDATE STATUS BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (e) {
      print("❌ UPDATE STATUS ERROR: $e");
      return false;
    }
  }

  // ==============================
  // SESSION LOG
  // ==============================
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
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/counselor/session-log'),
      );

      request.fields.addAll({
        'counselor_name': counselorName,
        'counselor_email': counselorEmail,
        'counselor_contact': counselorContact,
        'client_name': clientName,
        'specification': specification,
        'session_notes': sessionNotes,
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'screenshot',
          screenshotFile.path,
        ),
      );

      request.headers.addAll(
        await _authHeaders(jsonType: false),
      );

      final response = await request.send();

      print("⬅️ SESSION LOG STATUS: ${response.statusCode}");

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      print("❌ SESSION LOG ERROR: $e");
      return false;
    }
  }

  // ==============================
  // BOOK APPOINTMENT  ✅ FIXED
  // ==============================
  Future<bool> bookAppointment({
    required int counselorId,
    required String contactNumber,
    String? email,
    required String address,
    String? notes,
    required String service,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return false;
      }

      final body = <String, dynamic>{};

      // ✅ REQUIRED FIELDS
      body['counselor_id'] = counselorId;
      body['service'] = service;
      body['patient_phone'] = contactNumber.toString();
      body['contact_number'] = contactNumber.toString(); // ✅ THIS WAS MISSING
      body['appointment_date'] = appointmentDate;
      body['appointment_time'] = appointmentTime;

      // ✅ OPTIONAL FIELDS
      if (email != null && email.isNotEmpty) {
        body['patient_email'] = email;
      }

      if (address.isNotEmpty) {
        body['address'] = address;
      }

      if (notes != null && notes.isNotEmpty) {
        body['notes'] = notes;
      }

      print("➡️ BOOK APPOINTMENT BODY: ${jsonEncode(body)}");

      final res = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: await _authHeaders(),
        body: jsonEncode(body),
      );

      print("⬅️ BOOK APPOINTMENT STATUS: ${res.statusCode}");
      print("⬅️ BOOK APPOINTMENT BODY: ${res.body}");

      if (res.statusCode == 201) {
        return true;
      }

      // ✅ HANDLE VALIDATION ERRORS
      if (res.statusCode == 422) {
        final decoded = jsonDecode(res.body);

        String errorMsg = 'Validation error';

        if (decoded['errors'] != null) {
          final errors = decoded['errors'];

          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;

            if (firstError is List &&
                firstError.isNotEmpty) {
              errorMsg = firstError.first.toString();
            }
          }
        } else if (decoded['message'] != null) {
          errorMsg = decoded['message'].toString();
        }

        throw Exception(errorMsg);
      }

      // ✅ HANDLE 500 ERRORS
      if (res.statusCode == 500) {
        final decoded = _safeJson(res.body);
        throw Exception(
          decoded?['message'] ?? 'Server error. Please try again.',
        );
      }

      return false;
    } catch (e) {
      print("❌ BOOK APPOINTMENT ERROR: $e");
      rethrow;
    }
  }

  // ==============================
  // MOODS
  // ==============================
  Future<bool> sendMood(
    String label,
    String emoji,
  ) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return false;
      }

      final res = await http.post(
        Uri.parse('$baseUrl/moods'),
        headers: await _authHeaders(),
        body: jsonEncode({
          'mood': label,
          'emoji': emoji,
        }),
      );

      return res.statusCode >= 200 &&
          res.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  // ==============================
// SAVE TESTIMONIAL  ✅ FIXED
// ==============================
Future<bool> saveTestimonial({
  required String mood,
  required String emoji,
  String? text,
}) async {
  try {
    final token = await _getToken();

    if (token == null) {
      throw Exception('Not logged in');
    }

    final res = await http.post(
      Uri.parse('$baseUrl/testimonials'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'mood': mood,
        'emoji': emoji,
        if (text != null && text.isNotEmpty) 'text': text,
        'star_rating': 5,
      }),
    ).timeout(const Duration(seconds: 15));

    print("⬅️ SAVE TESTIMONIAL STATUS: ${res.statusCode}");
    print("⬅️ SAVE TESTIMONIAL BODY: ${res.body}");

    if (res.statusCode == 201) {
      return true;
    }

    final decoded = _safeJson(res.body);
    throw Exception(decoded?['message'] ?? 'Failed to save testimonial');
  } catch (e) {
    print("❌ SAVE TESTIMONIAL ERROR: $e");
    rethrow;
  }
}

// ==============================
// FETCH TESTIMONIALS  ✅ FIXED
// ==============================
Future<List<Map<String, dynamic>>> fetchTestimonials({
  String? moodFilter,
}) async {
  try {
    String url = '$baseUrl/testimonials';
    if (moodFilter != null && moodFilter.isNotEmpty) {
      url += '?mood=$moodFilter';
    }

    final res = await http.get(
      Uri.parse(url),
      headers: await _authHeaders(),
    ).timeout(const Duration(seconds: 15));

    print("⬅️ FETCH TESTIMONIALS STATUS: ${res.statusCode}");

    if (res.statusCode != 200) return [];

    final decoded = _safeJson(res.body);

    if (decoded is Map<String, dynamic>) {
      final list = decoded['data'];
      if (list is List) {
        return List<Map<String, dynamic>>.from(list);
      }
    }

    if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    }

    return [];
  } catch (e) {
    print("❌ FETCH TESTIMONIALS ERROR: $e");
    return [];
  }
}
}