import 'package:aplikasi_film/core/data/responses/movie_detail_response.dart';
import 'package:get/get.dart';

class RentController extends GetxController {
  late final MovieDetailResponse movie;

  @override
  void onInit() {
    movie = Get.arguments as MovieDetailResponse;
    super.onInit();
  }

  void submitRent() {
    // Simulasi sewa
    Get.snackbar("Sewa Berhasil", "Film \"${movie.title}\" berhasil disewa!");
  }
}
