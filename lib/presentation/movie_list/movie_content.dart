import 'package:aplikasi_film/core/controller/movie_list_controller.dart';
import 'package:aplikasi_film/core/data/responses/movie_list_response.dart';
import 'package:aplikasi_film/core/data/state/remote_state.dart';
import 'package:aplikasi_film/presentation/widget/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MovieListContent extends StatefulWidget {
  const MovieListContent({super.key});

  @override
  State<MovieListContent> createState() => _MovieListContentState();
}

class _MovieListContentState extends State<MovieListContent> {
  final ScrollController _scrollController = ScrollController();

  MovieListController movieListController = Get.find();

  @override
  void initState() {
    _scrollController.addListener(_loadMoreMovies);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreMovies() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (movieListController.isSearching) {
        movieListController.searchMovie(
          movieListController.searchQuery,
          movieListController.currentPage + 1,
        );
      }
      movieListController.getMovieList(
        movieListController.selectedFilter,
        movieListController.currentPage + 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int currentCrossAxisCount = 2; // Default value
        if (constraints.maxWidth > 400) {
          currentCrossAxisCount = constraints.maxWidth ~/ 200;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fit Movies',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'Stay tuned with the latest movies',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // PinnedHeaderSliver(child: FloatingNavbar()),
              SliverToBoxAdapter(child: const SizedBox(height: 16)),

              SliverToBoxAdapter(
                child: Obx(() {
                  return GridView.builder(
                    shrinkWrap: true, // Important for nested scrollables
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: currentCrossAxisCount,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.7, // Adjust aspect ratio as needed
                    ),
                    itemCount: movieListController.movieList.length,
                    itemBuilder: (context, index) {
                      return MovieItem(
                        movie: movieListController.movieList[index],
                      );
                    },
                  );
                }),
              ),

              SliverToBoxAdapter(child: const SizedBox(height: 16)),

              SliverToBoxAdapter(
                child: Obx(() {
                  return switch (movieListController.pagingState) {
                    RemoteStateLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    RemoteStateError() => const Center(
                      child: Text(
                        "Error loading movies. Please try again later.",
                      ),
                    ),
                    _ => const SizedBox.shrink(),
                  };
                }),
              ),

              SliverToBoxAdapter(child: const SizedBox(height: 16)),
            ],
          ),
        );
      },
    );
  }
}

class MovieListBuilder extends StatelessWidget {
  final PagingState<int, Result> state;
  final Function() fetchNextPage;
  final int currentCrossAxisCount; // Default value, can be adjusted

  const MovieListBuilder({
    super.key,
    required this.state,
    required this.fetchNextPage,
    required this.currentCrossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, Result>(
      state: state,
      fetchNextPage: fetchNextPage,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: currentCrossAxisCount,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.7, // Adjust aspect ratio as needed
      ),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) => MovieItem(movie: item),
      ),
    );
  }
}
