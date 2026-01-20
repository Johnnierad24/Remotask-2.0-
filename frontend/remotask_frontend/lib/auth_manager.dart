import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  final _storage = FlutterSecureStorage();
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> loadToken() async {
    _token = await _storage.read(key: _tokenKey);
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: _tokenKey, value: token);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: _tokenKey);
    notifyListeners();
  }
}
