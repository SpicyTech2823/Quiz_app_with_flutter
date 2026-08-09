import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // key used to store the authentication token in shared preferences
  static const String _authTokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  // save token after successful login or registration
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  // save username for display in the app
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  // retrieve token for authenticated requests
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Check whether the user is logged in.
  static Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null;
  }

  // remove token on logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_usernameKey);
  }

  // get saved username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  AuthService({this.requestExecutor});

  final Future<http.Response> Function(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  })?
  requestExecutor;

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
    try {
      final response =
          await _post(
            Uri.parse('$baseUrl/login'),
            body: {'email': email.trim(), 'password': password},
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw SocketException('Request timed out');
            },
          );

      return _handleResponse(response);
    } on SocketException catch (_) {
      return {
        'success': false,
        'message': 'Unable to connect to the server. Please try again.',
      };
    } on HttpException catch (_) {
      return {
        'success': false,
        'message': 'Unable to connect to the server. Please try again.',
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _post(
        Uri.parse('$baseUrl/register'),
        body: {
          'username': username.trim(),
          'email': email.trim(),
          'password': password,
        },
      );

      return _handleResponse(response);
    } on SocketException catch (_) {
      return {
        'success': false,
        'message': 'Unable to connect to the server. Please try again.',
      };
    } on HttpException catch (_) {
      return {
        'success': false,
        'message': 'Unable to connect to the server. Please try again.',
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }

  Future<http.Response> _post(Uri uri, {required Map<String, dynamic> body}) {
    if (requestExecutor != null) {
      return requestExecutor!(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    }

    return http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
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
