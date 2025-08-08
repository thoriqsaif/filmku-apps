import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get apiKey {
    final key = dotenv.env['TMDB_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('TMDB_API_KEY not found in .env');
    }
    return key;
  }

  static const baseUrl = 'https://api.themoviedb.org/3';
}
