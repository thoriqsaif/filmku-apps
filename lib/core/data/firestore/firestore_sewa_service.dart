import 'package:aplikasi_film/core/model/sewa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SewaFilmService {
  final CollectionReference rentals = FirebaseFirestore.instance.collection(
    'Sewa-Film',
  );

  Future<void> rentMovie(Sewa sewa) async {
    await rentals.add(sewa.toJson());
  }

  Future<List<Sewa>> getUserRentals(String userId) async {
    try {
      final querySnapshot = await rentals
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Sewa.fromJson(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
