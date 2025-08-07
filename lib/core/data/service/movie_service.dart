import 'package:aplikasi_film/core/data/network/dio_api_client.dart';
import 'package:aplikasi_film/core/data/responses/movie_list_response.dart';
import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static Future<List<Genre>> getGenres() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];

    final response = await Dio().get(
      "https://api.themoviedb.org/3/genre/movie/list",
      queryParameters: {"api_key": apiKey},
    );

    final List data = response.data['genres'];
    return data.map((e) => Genre.fromJson(e)).toList();
  }
}
