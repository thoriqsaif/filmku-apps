enum NavigationRoutes {
  signin(name: '/signin'),
  register(name: '/register'),
  movieList(name: '/movie/list'),
  movieDetail(name: '/movie/detail'),
  sewaFilm(name: '/movie/sewa');

  const NavigationRoutes({required this.name});
  final String name;
}
