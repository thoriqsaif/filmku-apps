import 'package:aplikasi_film/core/data/firestore/firestore_user_service.dart';
import 'package:aplikasi_film/core/model/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirestoreUserService _userService;
  UserController(this._userService);

  /// Simpan user yang sedang login ke Firestore
  Future<void> addUser(UserData user) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        throw Exception('User belum login. UID tidak tersedia.');
      }

      final userWithId = user.copyWith(userId: uid);
      await _userService.addUser(userWithId);
    } catch (e) {
      rethrow;
    }
  }
}
