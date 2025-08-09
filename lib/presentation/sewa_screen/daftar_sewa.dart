import 'package:aplikasi_film/core/controller/rental_controller.dart';
import 'package:aplikasi_film/presentation/sewa_screen/sewa_film.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DaftarSewa extends StatefulWidget {
  const DaftarSewa({super.key});

  @override
  State<DaftarSewa> createState() => _DaftarSewaState();
}

class _DaftarSewaState extends State<DaftarSewa> {
  final rentalController = Get.find<RentalController>();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    // Panggil hanya sekali di sini
    rentalController.fetchUserRentals(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Sewa')),
      body: Obx(() {
        if (rentalController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (rentalController.userRentals.isEmpty) {
          return const Center(child: Text('Belum ada film yang disewa.'));
        }

        return ListView.builder(
          itemCount: rentalController.userRentals.length,
          itemBuilder: (context, index) {
            final sewa = rentalController.userRentals[index];
            final expired = sewa.returnDate.isBefore(DateTime.now());
            final dateFormat = DateFormat('dd MMM yyyy');

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(sewa.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sewa: ${dateFormat.format(sewa.rentDate)}'),
                    Text('Kembali: ${dateFormat.format(sewa.returnDate)}'),
                    Text('Total: Rp ${sewa.totalPrice}'),
                    if (expired)
                      const Text(
                        'Masa sewa telah habis',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
                trailing: expired
                    ? ElevatedButton(
                        onPressed: () {
                          Get.to(
                            () => SewaFilm(
                              movieId: sewa.movieId,
                              title: sewa.title,
                            ),
                          );
                        },
                        child: const Text('Sewa Lagi'),
                      )
                    : null,
              ),
            );
          },
        );
      }),
    );
  }
}
