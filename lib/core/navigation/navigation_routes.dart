enum NavigationRoutes {
  signin(name: '/signin'),
  register(name: '/register'),
  movieList(name: '/movie/list'),
  movieDetail(name: '/movie/detail'),
  buyMovie(name: '/movie/buy');

  const NavigationRoutes({required this.name});
  final String name;
}
