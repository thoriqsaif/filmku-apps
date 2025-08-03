import 'package:aplikasi_film/core/data/network/dio_api_client.dart';
import 'package:aplikasi_film/core/data/responses/movie_list_response.dart';
import 'package:aplikasi_film/core/navigation/navigation_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieItem extends StatelessWidget {
  final Result movie;

  const MovieItem({super.key, required this.movie});

  static final DateFormat formatter = DateFormat("dd MMMM yyyy");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          NavigationRoutes.movieDetail.name,
          arguments: movie.id,
        );
      },
      child: Card(
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Hero(
                tag: movie.id,
                child: Image.network(
                  '$imageUrl${movie.posterPath}',
                  fit: BoxFit.fill,
                  color: Colors.black.withValues(alpha: 100),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),

            MovieShortInfoView(movie: movie),
          ],
        ),
      ),
    );
  }
}

class MovieShortInfoView extends StatelessWidget {
  final Result movie;

  const MovieShortInfoView({super.key, required this.movie});

  static final DateFormat formatter = DateFormat("dd MMMM yyyy");

  BoxDecoration _gradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.0, 0.7, 0.7],
        colors: [Colors.black, Colors.transparent, Colors.transparent],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: _gradientBackground(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              formatter.format(movie.releaseDate),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
