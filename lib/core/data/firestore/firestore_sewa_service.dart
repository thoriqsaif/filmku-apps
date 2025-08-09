import 'package:aplikasi_film/core/model/sewa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SewaFilmService {
  final CollectionReference rentals = FirebaseFirestore.instance.collection(
    'sewa_film', // ✅ disarankan lowercase dan underscore
  );

  /// Tambah sewa baru → return ID dokumen
  Future<String> rentMovie(Sewa sewa) async {
    try {
      final docRef = await rentals.add(sewa.toJson());
      return docRef.id;
    } catch (e, stacktrace) {
      debugPrint('❌ Firestore Error (rentMovie): $e');
      debugPrint('STACKTRACE:\n$stacktrace');
      rethrow;
    }
  }

  /// Ambil semua sewa milik user
  Future<List<Sewa>> getUserRentals(String userId) async {
    try {
      final querySnapshot = await rentals
          .where('userId', isEqualTo: userId)
          .orderBy(
            'tanggalSewa',
            descending: true,
          ) // ✅ supaya data terbaru di atas
          .get();

      return querySnapshot.docs.map((doc) {
        return Sewa.fromFirestore(doc);
      }).toList();
    } catch (e, stacktrace) {
      debugPrint('❌ Firestore Error (getUserRentals): $e');
      debugPrint('STACKTRACE:\n$stacktrace');
      return []; // ✅ supaya UI tidak crash
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
      debugPrint('❌ Firestore Error (updateRental): $e');
      debugPrint('STACKTRACE:\n$stacktrace');
      rethrow;
    }
  }

  /// Hapus data sewa
  Future<void> deleteRental(String rentalId) async {
    try {
      await rentals.doc(rentalId).delete();
    } catch (e, stacktrace) {
      debugPrint('❌ Firestore Error (deleteRental): $e');
      debugPrint('STACKTRACE:\n$stacktrace');
      rethrow;
    }
  }
}
