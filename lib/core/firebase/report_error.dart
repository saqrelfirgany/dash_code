import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void reportError(dynamic error, StackTrace stackTrace, {bool fatal = false}) {
  FirebaseCrashlytics.instance.recordError(
    error,
    stackTrace,
    fatal: fatal,
    printDetails: true,
  );
}