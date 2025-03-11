import 'dart:async';

import 'package:flutter/foundation.dart';

/// Converts a [Stream] into a [Listenable]
///
/// {@tool snippet}
/// Typical usage is as follows:
///
/// ```dart
/// GoRouter(
///  refreshListenable: GoRouterRefreshStream(stream),
/// );
/// ```
/// {@end-tool}
class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream].
  ///
  /// Every time the [stream] receives an event the [GoRouter] will refresh its
  /// current route.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
