import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/presentation/movie_list/movie_list.dart';
import 'package:aplikasi_film/presentation/signin_screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    Future.delayed(Duration(seconds: 2), () {
      authController.userId != null
          ? Get.offAll(() => MovieListScreen())
          : Get.offAll(() => SignInScreen());
    });

    return Scaffold(body: Center(child: Image.asset('assets/logo.png')));
  }
}
