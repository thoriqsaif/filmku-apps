import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/core/controller/register_controller.dart';
import 'package:aplikasi_film/core/controller/user_controller.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_user_service.dart';
import 'package:aplikasi_film/core/model/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final authController = Get.find<AuthController>();
  final userController = Get.put(
    UserController(Get.put(FirestoreUserService())),
  );
  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: const Text("Filmku Apps"),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Daftar sekarang',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _register(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Daftar'),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Text('Sudah punya akun?'),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Masuk'),
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

  Future<void> _register(BuildContext context) async {
    try {
      final result = await authController.register(
        controller.emailController.text,
        controller.passwordController.text,
      );

      userController.addUser(
        UserData(
          userId: result.user?.uid ?? '',
          userName: result.user?.displayName ?? '',
          userEmail: result.user?.email ?? '',
        ),
      );

      Get.snackbar('Sukses', 'Berhasil daftar sebagai ${result.user?.email}');
      Get.offAllNamed('/movie/list');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Gagal', 'Daftar gagal: ${e.message}');
    } catch (e) {
      Get.snackbar('Gagal', 'Daftar gagal: ${e.toString()}');
    } finally {
      controller.emailController.clear();
      controller.passwordController.clear();
    }
  }
}
