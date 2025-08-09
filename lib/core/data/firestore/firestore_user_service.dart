import 'package:aplikasi_film/core/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreUserService {
  final _userRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserData>(
        fromFirestore: (snapshots, _) => UserData.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  Future<void> addCurrentUser(UserData user) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await _userRef.doc(uid).set(user.copyWith(userId: uid));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUser(UserData user) async {
    try {
      await _userRef.doc(user.userId).set(user.toJson() as UserData);
    } catch (e) {
      rethrow;
    }
  }
}
