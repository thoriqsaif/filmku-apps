import 'package:aplikasi_film/core/data/responses/movie_detail_response.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:flutter/material.dart';

class SewaFilmButton extends StatelessWidget {
  final MovieDetailResponse movie;

  const SewaFilmButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(
            context,
            NavigationRoutes.sewaFilm.name,
            arguments: movie.id,
          );
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text("Sewa Film"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
