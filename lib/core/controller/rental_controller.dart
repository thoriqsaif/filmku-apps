import 'package:aplikasi_film/core/data/firestore/firestore_sewa_service.dart';
import 'package:aplikasi_film/core/model/sewa.dart';
import 'package:get/get.dart';

class RentalController extends GetxController {
  final SewaFilmService rentalService;

  RentalController(this.rentalService);

  var isLoading = false.obs;
  var rentals = <Sewa>[].obs;

  Future<void> rentMovie(Sewa sewa) async {
    try {
      isLoading.value = true;
      await rentalService.rentMovie(sewa);
      rentals.add(sewa);
      Get.snackbar('Sukses', 'Film berhasil disewa');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyewa film: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserRentals(String userId) async {
    try {
      isLoading.value = true;
      final result = await rentalService.getUserRentals(userId);
      rentals.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data sewa: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
