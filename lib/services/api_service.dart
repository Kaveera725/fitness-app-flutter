import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserSession {
  final int id;
  final String email;
  final String? name;

  UserSession({required this.id, required this.email, this.name});

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'] ?? json['user_id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'],
    );
  }
}

class ApiService {
  // Singleton pattern
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  UserSession? currentUser;

  /// Default Base URL based on platform
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return 'http://127.0.0.1:8000';
    }
  }

  String baseUrl = defaultBaseUrl;

  /// Check backend and database connectivity
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Server responded with status ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Could not connect to backend at $baseUrl ($e)',
      };
    }
  }

  /// Signup a new user
  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
          if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        currentUser = UserSession.fromJson(data);
        return {
          'success': true,
          'user': currentUser,
          'message': 'Account created successfully!',
        };
      } else {
        final errorMsg = data['detail'] ?? 'Registration failed';
        return {
          'success': false,
          'error': errorMsg is List ? errorMsg.map((e) => e['msg']).join(', ') : errorMsg.toString(),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Connection error: Unable to reach the backend server ($e)',
      };
    }
  }

  /// Login an existing user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),

        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        currentUser = UserSession.fromJson(data);
        return {
          'success': true,
          'user': currentUser,
          'message': 'Login successful!',
        };
      } else {
        final errorMsg = data['detail'] ?? 'Invalid credentials';
        return {
          'success': false,
          'error': errorMsg is List ? errorMsg.map((e) => e['msg']).join(', ') : errorMsg.toString(),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Connection error: Unable to reach the backend server ($e)',
      };
    }
  }

  /// Logout current user
  void logout() {
    currentUser = null;
  }
}
