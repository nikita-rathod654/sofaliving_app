import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDbConnected = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isDemoUser => _currentUser?.email.toLowerCase() == 'aarav.mehta@example.com';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isDbConnected => _isDbConnected;

  AuthProvider() {
    // Auto check MySQL connection on launch
    checkDbStatus();
    // Default to demo user as requested in assignment for instant preview
    _currentUser = User.demoUser();
  }

  Future<void> checkDbStatus() async {
    _isDbConnected = await _apiService.checkConnection();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.login(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
      }
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> loginAsDemo() async {
    return await login('aarav.mehta@example.com', 'password123');
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.register(email, password, fullName, phone);
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
