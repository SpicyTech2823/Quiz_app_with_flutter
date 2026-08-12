import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // key used to store the authentication token in shared preferences
  static const String _authTokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _phoneKey = 'phone';
  static const String _bioKey = 'bio';
  static const String _profileImageKey = 'profile_image_path';

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

  // save email for display in the app
  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<void> savePhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phone);
  }

  static Future<void> saveBio(String bio) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bioKey, bio);
  }

  static Future<void> saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, path);
  }

  static Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageKey);
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
    await prefs.remove(_emailKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_bioKey);
  }

  // get saved username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // get saved email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  static Future<String?> getBio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_bioKey);
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

  Future<Map<String, dynamic>> updateProfile({
    required String username,
    required String email,
    String? phone,
    String? bio,
  }) async {
    try {
      final token = await getAuthToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Authentication required. Please log in again.',
        };
      }

      final response = await _put(
        Uri.parse('$baseUrl/update-profile'),
        body: {
          'username': username.trim(),
          'email': email.trim(),
          'phone': phone?.trim(),
          'bio': bio?.trim(),
        },
        headers: {'Authorization': 'Bearer $token'},
      );

      final result = _handleResponse(response);
      if (result['success']) {
        await saveUsername(username);
        await saveEmail(email);
        if (phone != null) await savePhone(phone);
        if (bio != null) await saveBio(bio);
      }
      return result;
    } catch (_) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }

  Future<http.Response> _post(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    final combinedHeaders = {'Content-Type': 'application/json', ...?headers};
    if (requestExecutor != null) {
      return requestExecutor!(
        uri,
        headers: combinedHeaders,
        body: jsonEncode(body),
      );
    }

    return http.post(uri, headers: combinedHeaders, body: jsonEncode(body));
  }

  Future<http.Response> _put(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    final combinedHeaders = {'Content-Type': 'application/json', ...?headers};
    return http.put(uri, headers: combinedHeaders, body: jsonEncode(body));
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
