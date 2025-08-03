import 'package:aplikasi_film/core/data/network/dio_api_client.dart';
import 'package:aplikasi_film/core/data/responses/movie_list_response.dart';
import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:flutter/foundation.dart';

class MovieService {
  final serviceName = '/movie';

  Future<MovieListResponse> fetchMovies(String filter, int page) async {
    try {
      if (kDebugMode) {
        print('$serviceName/$filter?page=$page');
      }

      final response = await DioApiClient().dio.get(
        '$serviceName/$filter?page=$page',
      );
      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Failed to load movies: ${e.toString()}');
    }
  }

  Future<MovieDetailResponse> fetchMovieDetails(int movieId) async {
    try {
      final response = await DioApiClient().dio.get('$serviceName/$movieId');
      if (response.statusCode == 200) {
        return MovieDetailResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }
}
