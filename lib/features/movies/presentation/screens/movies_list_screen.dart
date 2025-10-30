import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme_manager.dart';
import '../manager/cubit/movies_list_cubit.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/movie_card.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoviesListCubit>().fetchMovies();

  }

  void _toggleTheme(BuildContext context) async {
    final isDark = !ThemeManager.isDarkTheme;
    await ThemeManager.setDarkTheme(isDark);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MoviesListCubit, MoviesListState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Icon(Icons.movie, color: isDark ? Colors.white : Colors.black),
                const Text(
                  'Movies',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () => _toggleTheme(context),
                tooltip: isDark
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(MoviesListState state) {
    if (state is MoviesListLoading) {
      return const LoadingView();
    }

    if (state is MoviesListError) {
      return ErrorView(
        message: state.message,
        onRetry: () => context.read<MoviesListCubit>().fetchMovies(),
      );
    }

    if (state is MoviesListLoaded) {
      return Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return MovieCard(
                movie: movie,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.movieDetailsScreen,
                    arguments: movie,
                  );
                },
              );
            },
          ),
          if (state.hasMore || state is MoviesListLoadingMore)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: state is MoviesListLoadingMore
                      ? null
                      : () => context.read<MoviesListCubit>().loadMoreMovies(),
                  child: state is MoviesListLoadingMore
                      ? const LoadingView.compact()
                      : const Text('Load More Movies'),
                ),
              ),
            ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
