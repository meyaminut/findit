import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({UserProfile? initialProfile}) : _currentUser = initialProfile;

  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void setProfile(UserProfile profile) {
    _currentUser = profile;
    notifyListeners();
  }

  Future<void> loadSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await AuthService.loadSession();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await AuthService.login(email: email, password: password);
      await AuthService.saveSession(profile);
      _currentUser = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final profile = await AuthService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      await AuthService.saveSession(profile);
      _currentUser = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateProfile({String? name, String? phone, String? photoPath}) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      phone: phone ?? _currentUser!.phone,
      photoPath: photoPath ?? _currentUser!.photoPath,
    );
    await AuthService.saveSession(_currentUser!);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await AuthService.clearSession();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}
