import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/core/controller/user_controller.dart';
import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_user_service.dart';
import 'package:aplikasi_film/core/model/user_data.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController psswdController = TextEditingController();

  AuthController authController = Get.put(
    AuthController(Get.put(FirebaseAuthService())),
  );

  UserController userController = Get.put(
    UserController(Get.put(FirestoreUserService())),
  );

  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Silahkan Masuk',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                SizedBox.square(dimension: 32),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukan Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox.square(dimension: 16),
                TextField(
                  controller: psswdController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukan Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox.square(dimension: 16),
                ElevatedButton(
                  onPressed: () async {
                    _signInWithEmail();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Masuk'),
                    ),
                  ),
                ),
                SizedBox.square(dimension: 16),
                Text('Atau'),
                SizedBox.square(dimension: 16),
                ElevatedButton(
                  onPressed: () async {
                    _signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Masuk dengan Google'),
                    ),
                  ),
                ),
                SizedBox.square(dimension: 32),
                Row(
                  children: [
                    Text('Belum punya akun?'),
                    SizedBox.square(dimension: 4),
                    TextButton(
                      onPressed: () {
                        // Navigator.pushNamed(
                        //     context, NavigationRoutes.register.name);
                      },
                      child: Text('Daftar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _signInWithEmail() async {
    try {
      final result = await authController.signIn(
        emailController.text,
        psswdController.text,
      );

      if (mounted) {
        _showSnackbar('Sukses masuk sebagai ${result.user?.email}');
        //Navigator.pushNamed(context, NavigationRoutes.movieList.name);
      }
    } on FirebaseAuthException catch (e) {
      _showSnackbar('Masuk gagal: ${e.message}');
    } catch (e) {
      _showSnackbar('Masuk gagal');
    }

    emailController.clear();
    psswdController.clear();
  }

  Future _signInWithGoogle() async {
    try {
      final result = await authController.signInWithGoogle();

      if (result != null) {
        userController.addUser(
          UserData(
            userId: result.user?.uid ?? '',
            userName: result.user?.displayName ?? '',
            userEmail: result.user?.email ?? '',
          ),
        );

        if (mounted) {
          _showSnackbar('Sukses masuk sebagai ${result.user?.email}');
          Navigator.pushNamed(context, NavigationRoutes.movieList.name);
        }
      }
    } on FirebaseAuthException catch (e) {
      _showSnackbar('Masuk gagal: ${e.message}');
    } on GoogleSignInException catch (e) {
      _showSnackbar('Masuk gagal: ${e.description}');
    } catch (e) {
      _showSnackbar('Masuk gagal: $e');
    }
  }

  _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
