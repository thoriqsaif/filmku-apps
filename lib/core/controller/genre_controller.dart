import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:aplikasi_film/core/data/service/movie_service.dart';
import 'package:get/get.dart';

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
      final result = await MovieService.getGenres();
      genres.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load genres: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
