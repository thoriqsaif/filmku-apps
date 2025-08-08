import 'package:aplikasi_film/core/data/responses/movie_list_response.dart';
import 'package:aplikasi_film/core/data/service/movie_service.dart';
import 'package:aplikasi_film/core/data/state/remote_state.dart';
import 'package:get/get.dart';

class MovieDetailController extends GetxController {
  final MovieService movieService;

  MovieDetailController({required this.movieService});

  final Rx<RemoteState> _remoteState = Rx<RemoteState>(RemoteStateNone());

  get remoteState => _remoteState.value;

  Future getMovieDetail(int movieId) async {
    try {
      _remoteState.value = RemoteStateLoading();

      final result = await movieService.fetchMovieDetails(movieId);
      _remoteState.value = RemoteStateSuccess(result);
    } on Exception catch (e) {
      _remoteState.value = RemoteStateError(e.toString());
    }
  }
}

class SimilarMovieController extends GetxController {
  final MovieService movieService;

  SimilarMovieController({required this.movieService});

  final RxList<Result> similarMovies = <Result>[].obs;
  final Rx<RemoteState> remoteState = Rx<RemoteState>(RemoteStateNone());

  Future<void> fetchByGenre(int genreId) async {
    try {
      remoteState.value = RemoteStateLoading();
      final results = await movieService.fetchMoviesByGenre(genreId, 1);
      similarMovies.assignAll(results);
      remoteState.value = RemoteStateSuccess(results);
    } catch (e) {
      remoteState.value = RemoteStateError(e.toString());
    }
  }
}
