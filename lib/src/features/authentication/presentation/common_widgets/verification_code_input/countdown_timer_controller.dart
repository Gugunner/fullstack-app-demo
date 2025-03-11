import 'dart:async';

import 'package:piix_mobile/src/utils/text_duration.dart';
import 'package:riverpod/riverpod.dart';

///A simple state notifier to handle a countdown timer that
///starts from a given [time] and counts down to zero.
class CountDownNotifier extends StateNotifier<Duration> {
  ///The timer which is initializez with the given [time]
  ///by calling [startTime] method.
  Timer? _timer;

  CountDownNotifier(this.time) : super(time);

  ///The initial time to start the countdown from every sequence.
  final Duration time;

  ///The period of the timer to count down by one second.
  final _oneSecondPeriod = const Duration(seconds: 1);

  ///Starts the timer to count down from the given [time]
  ///and initializes the [_timer] to count down by one second.
  void startTime() {
    state = time;
    _timer = Timer.periodic(_oneSecondPeriod, _countDown);
  }

  ///The callback function that is called every second.
  void _countDown(Timer timer) {
    //* Check if the notifier is mounted before updating the state
    if (mounted) {
      const reduceBy = Duration(seconds: 1);
      final remainingSeconds = state.inSeconds - reduceBy.inSeconds;

      //Update the state with the remaining seconds.
      if (remainingSeconds >= 0) {
        state = Duration(seconds: remainingSeconds);
      }
      //Cancel the timer when the remaining seconds is zero.
      if (remainingSeconds == 0) {
        _timer?.cancel();
      }
    } else {
      //* Cancel timer if the notifier is no longer mounted
      _timer?.cancel();
    }
  }

  ///Cancels the timer and resets the state to zero time.
  void cancel() {
    _timer?.cancel();
    state = Duration.zero;
  }
}

///The provider that provides the [CountDownNotifier] to be used
final resendCodeTimerProvider =
    StateNotifierProvider.autoDispose<CountDownNotifier, Duration>((ref) {
  final resendCodeTimerNotifier = CountDownNotifier(const Duration(minutes: 2));
  //* Cancel the timer before disposing the provider to prevent memory leak and mounted state errors//
  final link = ref.keepAlive();
  ref.onDispose(() {
    resendCodeTimerNotifier.cancel();
  });
  ref.onCancel(() {
    resendCodeTimerNotifier.cancel();
    link.close();
  });
  return resendCodeTimerNotifier;
});

///A provider that returns a boolean value checking if the timer has
///reached zero.
final canResendCodeProvider = Provider.autoDispose<bool>((ref) {
  final remainingTime = ref.watch(resendCodeTimerProvider);
  return remainingTime.inSeconds == 0;
});

///A provider that returns the remaining time in text format 'mm:ss'.
final timeInTextProvider = Provider.autoDispose<String>((ref) {
  final remainingTime = ref.watch(resendCodeTimerProvider);
  return remainingTime.minutesAndSeconds;
});
