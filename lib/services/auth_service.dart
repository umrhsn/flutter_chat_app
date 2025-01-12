import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user {
    return _user;
  }

  AuthService() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListener);
  }

  Future<bool> logIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      debugPrint('$e');
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      debugPrint('$e');
    }
    return false;
  }

  Future<bool> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint('$e');
    }
    return false;
  }

  void authStateChangesStreamListener(User? user) {
    _user = user;
  }
}
