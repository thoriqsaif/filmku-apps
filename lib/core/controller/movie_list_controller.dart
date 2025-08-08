import 'package:aplikasi_film/core/controller/movie_filter.dart';
import 'package:aplikasi_film/core/data/network/dio_api_client.dart';
import 'package:aplikasi_film/core/data/responses/movie_list_response.dart';
import 'package:aplikasi_film/core/data/service/movie_detail.dart';
import 'package:aplikasi_film/core/data/service/movie_service.dart';
import 'package:aplikasi_film/core/data/service/search_service.dart';
import 'package:aplikasi_film/core/data/state/remote_state.dart';
import 'package:get/get.dart';

class MovieListController extends GetxController {
  final MovieService movieService;

  MovieListController({required this.movieService});

  final SearchService searchService = Get.put(SearchService());

  final Rx<RemoteState> _pagingState = Rx<RemoteState>(RemoteStateNone());

  get pagingState => _pagingState.value;

  final RxInt _currentPage = 1.obs;

  get currentPage => _currentPage.value;

  final Rx<List<Result>> _movieList = Rx<List<Result>>([]);

  get movieList => _movieList.value;

  Future<List<Result>> getMovieList(String filter, int page) async {
    try {
      if (_pagingState.value is RemoteStateLoading) {
        return _movieList.value; // Return current list if already loading
      }

      _pagingState.value = RemoteStateLoading();

      final result = await movieService.fetchMovies(filter, page);

      if (result.results.isEmpty) {
        _pagingState.value = RemoteStateError('No more movies found');
      } else {
        _pagingState.value = RemoteStateSuccess<MovieListResponse>(result);

        _currentPage.value = result.page;
        _movieList.value = _movieList.value + result.results;
      }

      return result.results;
    } on Exception catch (e) {
      _pagingState.value = RemoteStateError(e.toString());
      rethrow;
    }
  }

  final Rx<Genre?> selectedGenre = Rx<Genre?>(null);

  // Tambahkan fungsi setGenreFilter & fetchMoviesByGenre ini
  void setGenreFilter(Genre genre) {
    _selectedFilter.value = MovieFilter.genres.name;
    selectedGenre.value = genre;

    _movieList.value = [];
    _currentPage.value = 1;
    _pagingState.value = RemoteStateNone();

    fetchMoviesByGenre(genre.id, _currentPage.value);
  }

  Future<List<Result>> fetchMoviesByGenre(int genreId, int page) async {
    try {
      if (_pagingState.value is RemoteStateLoading) {
        return _movieList.value; // Prevent duplicate fetch
      }

      _pagingState.value = RemoteStateLoading();

      final response = await DioApiClient().dio.get(
        '/discover/movie',
        queryParameters: {
          'with_genres': genreId.toString(),
          'page': page.toString(),
        },
      );

      final List data = response.data['results'];
      final List<Result> results = data.map((e) => Result.fromJson(e)).toList();

      if (results.isEmpty) {
        _pagingState.value = RemoteStateError('No more movies found');
      } else {
        _pagingState.value = RemoteStateSuccess<List<Result>>(results);
        _currentPage.value = response.data['page'];
        _movieList.value = _movieList.value + results;
      }

      return results;
    } catch (e) {
      _pagingState.value = RemoteStateError(e.toString());
      rethrow;
    }
  }

  /// **
  /// Filter movie business logic ###############################################
  /// **

  final RxString _selectedFilter = MovieFilter.nowPlaying.name.obs;

  get selectedFilter => _selectedFilter.value;

  setFilter(MovieFilter filter) {
    if (_selectedFilter.value != filter.name) {
      if (!filter.name.contains('@')) {
        _movieList.value = [];
        _currentPage.value = 1;
        _pagingState.value = RemoteStateNone();
        getMovieList(filter.name, _currentPage.value);
      }
      _selectedFilter.value = filter.name;
    }
  }

  /// **
  /// Search business logic ###############################################
  /// **

  final RxBool _isSearching = false.obs;

  get isSearching => _isSearching.value;

  setIsSearching(bool value) {
    _isSearching.value = value;
    if (!value) {
      _searchQuery.value = '';
      _movieList.value = [];
      _currentPage.value = 1;
      _pagingState.value = RemoteStateNone();
      getMovieList(_selectedFilter.value, _currentPage.value);
    }
  }

  final RxString _searchQuery = ''.obs;

  get searchQuery => _searchQuery.value;

  setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  Future<List<Result>> searchMovie(String query, int page) async {
    try {
      if (_pagingState.value is RemoteStateLoading) {
        return _movieList.value; // Return current list if already loading
      }

      _pagingState.value = RemoteStateLoading();

      if (page == 1) _movieList.value = [];

      final result = await searchService.searchMovies(query, page);

      if (result.results.isEmpty) {
        _pagingState.value = RemoteStateError('No more movies found');
      } else {
        _pagingState.value = RemoteStateSuccess<MovieListResponse>(result);

        _currentPage.value = result.page;
        _movieList.value = _movieList.value + result.results;
      }

      return result.results;
    } on Exception catch (e) {
      _pagingState.value = RemoteStateError(e.toString());
      rethrow;
    }
  }

  //   void setGenreFilter(Genre genre) {
  //     selectedFilter.value = MovieFilter.genres.name;
  //     fetchMoviesByGenre(genre.id);
  //   }

  // void fetchMoviesByGenre(int genreId) async {
  //   // Fetch movie list based on genreId
  // }
}
