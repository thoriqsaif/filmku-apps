enum NavigationRoutes {
  signin(name: '/signin'),
  register(name: '/register'),
  movieList(name: '/movie/list'),
  movieDetail(name: '/movie/detail'),
  rentMovie(name: '/movie/rent');

  const NavigationRoutes({required this.name});
  final String name;
}
