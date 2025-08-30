import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/presentation/signin_screen/signin_screen.dart';
import 'package:aplikasi_film/presentation/widget/lottie_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return StreamBuilder<User?>(
      stream: authController.checkUserSignInState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // ✅ user login → masuk loading screen dulu
          return const LoadingAnimationScreen();
        } else {
          // ✅ user logout → masuk signin
          return SignInScreen();
        }
      },
    );
  }
}
