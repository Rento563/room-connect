import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart' as user_model;

class AuthProvider with ChangeNotifier {
  user_model.User? _currentUser;
  final SupabaseClient _supabase = Supabase.instance.client;

  user_model.User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        // Fetch user profile from database
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();
        _currentUser = user_model.User.fromJson(userData);
        await _saveUserLocally();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
      print('Login error: $e');
    }
  }

  Future<void> signup(
    String name,
    String email,
    String phone,
    String password,
    user_model.UserRole role,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        // Insert user profile
        await _supabase.from('users').insert({
          'id': response.user!.id,
          'name': name,
          'email': email,
          'phone': phone,
          'role': role.name,
        });
        _currentUser = user_model.User(
          id: response.user!.id,
          name: name,
          email: email,
          phone: phone,
          role: role,
        );
        await _saveUserLocally();
        notifyListeners();
      }
    } catch (e) {
      print('Signup error: $e');
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _currentUser = user_model.User.fromJson(json.decode(userJson));
      notifyListeners();
    } else {
      // Check if user is logged in with Supabase
      final session = _supabase.auth.currentSession;
      if (session != null) {
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', session.user.id)
            .single();
        _currentUser = user_model.User.fromJson(userData);
        await _saveUserLocally();
        notifyListeners();
      }
    }
  }

  Future<void> _saveUserLocally() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      await prefs.setString('user', json.encode(_currentUser!.toJson()));
    }
  }
}
