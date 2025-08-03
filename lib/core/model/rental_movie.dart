class RentalMovie {
  final int id;
  final String title;
  final String releaseDate;
  final String posterPath;

  RentalMovie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.posterPath,
  });

  factory RentalMovie.fromJson(Map<String, dynamic> json) => RentalMovie(
    id: json["movie_id"],
    title: json["movie_title"],
    releaseDate: json["release_date"],
    posterPath: json["poster_path"],
  );

  Map<String, dynamic> toJson() => {
    "movie_id": id,
    "movie_title": title,
    "release_date": releaseDate,
    "poster_path": posterPath,
  };
}
