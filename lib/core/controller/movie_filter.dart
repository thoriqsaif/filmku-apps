enum MovieFilter {
  nowPlaying(name: 'now_playing'),
  popular(name: 'popular'),
  topRated(name: 'top_rated'),
  releaseDate(name: 'release_date'),
  genres(name: 'genres'),
  search(name: 'search');

  const MovieFilter({required this.name});
  final String name;
}
