import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> checkAuth() async {
    _user = await ApiService.getSavedUser();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await ApiService.login(username, password);
      if (result['statusCode'] == 200) {
        _user = result['user'];
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = result['error'] ?? 'Login gagal';
    } catch (_) {
      _error = 'Tidak dapat terhubung ke server.';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await ApiService.clearAll();
    _user = null;
    notifyListeners();
  }
}