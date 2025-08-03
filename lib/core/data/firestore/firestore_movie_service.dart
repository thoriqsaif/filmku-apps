import 'package:aplikasi_film/core/model/rental_movie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreMovieService {
  final _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  late final _currentUserRef = FirebaseFirestore.instance
      .collection('users')
      .doc(_currentUserId);

  late final _moviesRef = _currentUserRef
      .collection('Rental-Movies')
      .withConverter<RentalMovie>(
        fromFirestore: (snapshots, _) =>
            RentalMovie.fromJson(snapshots.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  Future addRentalMovie(RentalMovie movie) async {
    await _moviesRef.doc(movie.id.toString()).set(movie);
  }

  Future removeRentalMovie(int movieId) async {
    await _moviesRef.doc(movieId.toString()).delete();
  }

  Future<bool> isRented(int movieId) async {
    final result = await _moviesRef.doc(movieId.toString()).get();
    return result.exists;
  }

  Future<List<RentalMovie>> getAllRentalMovies() async {
    final dataSnapshot = await _moviesRef.get();

    return dataSnapshot.docs.map((doc) => doc.data()).toList();
  }

  //For real-time favourite movie list
  Stream<QuerySnapshot> getAllMoviesRealTime() {
    return _moviesRef.snapshots();
  }
}
