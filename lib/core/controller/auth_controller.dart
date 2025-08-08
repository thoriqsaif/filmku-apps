import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuthService authService;
  AuthController(this.authService);

  // Gunakan getter untuk ambil user ID
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // Atau juga bisa getter untuk ambil User
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    return await authService.signInWithEmailAndPassword(email, password);
  }

  Future<UserCredential> register(String email, String password) async {
    return await authService.registerWithEmailAndPassword(email, password);
  }

  Future<UserCredential?> signInWithGoogle() async {
    return authService.signInWithGoogle();
  }

  Stream<User?> checkUserSignInState() {
    return authService.checkUserSignInState();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await authService.googleSignIn.signOut();
  }
}
