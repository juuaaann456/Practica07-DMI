import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia_220083/domain/entities/movie.dart';
import 'package:cinemapedia_220083/presentation/providers/movies/movies_repository_provider.dart';

// 🔹 Definición del tipo de callback
typedef MovieCallback = Future<List<Movie>> Function({int page});

// 🔹 Notifier genérico
class MoviesNotifier extends Notifier<List<Movie>> {
  late final MovieCallback fetchMoreMovies;
  int currentPage = 0;
  bool isLoading = false;

  MoviesNotifier({required this.fetchMoreMovies});

  @override
  List<Movie> build() => [];

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    currentPage++;
    final movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];

    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}

// 🔹 Providers individuales (sin auto-referencias)
final nowPlayingMoviesProvider =
    NotifierProvider<MoviesNotifier, List<Movie>>(() {
  final repo = ProviderContainer().read(movieRepositoryProvider);
  return MoviesNotifier(fetchMoreMovies: repo.getNowPlaying);
});

final popularMoviesProvider =
    NotifierProvider<MoviesNotifier, List<Movie>>(() {
  final repo = ProviderContainer().read(movieRepositoryProvider);
  return MoviesNotifier(fetchMoreMovies: repo.getPopular);
});

final upcomingMoviesProvider =
    NotifierProvider<MoviesNotifier, List<Movie>>(() {
  final repo = ProviderContainer().read(movieRepositoryProvider);
  return MoviesNotifier(fetchMoreMovies: repo.getUpcoming);
});

final topRatedMoviesProvider =
    NotifierProvider<MoviesNotifier, List<Movie>>(() {
  final repo = ProviderContainer().read(movieRepositoryProvider);
  return MoviesNotifier(fetchMoreMovies: repo.getTopRated);
});
