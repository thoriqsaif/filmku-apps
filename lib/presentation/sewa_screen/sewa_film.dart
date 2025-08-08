import 'package:aplikasi_film/core/controller/rental_controller.dart';
import 'package:aplikasi_film/core/model/sewa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SewaFilm extends StatefulWidget {
  final String movieId;
  final String title;

  const SewaFilm({super.key, required this.movieId, required this.title});

  @override
  State<SewaFilm> createState() => _SewaFilmState();
}

class _SewaFilmState extends State<SewaFilm> {
  final rentalController = Get.find<RentalController>();

  int rentalDays = 1;
  int get totalPrice => rentalDays * 5000;

  void handleSewa() {
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

    rentalController.rentMovie(sewa);
    Get.back(); // kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sewa Film')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul: ${widget.title}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Lama sewa (1–7 hari):'),
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
            Text('Harga per hari: Rp 5.000'),
            const SizedBox(height: 10),
            Text('Total harga: Rp $totalPrice'),
            const SizedBox(height: 30),
            Obx(() {
              return rentalController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: handleSewa,
                      child: const Text('Sewa Sekarang'),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
