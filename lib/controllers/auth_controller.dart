// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000/api"; // change to your backend URL

  // LOGIN
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    final decoded = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "data": decoded,
      "message": decoded['message'] ?? '',
    };
  }

  // REGISTER
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    final decoded = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "data": decoded,
      "message": decoded['message'] ?? '',
    };
  }
}