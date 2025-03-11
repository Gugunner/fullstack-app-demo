
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/logger/error_logger.dart';
import 'package:piix_mobile/src/network/app_exception.dart';

/// Error logger class to keep track of all AsyncError states that are set
/// by the controllers in the app
class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final errorLogger = container.read(errorLoggerProvider);
    // Finds the error in the newValue
    final error = _findError(newValue);
    //IF there is an error, log it
    if (error != null) {
      if (error.error is AppException) {
        // only prints the AppException data
        errorLogger.logAppException(error.error as AppException);
      } else {
        // prints everything including the stack trace
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  ///Finds if the value is an [AsyncError] and returns it
  ///otherwise returns null.
  AsyncError<dynamic>? _findError(Object? value) {
    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
