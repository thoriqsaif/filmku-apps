import 'package:aplikasi_film/core/data/network/dio_api_client.dart';
import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:get/get.dart';

// Define an observable list for genres
class GenreController extends GetxController {
  final genres = <Genre>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGenres();
  }

  void fetchGenres() async {
    try {
      isLoading.value = true;

      final response = await DioApiClient().dio.get('/genre/movie/list');

      if (response.statusCode == 200) {
        final List data = response.data['genres'];
        final genreList = data.map((e) => Genre.fromJson(e)).toList();
        genres.assignAll(genreList);
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching genres: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
