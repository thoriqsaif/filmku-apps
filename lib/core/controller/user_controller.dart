import 'package:aplikasi_film/core/data/firestore/firestore_user_service.dart';
import 'package:aplikasi_film/core/model/user_data.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirestoreUserService _userService;
  UserController(this._userService);

  Future<void> addUser(UserData user) => _userService.addUser(user);
}
