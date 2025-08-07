import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/core/controller/genre_controller.dart';
import 'package:aplikasi_film/core/data/auth/firebase_auth.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:aplikasi_film/firebase_options.dart';
import 'package:aplikasi_film/presentation/movie_list/movie_list.dart';
import 'package:aplikasi_film/presentation/register_screen/register_screen.dart';
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

  // Initialize Firebase instance
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // enable firestore offline mode
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  // Register GenreController globally with GetX
  Get.put(GenreController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  var initialRoute = NavigationRoutes.signin.name;
  final AuthController authController = Get.put(
    AuthController(Get.put(FirebaseAuthService())),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
              NavigationRoutes.signin.name: (context) => SignInScreen(),
              NavigationRoutes.register.name: (context) => RegisterScreen(),
              NavigationRoutes.movieList.name: (context) => MovieListScreen(),
              // NavigationRoutes.movieDetail.name: (context) =>
              //     MovieDetailScreen(
              //       movieId:
              //           ModalRoute.of(context)?.settings.arguments as int,
              //     ),
              // NavigationRoutes.favourite.name: (context) =>
              //     FavouriteMovieScreen(),
            },
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
