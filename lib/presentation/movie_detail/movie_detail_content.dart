import 'package:aplikasi_film/core/controller/rental_controller.dart';
import 'package:aplikasi_film/core/data/network/dio_api_client.dart';
import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MovieDetailContent extends StatelessWidget {
  final MovieDetailResponse movieDetail;
  final RentalController rentalController = Get.find<RentalController>();

  MovieDetailContent({super.key, required this.movieDetail});

  static final DateFormat formatter = DateFormat("dd MMMM yyyy");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Hero(
                          tag: movieDetail.id,
                          child: Image.network(
                            "$imageUrl/${movieDetail.backdropPath}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox.square(dimension: 16),
            Text(
              movieDetail.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox.square(dimension: 4),
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.red),
                const SizedBox.square(dimension: 4),
                Text(
                  movieDetail.originCountry.isNotEmpty
                      ? movieDetail.originCountry[0]
                      : "-",
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  ", ${formatter.format(movieDetail.releaseDate)}",
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox.square(dimension: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox.square(dimension: 4),
                Expanded(
                  child: Text(
                    movieDetail.popularity.toString(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox.square(dimension: 16),
            Text(
              "Description:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox.square(dimension: 8),
            Text(
              movieDetail.overview,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
            const SizedBox.square(dimension: 16),
            Row(
              children: [
                Text(
                  "Categories:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieDetail.genres.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Chip(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            label: Text("#${movieDetail.genres[index].name}"),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox.square(dimension: 16),
            Text("Languages:", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox.square(dimension: 4),
            ListView.builder(
              padding: const EdgeInsets.all(4),
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movieDetail.spokenLanguages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text("- ${movieDetail.spokenLanguages[index].name}"),
                );
              },
            ),
            const SizedBox.square(dimension: 16),
            Text("Countries:", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox.square(dimension: 4),
            ListView.builder(
              padding: const EdgeInsets.all(4),
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movieDetail.productionCountries.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "- ${movieDetail.productionCountries[index].name}",
                  ),
                );
              },
            ),
            const SizedBox.square(dimension: 16),
            Text(
              "Producer Companies:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox.square(dimension: 4),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movieDetail.productionCompanies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "- ${movieDetail.productionCompanies[index].name}",
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Sewa Film"),
                onPressed: () {
                  rentalController.goToSewaPage(
                    movieDetail.id,
                    movieDetail.title,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
