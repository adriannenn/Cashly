import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/shared_prefs_service.dart';
import '../utils/helpers.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Initialize - check if user is logged in
  Future<void> initialize() async {
    final prefs = await SharedPrefsService.getInstance();
    final isLoggedIn = prefs.getIsLoggedIn();
    
    if (isLoggedIn) {
      final userId = prefs.getUserId();
      if (userId != null) {
        _currentUser = await DatabaseService.instance.getUserById(userId);
        notifyListeners();
      }
    }
  }

  // Register new user
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if user already exists
      final existingUser = await DatabaseService.instance.getUserByEmail(email);
      if (existingUser != null) {
        _errorMessage = 'Email already registered';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create new user
      final user = UserModel(
        fullName: fullName,
        email: email,
        password: Helpers.hashPassword(password),
      );

      final userId = await DatabaseService.instance.createUser(user);
      _currentUser = user.copyWith(id: userId);

      // Save to shared preferences
      final prefs = await SharedPrefsService.getInstance();
      await prefs.setIsLoggedIn(true);
      await prefs.setUserId(userId);
      await prefs.setUserEmail(email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await DatabaseService.instance.getUserByEmail(email);
      
      if (user == null) {
        _errorMessage = 'User not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Verify password
      if (!Helpers.validatePasswordMatch(password, user.password)) {
        _errorMessage = 'Invalid password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;

      // Save to shared preferences
      final prefs = await SharedPrefsService.getInstance();
      await prefs.setIsLoggedIn(true);
      await prefs.setUserId(user.id!);
      await prefs.setUserEmail(email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPrefsService.getInstance();
    await prefs.logout();
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? email,
    String? profileImage,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = _currentUser!.copyWith(
        fullName: fullName ?? _currentUser!.fullName,
        email: email ?? _currentUser!.email,
        profileImage: profileImage ?? _currentUser!.profileImage,
        updatedAt: DateTime.now(),
      );

      await DatabaseService.instance.updateUser(updatedUser);
      _currentUser = updatedUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Update failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Verify current password
      if (!Helpers.validatePasswordMatch(currentPassword, _currentUser!.password)) {
        _errorMessage = 'Current password is incorrect';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final updatedUser = _currentUser!.copyWith(
        password: Helpers.hashPassword(newPassword),
        updatedAt: DateTime.now(),
      );

      await DatabaseService.instance.updateUser(updatedUser);
      _currentUser = updatedUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Password change failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
