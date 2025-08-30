import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/core/controller/password_rive_controller.dart';
import 'package:aplikasi_film/core/controller/sign_in_controller.dart';
import 'package:aplikasi_film/core/controller/user_controller.dart';
import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_user_service.dart';
import 'package:aplikasi_film/core/model/user_data.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:aplikasi_film/presentation/widget/rive_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final authController = Get.put(
    AuthController(Get.put(FirebaseAuthService())),
  );
  final userController = Get.put(
    UserController(Get.put(FirestoreUserService())),
  );
  final controller = Get.put(SignInController());

  // Controller untuk animasi Rive
  final passwordRiveController = PasswordRiveController();

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
                const SizedBox(height: 32),

                // Email field
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukan Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field dengan animasi Rive
                Obx(
                  () => Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordVisible.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Masukan Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.togglePasswordVisibility();

                              // ✅ panggil animasi lewat controller
                              passwordRiveController.toggleEye(
                                controller.isPasswordVisible.value,
                              );
                            },
                          ),
                        ),
                      ),
                      // Animasi Rive di pojok kanan textfield
                      Positioned(
                        right: 8,
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: PasswordRiveAnimation(
                            controller: controller.passwordController,
                            riveController: passwordRiveController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol login
                ElevatedButton(
                  onPressed: () => _signInWithEmail(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Masuk'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Atau'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _signInWithGoogle(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Masuk dengan Google'),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Text('Belum punya akun?'),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          NavigationRoutes.register.name,
                        );
                      },
                      child: const Text('Daftar'),
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

  Future _signInWithEmail(BuildContext context) async {
    try {
      final result = await authController.signIn(
        controller.emailController.text,
        controller.passwordController.text,
      );
      Get.snackbar('Berhasil', 'Sukses masuk sebagai ${result.user?.email}');

      // Ganti navigator.pushNamed → Get.offAllNamed
      Get.offAllNamed('/loadingAnimation');
    } catch (e) {
      Get.snackbar('Gagal', 'Masuk gagal: ${e.toString()}');
    }
  }

  Future _signInWithGoogle(BuildContext context) async {
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

        Get.snackbar('Berhasil', 'Sukses masuk sebagai ${result.user?.email}');
        Get.offAllNamed('/loadingAnimation');
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Masuk gagal: ${e.toString()}');
    }
  }
}
