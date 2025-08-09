import 'package:cloud_firestore/cloud_firestore.dart';

class Sewa {
  final String? id;
  final String userId;
  final String movieId;
  final String title;
  final int rentalDays;
  final DateTime rentDate;
  final DateTime returnDate;
  final int totalPrice;

  // harga per hari (bisa diubah sesuai kebutuhan)
  static const int pricePerDay = 5000;

  Sewa({
    this.id,
    required this.userId,
    required this.movieId,
    required this.title,
    required this.rentalDays,
    required this.rentDate,
    required this.returnDate,
    required this.totalPrice,
  });

  /// Factory untuk membuat object dari data mentah, menghitung totalPrice otomatis
  factory Sewa.create({
    required String userId,
    required String movieId,
    required String title,
    required int rentalDays,
    required DateTime rentDate,
  }) {
    final returnDate = rentDate.add(Duration(days: rentalDays));
    final totalPrice = rentalDays * pricePerDay;

    return Sewa(
      userId: userId,
      movieId: movieId,
      title: title,
      rentalDays: rentalDays,
      rentDate: rentDate,
      returnDate: returnDate,
      totalPrice: totalPrice,
    );
  }

  /// Convert to JSON (untuk Firebase)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'movieId': movieId,
      'title': title,
      'rentalDays': rentalDays,
      'rentDate': Timestamp.fromDate(rentDate),
      'returnDate': Timestamp.fromDate(returnDate),
      'totalPrice': totalPrice,
    };
  }

  /// Convert from JSON (for Firebase) + document ID
  factory Sewa.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Sewa(
      id: doc.id,
      userId: data['userId'],
      movieId: data['movieId'],
      title: data['title'],
      rentalDays: data['rentalDays'],
      rentDate: (data['rentDate'] as Timestamp).toDate(),
      returnDate: (data['returnDate'] as Timestamp).toDate(),
      totalPrice: data['totalPrice'],
    );
  }
}
