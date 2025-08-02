import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:aplikasi_film/firebase_options.dart';
import 'package:aplikasi_film/presentation/register_screen/register_screen.dart';
import 'package:aplikasi_film/presentation/signin_screen/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase instance
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // enable firestore offline mode
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilih Film Favoritmu!',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      initialRoute: NavigationRoutes.signin.name,
      routes: {
        NavigationRoutes.signin.name: (context) => SignInScreen(),
        NavigationRoutes.register.name: (context) => RegisterScreen(),
        //   NavigationRoutes.movieList.name: (context) => MovieListScreen(),
        //   NavigationRoutes.movieDetail.name: (context) => MovieDetailScreen(
        //         movieId: ModalRoute.of(context)?.settings.arguments as int,
        //       ),
        //   NavigationRoutes.favourite.name: (context) => FavouriteMovieScreen(),
      },
    );
  }
}
