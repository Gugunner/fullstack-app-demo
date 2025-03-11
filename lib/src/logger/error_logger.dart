
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/network/app_exception.dart';

/// A class that logs errors and exceptions in the app.
/// This class will later be inyected with a the FirebaseCrashlytics instance.
class ErrorLogger {
  //TODO: Add a FirebaseCrashlytics instance to the ErrorLogger class
  void logError(Object error, StackTrace? stackTrace) {
    // * This can be replaced with a call to a crash reporting tool of choice
    debugPrint('$error, $stackTrace');
  }

  void logAppException(AppException exception) {
    // * This can be replaced with a call to a crash reporting tool of choice
    debugPrint('$exception');
  }
}


//TODO: Add a FirebaseCrashlytics provider

final errorLoggerProvider = Provider<ErrorLogger>((ref) {
  return ErrorLogger();
});
