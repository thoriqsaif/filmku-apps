import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/core/controller/genre_controller.dart';
import 'package:aplikasi_film/core/controller/movie_list_controller.dart';
import 'package:aplikasi_film/core/controller/password_rive_controller.dart';
import 'package:aplikasi_film/core/controller/rental_controller.dart';
import 'package:aplikasi_film/core/controller/sign_in_controller.dart';
import 'package:aplikasi_film/core/controller/user_controller.dart';
import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_sewa_service.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_user_service.dart';
import 'package:aplikasi_film/core/data/service/movie_service.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Service
    Get.put<MovieService>(MovieService());
    Get.put<GenreController>(GenreController());
    Get.put<FirebaseAuthService>(FirebaseAuthService());
    Get.put<FirestoreUserService>(FirestoreUserService());
    Get.put<SewaFilmService>(SewaFilmService());

    // Controller
    Get.put<MovieListController>(
      MovieListController(movieService: Get.find<MovieService>()),
    );
    Get.put<AuthController>(AuthController(Get.find<FirebaseAuthService>()));
    Get.put<UserController>(UserController(Get.find<FirestoreUserService>()));
    Get.put<RentalController>(RentalController(Get.find<SewaFilmService>()));

    // UI State Controller
    Get.put(SignInController());
    Get.put(PasswordRiveController());
  }
}
