import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api/auth';
    }
    return 'http://10.0.2.2:5000/api/auth';
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.trim(),
        'email': email.trim(),
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final body = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': body};
      }

      return {'success': false, 'message': body['message'] ?? 'Request failed'};
    } catch (_) {
      return {'success': false, 'message': 'Unexpected response from server'};
    }
  }
}
