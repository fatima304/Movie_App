import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/dependency_injection.dart';
import 'core/routes/app_routing.dart';
import 'core/routes/routes.dart';
import 'core/theme/theme_manager.dart';
import 'core/utils/crashlytics_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and Crashlytics (optional)
  try {
    await Firebase.initializeApp();
    await CrashlyticsHelper.init();
  } catch (e) {
    // Firebase is optional - app will work without it
    debugPrint('Firebase/Crashlytics is not configured (optional feature)');
  }

  // Initialize Theme Manager
  await ThemeManager.init();

  // Setup dependency injection
  await setupServiceLocator();

  runApp(const MovieApp());
}

class MovieApp extends StatefulWidget {
  const MovieApp({super.key});

  @override
  State<MovieApp> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    // Listen for theme changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeManager.themeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'Movies App',
          debugShowCheckedModeBanner: false,
          theme: ThemeManager.lightTheme,
          darkTheme: ThemeManager.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          onGenerateRoute: AppRouting().generateRoute,
          initialRoute: Routes.moviesListScreen,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
        );
      },
    );
  }
}
