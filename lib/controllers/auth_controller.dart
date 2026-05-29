import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.1.28:8000/api";

  dynamic _safeDecode(String body) {
    try {
      return body.isNotEmpty ? jsonDecode(body) : {};
    } catch (e) {
      return {"raw": body};
    }
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 15));

      final decoded = _safeDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "data": decoded,
        "message": decoded['message'] ?? '',
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "message": e.toString(),
        "data": null,
      };
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 15));

      final decoded = _safeDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "data": decoded,
        "message": decoded['message'] ?? '',
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "message": e.toString(),
        "data": null,
      };
    }
  }
}