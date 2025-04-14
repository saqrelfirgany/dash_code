import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dash_code/core/firebase/report_error.dart';
import 'package:dash_code/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/dependency_injection/configure_dependencies.dart';
import 'core/theme/app_theme.dart';
import 'features/splash_feature/presentation/splash_screen.dart';

// Global navigator key to allow tracking/navigating from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Commands for build_runner (code generation)
// flutter packages pub run build_runner build
// flutter packages pub run build_runner watch
// dart run build_runner build

/// Sets up dependency injection required by the app.
Future<void> setupDependencies() async {
  await configureDependencies();
}

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the current platform's options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Crashlytics collection explicitly
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // FirebaseCrashlytics.instance.crash();
  // Set Crashlytics to record any uncaught Flutter errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Capture any errors from the PlatformDispatcher and send them to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    reportError(error, stack);
    return true;
  };

  // Initialize Firebase Analytics (instance can be used later to log events)
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Retrieve the saved theme (if any) and set up dependencies
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await setupDependencies();

  // Run the app
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

/// Main application widget
class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      // Light theme configuration
      light: AppTheme.lightTheme,
      // Dark theme configuration
      dark: AppTheme.darkTheme,
      // Use saved theme mode or default to light
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        navigatorKey: navigatorKey, // Global key for navigation
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 600, name: MOBILE),
            const Breakpoint(start: 601, end: 1200, name: TABLET),
            const Breakpoint(start: 1201, end: 1920, name: DESKTOP),
          ],
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
