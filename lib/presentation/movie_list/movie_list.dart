import 'package:aplikasi_film/core/controller/movie_list_controller.dart';
import 'package:aplikasi_film/core/data/service/movie_service.dart';
import 'package:aplikasi_film/presentation/movie_list/movie_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  MovieListController movieListController = Get.put(
    MovieListController(movieService: Get.put(MovieService())),
  );

  @override
  void initState() {
    Future.microtask(
      () => {
        movieListController.getMovieList(
          movieListController.selectedFilter,
          movieListController.currentPage,
        ),
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const MovieListContent());
  }
}
