import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/user_model.dart';

class AuthViewModel with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _user = UserModel.empty();
  UserModel get user => _user;

  Future<void> register(String name, String email, String password) async {
    try {
      _user.loading = true;
      notifyListeners();
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final firebaseUser = userCredential.user!;
      _user = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
      );

      await firebaseUser.updateDisplayName(name);

      _user.loading = false;
      _user.hasError = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _user.loading = false;
      _user.hasError = true;
      notifyListeners();
      debugPrint('Register Error: $e.message');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _user.loading = true;
      notifyListeners();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user!;

      _user = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
      );

      _user.loading = false;
      _user.hasError = false;

      _isLoggedIn = true;

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _user.loading = false;
      _user.hasError = true;

      notifyListeners();
      debugPrint('Login Error: ${e.message}');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = UserModel.empty();
    _isLoggedIn = false;
    notifyListeners();
  }
}
