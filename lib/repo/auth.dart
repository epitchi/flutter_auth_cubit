import 'dart:convert';
import 'package:flutter_auth_cubit/main.dart';
import 'package:flutter_auth_cubit/model/auth.dart';
import 'package:flutter_auth_cubit/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<Auth> login(String email, String password) async {
    
    try {
      final data = await pb.collection('users').authWithPassword(email, password);
      
      if (data.token.isEmpty) {
        throw const AuthException(message: 'Auth failed: no token received');
      }

      if (data.record.id.isEmpty) {
        throw const AuthException(message: 'Auth failed: no received any user record');
      }

      await Future.wait([
        _saveToken(data.token),
        _saveUser(User.fromJson(data.record.toJson()))
      ]);
      return Auth.fromJson(data.toJson());
    } catch (err) {
      throw AuthException(message: 'Invalid credential + ${err.toString()}');
    }

  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
