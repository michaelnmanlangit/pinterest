import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AuthUser? _currentUser;
  bool _isLoading = false;
  String _errorMessage = '';

  AuthUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Mock users database
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'email': 'demo@pinterest.com',
      'password': 'password123',
      'name': 'Demo User',
      'username': '@demouser',
      'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b48b?w=200&h=200&fit=crop&crop=face',
      'bio': 'Welcome to Pinterest clone!',
      'followers': 1234,
      'following': 567,
      'pins': 89,
      'verified': true,
      'website': 'www.pinterest.com',
      'createdAt': '2024-01-01T00:00:00.000Z',
    },
    {
      'id': '2',
      'email': 'sarah@email.com',
      'password': 'sarah123',
      'name': 'Sarah Johnson',
      'username': '@sarahdesigns',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face',
      'bio': 'Interior designer passionate about modern minimalism',
      'followers': 12456,
      'following': 234,
      'pins': 189,
      'verified': true,
      'website': 'www.sarahdesigns.com',
      'createdAt': '2023-06-15T00:00:00.000Z',
    },
  ];

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      
      if (userJson != null) {
        final userData = json.decode(userJson);
        _currentUser = AuthUser.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      print('Error initializing auth: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Find user in mock database
      final userMap = _mockUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (userMap.isEmpty) {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = AuthUser.fromJson(userMap);
      
      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(_currentUser!.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name, String username) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if email already exists
      final existingUser = _mockUsers.firstWhere(
        (user) => user['email'] == email,
        orElse: () => {},
      );

      if (existingUser.isNotEmpty) {
        _errorMessage = 'Email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if username already exists
      final existingUsername = _mockUsers.firstWhere(
        (user) => user['username'] == username,
        orElse: () => {},
      );

      if (existingUsername.isNotEmpty) {
        _errorMessage = 'Username already taken';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create new user
      final newUser = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': email,
        'password': password,
        'name': name,
        'username': username.startsWith('@') ? username : '@$username',
        'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop&crop=face',
        'bio': 'New Pinterest user',
        'followers': 0,
        'following': 0,
        'pins': 0,
        'verified': false,
        'website': '',
        'createdAt': DateTime.now().toIso8601String(),
      };

      _mockUsers.add(newUser);
      _currentUser = AuthUser.fromJson(newUser);

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(_currentUser!.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    
    // Clear from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    
    notifyListeners();
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if email exists
      final userExists = _mockUsers.any((user) => user['email'] == email);
      
      if (!userExists) {
        _errorMessage = 'Email not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to send reset email';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? name,
    String? bio,
    String? website,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Update current user
      _currentUser = AuthUser(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name ?? _currentUser!.name,
        username: _currentUser!.username,
        avatar: _currentUser!.avatar,
        bio: bio ?? _currentUser!.bio,
        followers: _currentUser!.followers,
        following: _currentUser!.following,
        pins: _currentUser!.pins,
        verified: _currentUser!.verified,
        website: website ?? _currentUser!.website,
        createdAt: _currentUser!.createdAt,
      );

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(_currentUser!.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
