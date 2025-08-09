import 'package:aplikasi_film/core/controller/user_controller.dart';
import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:aplikasi_film/core/model/user_data.dart';
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

  Future<UserCredential> register(
    String name,
    String email,
    String password,
  ) async {
    final credential = await authService.registerWithEmailAndPassword(
      email,
      password,
    );

    await credential.user?.updateDisplayName(name);
    await credential.user?.reload();

    final uid = credential.user?.uid;
    if (uid != null) {
      final newUser = UserData(
        userId: uid, // will be replaced by addUser anyway via copyWith
        userName: name,
        userEmail: email,
      );

      // Pastikan UserController sudah di-register di main.dart
      await Get.find<UserController>().addUser(newUser);
    }

    return credential;
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
