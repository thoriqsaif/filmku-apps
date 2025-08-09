import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/core/controller/genre_controller.dart';
import 'package:aplikasi_film/core/controller/rental_controller.dart';
import 'package:aplikasi_film/core/controller/user_controller.dart';
import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_sewa_service.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_user_service.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:aplikasi_film/presentation/movie_detail/movie_detail_screen.dart';
import 'package:aplikasi_film/presentation/movie_list/movie_list.dart';
import 'package:aplikasi_film/presentation/register_screen/register_screen.dart';
import 'package:aplikasi_film/presentation/sewa_screen/sewa_film.dart';
import 'package:aplikasi_film/presentation/signin_screen/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load .env
  await dotenv.load(fileName: ".env");

  // Firestore offline mode
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  // Dependency Injection GetX
  Get.put(GenreController());
  Get.put<FirebaseAuthService>(FirebaseAuthService());
  Get.put<AuthController>(AuthController(Get.find<FirebaseAuthService>()));
  Get.put(FirestoreUserService());
  Get.put(UserController(Get.find<FirestoreUserService>()));
  Get.put(SewaFilmService());
  Get.put(RentalController(Get.find<SewaFilmService>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final signInState = authController.checkUserSignInState();

    return StreamBuilder<User?>(
      stream: signInState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cari Film FavoritMu!',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            themeMode: ThemeMode.system,
            initialRoute: snapshot.data != null
                ? NavigationRoutes.movieList.name
                : NavigationRoutes.signin.name,
            getPages: [
              GetPage(
                name: NavigationRoutes.signin.name,
                page: () => SignInScreen(),
              ),
              GetPage(
                name: NavigationRoutes.register.name,
                page: () => RegisterScreen(),
              ),
              GetPage(
                name: NavigationRoutes.movieList.name,
                page: () => MovieListScreen(),
              ),
              GetPage(
                name: NavigationRoutes.movieDetail.name,
                page: () {
                  final args = Get.arguments;
                  final movieId = args is int ? args : 0;
                  return MovieDetailScreen(movieId: movieId);
                },
              ),
              GetPage(
                name: NavigationRoutes.sewaFilm.name,
                page: () {
                  final args = Get.arguments;
                  if (args is Map<String, dynamic>) {
                    return SewaFilm(
                      movieId: args['movieId'],
                      title: args['title'],
                    );
                  }
                  return const Scaffold(
                    body: Center(child: Text('Data film tidak valid')),
                  );
                },
              ),
            ],
          );
        }

        return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}
