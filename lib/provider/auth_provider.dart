import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  Future<bool> register(String email, String password) async {
    _user = await _authService.signUp(email, password);
    notifyListeners();
    return _user != null;
  }

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // Log to Firestore
        await FirebaseFirestore.instance.collection('login_logs').add({
          'uid': user.uid,
          'email': user.email,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

    } on FirebaseAuthException catch (e) {
      print("Login error: ${e.message}");
      throw e.message ?? "Login failed";
    }
  }


  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
