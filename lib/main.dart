import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/core/controller/genre_controller.dart';
import 'package:aplikasi_film/core/controller/rental_controller.dart';
import 'package:aplikasi_film/core/controller/user_controller.dart';
import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_sewa_service.dart';
import 'package:aplikasi_film/core/data/firestore/firestore_user_service.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:aplikasi_film/firebase_options.dart';
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

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable Firestore offline mode
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  // Register dependencies using GetX (Dependency Injection)
  Get.put(GenreController());
  Get.put(AuthController(Get.put(FirebaseAuthService())));
  Get.put(UserController(Get.put(FirestoreUserService())));
  Get.put(SewaFilmService());
  Get.put(RentalController(SewaFilmService()));
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
          return MaterialApp(
            title: 'Cari Film FavoritMu!',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            themeMode: ThemeMode.system,
            initialRoute: snapshot.data != null
                ? NavigationRoutes.movieList.name
                : NavigationRoutes.signin.name,
            routes: {
              NavigationRoutes.signin.name: (_) => SignInScreen(),
              NavigationRoutes.register.name: (_) => RegisterScreen(),
              NavigationRoutes.movieList.name: (_) => MovieListScreen(),
              NavigationRoutes.movieDetail.name: (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                final movieId = args is int ? args : 0;

                return MovieDetailScreen(movieId: movieId);
              },
              NavigationRoutes.sewaFilm.name: (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
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
              // NavigationRoutes.favourite.name: (_) => FavouriteMovieScreen(),
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
