import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/verification_code_input/countdown_timer_controller.dart';
import '../../../mocks.dart';

void main() {
  //Test variables
  const testDuration = Duration(seconds: 2);
  final longerTestDuration = Duration(seconds: testDuration.inSeconds + 1);

  //A utility function that helps create a provider container to
  //call test Riverpod providers.
  ProviderContainer makeProviderContainer(Duration duration) {
    final container = ProviderContainer(overrides: [
      resendCodeTimerProvider.overrideWith(
        (ref) => CountDownNotifier(duration),
      ),
    ]);
    //Called after each test to dispose the container and prevent memory leaks
    addTearDown(container.dispose);
    return container;
  }

  group('Resend Code Timer Controller', () {
    test('''WHEN initializing the ResendCodeTimerNotifier
    IT will initialize with the testDuration time''', () {
      //Create the test provider container
      final container = makeProviderContainer(testDuration);
      //Initialize the listener which is used to listen to the provider
      //state changes.
      final listener = Listener<Duration>();
      //Add the listener to the provider
      container.listen(
        resendCodeTimerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Verify initial value from build method of the state notifier provider
      verify(() => listener(null, testDuration));
    });
    test('''WHEN calling startTime
    THEN the timer will reduce by one second until it reaches 0
    ''', () async {
      //Create the test provider container
      final container = makeProviderContainer(testDuration);
      //Initialize the listener which is used to listen to the provider
      //state changes.
      final listener = Listener<Duration>();
      //Add the listener to the provider
      container.listen(
        resendCodeTimerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Verify initial value from build method of the state notifier provider
      verify(() => listener(null, testDuration));
      //Get the controller from the provider.
      final controller = container.read(resendCodeTimerProvider.notifier);
      //Execute the method to test.
      controller.startTime();
      //* Create a delay to allow the timer to run
      //* Consider more time when running all tests since some tests use runAsync which isolates the execution an may collision with other tests //
      await Future.delayed(longerTestDuration, () {
        //Verify the order of the states for the provider.
        verifyInOrder([
          () => listener(testDuration, const Duration(seconds: 1)),
          () => listener(const Duration(seconds: 1), Duration.zero),
        ]);
      });

      verifyNoMoreInteractions(listener);
    });
    test('''WHEN calling startTime
    THEN calling cancel before it finishes the countdown
    IT will reset the timer to 0
    ''', () async {
      //Create the test provider container
      final container = makeProviderContainer(const Duration(seconds: 3));
      //Initialize the listener which is used to listen to the provider
      //state changes.
      final listener = Listener<Duration>();
      //Add the listener to the provider
      container.listen(
        resendCodeTimerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Verify initial value from build method of the state notifier provider
      verify(() => listener(null, longerTestDuration));
      //Get the controller from the provider.
      final controller = container.read(resendCodeTimerProvider.notifier);
      //Execute the method to test.
      controller.startTime();
      //* Create a delay to allow the timer to run
      await Future.delayed(const Duration(seconds: 1));
      controller.cancel();
      //Verify the order of the states for the provider.
      verifyInOrder([
        () => listener(longerTestDuration, const Duration(seconds: 2)),
        () => listener(const Duration(seconds: 2), Duration.zero),
      ]);
      verifyNoMoreInteractions(listener);
    });
  });
}
