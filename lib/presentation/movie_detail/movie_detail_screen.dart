import 'package:aplikasi_film/core/controller/movie_detail_controller.dart';
import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:aplikasi_film/core/data/service/movie_service.dart';
import 'package:aplikasi_film/core/data/state/remote_state.dart';
import 'package:aplikasi_film/presentation/movie_detail/movie_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  MovieDetailController movieDetailController = Get.put(
    MovieDetailController(movieService: Get.put(MovieService())),
  );

  @override
  void initState() {
    Future.microtask(() {
      movieDetailController.getMovieDetail(widget.movieId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Film")),
      body: Obx(() {
        return switch (movieDetailController.remoteState) {
          RemoteStateLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          RemoteStateError(error: var message) => Center(child: Text(message)),
          RemoteStateSuccess<MovieDetailResponse>(data: var response) =>
            MovieDetailContent(movieDetail: response),
          _ => const Center(child: Text('nothing')),
        };
      }),
    );
  }
}
