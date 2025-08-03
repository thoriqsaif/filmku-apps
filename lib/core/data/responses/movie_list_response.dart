import 'dart:convert';

MovieListResponse movieListResponseFromJson(String str) =>
    MovieListResponse.fromJson(json.decode(str));

String movieListResponseToJson(MovieListResponse data) =>
    json.encode(data.toJson());

class MovieListResponse {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  MovieListResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      MovieListResponse(
        page: json["page"] ?? 0,
        results: List<Result>.from(
          json["results"].map((x) => Result.fromJson(x)),
        ),
        totalPages: json["total_pages"] ?? 0,
        totalResults: json["total_results"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({required this.maximum, required this.minimum});

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    maximum: DateTime.parse(json["maximum"]),
    minimum: DateTime.parse(json["minimum"]),
  );

  Map<String, dynamic> toJson() => {
    "maximum":
        "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
    "minimum":
        "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
  };
}

class Result {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    adult: json["adult"] ?? false,
    backdropPath: json["backdrop_path"] ?? '',
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"] ?? 0,
    originalLanguage: json["original_language"] ?? '',
    originalTitle: json["original_title"] ?? '',
    overview: json["overview"] ?? '',
    popularity: json["popularity"]?.toDouble() ?? 0.0,
    posterPath: json["poster_path"] ?? '',
    releaseDate: json["release_date"].toString().isNotEmpty
        ? DateTime.parse(json["release_date"])
        : DateTime.now(),
    title: json["title"] ?? '',
    video: json["video"] ?? false,
    voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
    voteCount: json["vote_count"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "release_date":
        "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}
