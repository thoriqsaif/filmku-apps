import 'package:aplikasi_film/core/data/network/dio_api_client.dart';
import 'package:aplikasi_film/core/data/responses/movie_list_response.dart';
import 'package:flutter/foundation.dart';

class SearchService {
  Future<MovieListResponse> searchMovies(String query, int page) async {
    try {
      if (kDebugMode) {
        print('/search/movie?query=$query&page=$page');
      }

      final response = await DioApiClient().dio.get(
        '/search/movie',
        queryParameters: {'query': query, 'page': page},
      );

      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }
}
