import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String imageUrl = 'https://image.tmdb.org/t/p/w500';

class DioApiClient {
  // create dio singleton instance
  static final DioApiClient _instance = DioApiClient._internal();
  factory DioApiClient() {
    return _instance;
  }
  DioApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['TMDB_API_KEY']}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        preserveHeaderCase: false,
        responseType: ResponseType.json,
        contentType: 'application/json',
        validateStatus: (status) {
          return status != null && status >= 200 && status < 400;
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  late final Dio _dio;
  Dio get dio => _dio;
}
