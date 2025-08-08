import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String imageUrl = 'https://image.tmdb.org/t/p/w500';

class DioApiClient {
  final Dio dio;

  DioApiClient._internal(this.dio);

  factory DioApiClient() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
        // Default query params (api_key + language)
        queryParameters: {
          'api_key': dotenv.env['TMDB_API_KEY'],
          'language': 'en-US',
        },
      ),
    );

    return DioApiClient._internal(dio);
  }
}
