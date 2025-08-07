import 'package:aplikasi_film/core/controller/auth_controller.dart';
import 'package:aplikasi_film/core/controller/genre_controller.dart';
import 'package:aplikasi_film/core/controller/movie_filter.dart';
import 'package:aplikasi_film/core/controller/movie_list_controller.dart';
import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainMenuNavbar extends StatefulWidget {
  const MainMenuNavbar({super.key});

  @override
  State<MainMenuNavbar> createState() => _MainMenuNavbarState();
}

class _MainMenuNavbarState extends State<MainMenuNavbar> {
  MovieListController movieListController = Get.find();
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() {
            return TextButton(
              onPressed: () {
                movieListController.setFilter(MovieFilter.nowPlaying);
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color:
                          movieListController.selectedFilter ==
                              MovieFilter.nowPlaying.name
                          ? Colors.cyan
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              child: Text('Now Playing'),
            );
          }),
          Obx(() {
            return TextButton(
              onPressed: () {
                movieListController.setFilter(MovieFilter.popular);
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color:
                          movieListController.selectedFilter ==
                              MovieFilter.popular.name
                          ? Colors.cyan
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              child: Text('Popular'),
            );
          }),
          Obx(() {
            return TextButton(
              onPressed: () {
                movieListController.setFilter(MovieFilter.topRated);
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color:
                          movieListController.selectedFilter ==
                              MovieFilter.topRated.name
                          ? Colors.cyan
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              child: Text('Top Rated'),
            );
          }),
          Obx(() {
            final genres = Get.find<GenreController>().genres;
            return PopupMenuButton<Genre>(
              onSelected: (Genre genre) {
                movieListController.setGenreFilter(genre);
              },
              itemBuilder: (BuildContext context) {
                return genres.map((genre) {
                  return PopupMenuItem<Genre>(
                    value: genre,
                    child: Text(genre.name),
                  );
                }).toList();
              },
              child: TextButton(
                onPressed: null,
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color:
                            movieListController.selectedFilter ==
                                MovieFilter.genres.name
                            ? Colors.cyan
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                child: Text('Genres'),
              ),
            );
          }),
          // Obx(() {
          //   return IconButton(
          //     icon: Icon(
          //         movieListController.selectedFilter ==
          //                 MovieFilter.favourite.name
          //             ? Icons.favorite
          //             : Icons.favorite_border,
          //         color: Colors.cyan),
          //     onPressed: () {
          //       movieListController.setFilter(MovieFilter.favourite);
          //       Navigator.pushNamed(context, NavigationRoutes.favourite.name);
          //     },
          //   );
          // }),
          IconButton(
            icon: Icon(Icons.search, color: Colors.cyan),
            onPressed: () {
              movieListController.setIsSearching(true);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.cyan),
            onPressed: () {
              authController.signOut();
              Navigator.pushReplacementNamed(
                context,
                NavigationRoutes.signin.name,
              );
            },
          ),
        ],
      ),
    );
  }
}
