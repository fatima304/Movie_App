import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsHelper {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      log('Analytics error: $e');
    }
  }

  /// Log screen view
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      log('Analytics error: $e');
    }
  }

  /// Log button click event
  static Future<void> logButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, Object>? additionalParameters,
  }) async {
    final parameters = <String, Object>{
      'button_name': buttonName,
      if (screenName != null) 'screen_name': screenName,
      ...?additionalParameters,
    };

    await logEvent(
      name: 'button_click',
      parameters: parameters,
    );
  }

  /// Log movie view event
  static Future<void> logMovieView({
    required int movieId,
    required String movieTitle,
  }) async {
    await logEvent(
      name: 'movie_view',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
      },
    );
  }

  /// Log movie details view event
  static Future<void> logMovieDetailsView({
    required int movieId,
    required String movieTitle,
    double? rating,
  }) async {
    await logEvent(
      name: 'movie_details_view',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
        if (rating != null) 'rating': rating,
      },
    );
  }

  /// Log load more movies event
  static Future<void> logLoadMoreMovies({
    required int page,
    required int totalMovies,
  }) async {
    await logEvent(
      name: 'load_more_movies',
      parameters: {
        'page': page,
        'total_movies': totalMovies,
      },
    );
  }

  /// Log theme toggle event
  static Future<void> logThemeToggle({
    required bool isDarkTheme,
  }) async {
    await logEvent(
      name: 'theme_toggle',
      parameters: {
        'is_dark_theme': isDarkTheme,
      },
    );
  }

  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      log('Analytics error: $e');
    }
  }

  static Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      log('Analytics error: $e');
    }
  }
}
