import 'package:aplikasi_film/core/model/sewa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SewaFilmService {
  final CollectionReference rentals = FirebaseFirestore.instance.collection(
    'Sewa-Film',
  );

  /// Tambah sewa baru
  Future<void> rentMovie(Sewa sewa) async {
    await rentals.add(sewa.toJson());
  }

  /// Ambil semua sewa milik user
  Future<List<Sewa>> getUserRentals(String userId) async {
    try {
      final querySnapshot = await rentals
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        return Sewa.fromFirestore(doc);
      }).toList();
    } catch (e, stacktrace) {
      print('❌ Firestore Error (getUserRentals): $e');
      print('STACKTRACE:\n$stacktrace');
      rethrow;
    }
  }

  /// Update data sewa
  Future<void> updateRental(Sewa sewa) async {
    if (sewa.id == null) {
      throw Exception('Document ID tidak boleh null untuk update');
    }
    try {
      await rentals.doc(sewa.id).update(sewa.toJson());
    } catch (e, stacktrace) {
      print('❌ Firestore Error (updateRental): $e');
      print('STACKTRACE:\n$stacktrace');
      rethrow;
    }
  }

  /// Hapus data sewa
  Future<void> deleteRental(String rentalId) async {
    try {
      await rentals.doc(rentalId).delete();
    } catch (e, stacktrace) {
      print('❌ Firestore Error (deleteRental): $e');
      print('STACKTRACE:\n$stacktrace');
      rethrow;
    }
  }
}
