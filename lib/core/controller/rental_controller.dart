import 'package:aplikasi_film/core/data/firestore/firestore_sewa_service.dart';
import 'package:aplikasi_film/core/model/sewa.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentalController extends GetxController {
  final SewaFilmService rentalService;

  RentalController(this.rentalService);

  var isLoading = false.obs;
  var rentals = <Sewa>[].obs;

  Future<void> rentMovie(Sewa sewa) async {
    try {
      print('[DEBUG] Mulai proses sewa: ${sewa.toJson()}');
      isLoading.value = true;
      await rentalService.rentMovie(sewa);
      rentals.add(sewa);
      Get.snackbar('Sukses', 'Film berhasil disewa');
    } catch (e, stacktrace) {
      Get.snackbar('Error', 'Gagal menyewa film: $e');
      debugPrint('❌ ERROR SEWA FILM: $e');
      debugPrint('STACKTRACE:\n$stacktrace');
      if (e is FirebaseException) {
        debugPrint('🔥 FIREBASE ERROR: ${e.code} - ${e.message}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  var userRentals = <Sewa>[].obs;

  Future<void> fetchUserRentals(String userId) async {
    await Future.delayed(Duration.zero); // Pastikan keluar dari fase build
    isLoading.value = true;

    try {
      // proses ambil data
    } finally {
      isLoading.value = false;
    }
  }

  void goToSewaPage(int movieId, String title) {
    Get.toNamed(
      NavigationRoutes.sewaFilm.name,
      arguments: {'movieId': movieId, 'title': title},
    );
  }
}
