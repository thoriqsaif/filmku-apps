import 'package:aplikasi_film/core/controller/rental_controller.dart';
import 'package:aplikasi_film/core/model/sewa.dart';
import 'package:aplikasi_film/presentation/sewa_screen/daftar_sewa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SewaFilm extends StatefulWidget {
  final String movieId;
  final String title;

  const SewaFilm({super.key, required this.movieId, required this.title});

  @override
  State<SewaFilm> createState() => _SewaFilmState();
}

class _SewaFilmState extends State<SewaFilm> {
  final rentalController = Get.find<RentalController>();
  final currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  int rentalDays = 1;
  int get totalPrice => rentalDays * 5000;

  Future<void> handleSewa() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final now = DateTime.now();
    final sewa = Sewa(
      userId: userId,
      movieId: widget.movieId,
      title: widget.title,
      rentalDays: rentalDays,
      rentDate: now,
      returnDate: now.add(Duration(days: rentalDays)),
      totalPrice: totalPrice,
    );

    try {
      await rentalController.rentMovie(sewa);
      Get.snackbar('Sukses', 'Film berhasil disewa');
      Get.off(() => DaftarSewa());
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan saat menyewa film');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sewa Film')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul: ${widget.title}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text('Lama sewa (1–7 hari):'),
            DropdownButton<int>(
              value: rentalDays,
              items: List.generate(7, (i) => i + 1)
                  .map(
                    (e) => DropdownMenuItem(value: e, child: Text('$e hari')),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  rentalDays = value ?? 1;
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Harga per hari: ${currencyFormat.format(5000)}'),
            const SizedBox(height: 10),
            Text('Total harga: ${currencyFormat.format(totalPrice)}'),
            const Spacer(),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: rentalController.isLoading.value
                      ? null
                      : handleSewa,
                  child: rentalController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sewa Sekarang'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
