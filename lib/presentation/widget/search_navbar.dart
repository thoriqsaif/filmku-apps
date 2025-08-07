import 'package:aplikasi_film/core/controller/movie_filter.dart';
import 'package:aplikasi_film/core/controller/movie_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingSearchBar extends StatefulWidget {
  const FloatingSearchBar({super.key});

  @override
  State<FloatingSearchBar> createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends State<FloatingSearchBar> {
  MovieListController movieListController = Get.find();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      if (movieListController.isSearching) {
        searchController.text = movieListController.searchQuery;
      } else {
        searchController.clear();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration.collapsed(
              hintText: 'Silahkan Cari Film Favoritmu',
            ),
            onChanged: (text) {
              movieListController.setSearchQuery(text);
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.send, color: Colors.cyan),
          onPressed: () {
            if (movieListController.searchQuery.isNotEmpty == true) {
              movieListController.searchMovie(
                movieListController.searchQuery,
                movieListController.currentPage,
              );
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.cyan),
          onPressed: () {
            movieListController.setIsSearching(false);
            movieListController.setFilter(MovieFilter.nowPlaying);
          },
        ),
      ],
    );
  }
}
