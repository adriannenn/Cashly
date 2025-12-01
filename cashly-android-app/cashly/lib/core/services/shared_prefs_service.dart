import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPrefsService> getInstance() async {
    _instance ??= SharedPrefsService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Theme
  Future<bool> setThemeMode(String mode) async {
    return await _preferences!.setString(AppConstants.keyThemeMode, mode);
  }

  String getThemeMode() {
    return _preferences!.getString(AppConstants.keyThemeMode) ?? 'system';
  }

  // Authentication
  Future<bool> setIsLoggedIn(bool value) async {
    return await _preferences!.setBool(AppConstants.keyIsLoggedIn, value);
  }

  bool getIsLoggedIn() {
    return _preferences!.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  Future<bool> setUserId(String userId) async {
    return await _preferences!.setString(AppConstants.keyUserId, userId);
  }

  String? getUserId() {
    return _preferences!.getString(AppConstants.keyUserId);
  }

  Future<bool> setUserEmail(String email) async {
    return await _preferences!.setString(AppConstants.keyUserEmail, email);
  }

  String? getUserEmail() {
    return _preferences!.getString(AppConstants.keyUserEmail);
  }

  // First Launch
  Future<bool> setFirstLaunch(bool value) async {
    return await _preferences!.setBool(AppConstants.keyFirstLaunch, value);
  }

  bool isFirstLaunch() {
    return _preferences!.getBool(AppConstants.keyFirstLaunch) ?? true;
  }

  // Clear all preferences
  Future<bool> clearAll() async {
    return await _preferences!.clear();
  }

  // Logout
  Future<void> logout() async {
    await setIsLoggedIn(false);
    await _preferences!.remove(AppConstants.keyUserId);
    await _preferences!.remove(AppConstants.keyUserEmail);
  }
}
