import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia_220083/domain/entities/movie.dart';
import 'package:cinemapedia_220083/presentation/providers/movies/movies_repository_provider.dart';

// 🔹 Provider del query actual de búsqueda (Riverpod 3.x)
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String newQuery) {
    state = newQuery;
  }
}

// 🔹 Provider principal de películas buscadas
final searchedMoviesProvider = NotifierProvider<SearchedMoviesNotifier, List<Movie>>(
  SearchedMoviesNotifier.new,
);

// 🔹 Definición del tipo callback
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

// 🔹 Notifier para búsqueda de películas (Riverpod 3.x)
class SearchedMoviesNotifier extends Notifier<List<Movie>> {
  late final SearchMoviesCallback searchMovies;

  @override
  List<Movie> build() {
    // Se obtiene el repositorio dentro del método build()
    final moviesRepository = ref.watch(movieRepositoryProvider);
    searchMovies = moviesRepository.searchMovies;

    // Estado inicial vacío
    return [];
  }

  // 🔹 Método para buscar películas por query
  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    
    // Actualiza el query actual
    ref.read(searchQueryProvider.notifier).update(query);
    
    // Actualiza el estado con las películas encontradas
    state = movies;
    
    return movies;
  }
}