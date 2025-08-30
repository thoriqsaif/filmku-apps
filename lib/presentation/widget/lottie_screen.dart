import 'package:aplikasi_film/core/controller/movie_list_controller.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimationScreen extends StatefulWidget {
  const LoadingAnimationScreen({super.key});

  @override
  State<LoadingAnimationScreen> createState() => _LoadingAnimationScreenState();
}

class _LoadingAnimationScreenState extends State<LoadingAnimationScreen> {
  @override
  void initState() {
    super.initState();

    // Jalankan loading + fetch data
    _startLoading();
  }

  Future<void> _startLoading() async {
    final movieController = Get.find<MovieListController>();

    await Future.wait([
      movieController.getMovieList("now_playing", 1),
      Future.delayed(const Duration(seconds: 3)),
    ]);

    // ✅ Pastikan user masih login sebelum navigasi
    if (mounted) {
      Get.offAllNamed(NavigationRoutes.movieList.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/paperplane.json',
          width: 200,
          height: 200,
          repeat: true,
          reverse: true,
          animate: true,
        ),
      ),
    );
  }
}
