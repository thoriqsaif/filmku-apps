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
