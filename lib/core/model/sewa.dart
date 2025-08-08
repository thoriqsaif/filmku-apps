class Sewa {
  final String userId;
  final String movieId;
  final String title;
  final int rentalDays;
  final DateTime rentDate;
  final DateTime returnDate;
  final int totalPrice;

  Sewa({
    required this.userId,
    required this.movieId,
    required this.title,
    required this.rentalDays,
    required this.rentDate,
    required this.returnDate,
    required this.totalPrice,
  });

  /// Convert to JSON (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'movieId': movieId,
      'title': title,
      'rentalDays': rentalDays,
      'rentDate': rentDate.toIso8601String(),
      'returnDate': returnDate.toIso8601String(),
      'totalPrice': totalPrice,
    };
  }

  /// Convert from JSON (for Firebase)
  factory Sewa.fromJson(Map<String, dynamic> json) {
    return Sewa(
      userId: json['userId'] as String,
      movieId: json['movieId'] as String,
      title: json['title'] as String,
      rentalDays: json['rentalDays'] as int,
      rentDate: DateTime.parse(json['rentDate']),
      returnDate: DateTime.parse(json['returnDate']),
      totalPrice: json['totalPrice'] as int,
    );
  }

  /// Optional: toMap (mirip dengan toJson, jika butuh Map saja)
  Map<String, dynamic> toMap() {
    return toJson(); // bisa pakai langsung toJson jika sama
  }
}
