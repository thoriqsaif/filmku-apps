import 'package:aplikasi_film/core/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserService {
  final _userRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserData>(
        fromFirestore: (snapshots, _) => UserData.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  Future addUser(UserData user) async {
    await _userRef.doc(user.userId).set(user);
  }
}
