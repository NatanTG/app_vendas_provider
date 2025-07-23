import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Controller responsável pelo estado de autenticação
class AuthController extends ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  String? _error;
  bool _isLoading = false;

  AuthController({AuthService? authService}) : _authService = authService ?? AuthService();

  UserModel? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.signIn(email, password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.signUp(email, password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void loadCurrentUser() {
    _user = _authService.currentUser;
    notifyListeners();
  }
}
