import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuthService authService;
  AuthController(this.authService);

  Future<UserCredential> signIn(String email, String password) async {
    final result = await authService.signInWithEmailAndPassword(
      email,
      password,
    );

    return result;
  }

  Future<UserCredential> register(String email, String password) async {
    final result = await authService.registerWithEmailAndPassword(
      email,
      password,
    );

    return result;
  }

  Future<UserCredential?> signInWithGoogle() async {
    return authService.signInWithGoogle();
  }

  Stream<User?> checkUserSignInState() {
    final state = authService.checkUserSignInState();
    return state;
  }

  signOut() {
    authService.signInWithGoogle();
  }
}
