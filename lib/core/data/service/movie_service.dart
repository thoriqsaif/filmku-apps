import 'package:aplikasi_film/core/config/api_config.dart';
import 'package:aplikasi_film/core/data/network/dio_api_client.dart';
import 'package:aplikasi_film/core/data/responses/movie_list_response.dart';
import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:dio/dio.dart';

class MovieService {
  final serviceName = '/movie';
  final Dio _dio;

  MovieService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          queryParameters: {'api_key': ApiConfig.apiKey},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

  Future<MovieListResponse> fetchMovies(String filter, int page) async {
    try {
      final response = await DioApiClient().dio.get(
        '/movie/$filter',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  Future<MovieDetailResponse> fetchMovieDetails(int movieId) async {
    try {
      final response = await DioApiClient().dio.get('/movie/$movieId');

      if (response.statusCode == 200) {
        return MovieDetailResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  Future<List<Result>> fetchMoviesByGenre(int genreId, int page) async {
    try {
      final response = await _dio.get(
        '/discover/movie',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'en-US',
          'with_genres': genreId.toString(),
          'page': page,
        },
      );

      final List data = response.data['results'];
      return data.map((e) => Result.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch movies by genre: $e');
    }
  }

  static Future<List<Genre>> getGenres() async {
    try {
      final response = await DioApiClient().dio.get('/genre/movie/list');

      if (response.statusCode == 200) {
        final List data = response.data['genres'];
        return data.map((e) => Genre.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch genres');
      }
    } catch (e) {
      throw Exception('Failed to fetch genres: $e');
    }
  }
}
