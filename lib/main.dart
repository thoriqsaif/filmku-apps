import 'package:aplikasi_film/core/binding/bindings.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:aplikasi_film/presentation/movie_detail/movie_detail_screen.dart';
import 'package:aplikasi_film/presentation/movie_list/movie_list.dart';
import 'package:aplikasi_film/presentation/register_screen/register_screen.dart';
import 'package:aplikasi_film/presentation/sewa_screen/sewa_film.dart';
import 'package:aplikasi_film/presentation/signin_screen/signin_screen.dart';
import 'package:aplikasi_film/presentation/widget/lottie_screen.dart';
import 'package:aplikasi_film/presentation/widget/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cari Film FavoritMu!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const BounceSplashScreen(),
      initialBinding: AppBindings(), // ✅ semua dependency di sini
      getPages: [
        GetPage(name: NavigationRoutes.signin.name, page: () => SignInScreen()),
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
                movieId: args['movieId'].toString(),
                title: args['title'],
              );
            }
            return const Scaffold(
              body: Center(child: Text('Data film tidak valid')),
            );
          },
        ),
        GetPage(
          name: '/loadingAnimation',
          page: () => const LoadingAnimationScreen(),
        ),
      ],
    );
  }
}
