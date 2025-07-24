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
      // Atualiza o usuário após login, mas sem chamar notifyListeners duas vezes
      final current = _authService.currentUser;
      if (current != null) {
        _user = current;
      }
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
      final current = _authService.currentUser;
      if (current != null) {
        _user = current;
      }
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
    _error = null;
    notifyListeners();
  }

  /// Atualiza o usuário autenticado, mas só chama notifyListeners se houver mudança real.
  void loadCurrentUser() {
    Future.microtask(() {
      final current = _authService.currentUser;
      if (current?.uid != _user?.uid) {
        _user = current;
        notifyListeners();
      }
    });
  }
}
