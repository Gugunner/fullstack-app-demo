import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piix_mobile/src/features/authentication/application/auth_service_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/presentation/send_verification_code_controller.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

import '../../../mocks.dart';

void main() {
  //Test variables
  const testEmail = 'email@gmail.com';
  const testLanguageCode = 'en';
  const testVerificationType = VerificationType.login;

  //A utility function that helps create a provider container to
  //call test Riverpod providers.
  ProviderContainer makeProviderContainer(MockAuthService authService) {
    final container = ProviderContainer(overrides: [
      authServiceProvider.overrideWithValue(authService),
    ]);
    //Called after each test to dispose the container and prevent memory leaks
    addTearDown(container.dispose);
    return container;
  }

  //Setup that runs once before any test
  setUpAll(() {
    //Register the AsyncLoading as a fallback value for the AsyncValue
    //used when calling any and captureAny.
    registerFallbackValue(const AsyncLoading());
  });

  group('Send Verification Code Controller', () {
    test('''WHEN calling sendVerificationCodeByEmail
    THEN the authServiceProvider.sendVerificationCodeByEmail is called
    AND the state is updated to AsyncLoading
    AND the state is updated to AsyncData<void> when the call is successful
    ''', () async {
      //Create the mock object
      final authService = MockAuthService();
      //Create the test provider container
      final container = makeProviderContainer(authService);
      //Mock calls and return values or exceptions
      when(() => authService.sendVerificationCodeByEmail(
            testEmail,
            testLanguageCode,
            testVerificationType,
          )).thenAnswer((_) async => null);
      //Initialize the listener which is used to listen to the provider
      //state changes.
      final listener = Listener<AsyncValue<void>>();
      //Add the listener to the provider
      container.listen(
        sendVerificationCodeControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Create the initial state of the provider
      const data = AsyncData<void>(null);
      //Verify initial value from build method of the (async) notifier provider
      verify(() => listener(null, data));
      //Get the controller from the provider.
      final controller =
          container.read(sendVerificationCodeControllerProvider.notifier);
      //Execute the method to test.
      await controller.sendVerificationCodeByEmail(
        testEmail,
        testLanguageCode,
        testVerificationType,
      );
      //Verify the order of the states for the provider.
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading>())),
        //data when complete
        () => listener(
            any(
              that: isA<AsyncLoading>(),
            ),
            data),
      ]);
      //Verify that no more interactions are done with the listener.
      verifyNoMoreInteractions(listener);
    });
    test('''WHEN calling sendVerificationCodeByEmail
    THEN the authServiceProvider.sendVerificationCodeByEmail is called
    AND the state is updated to AsyncLoading
    AND the state is updated to AsyncError when the call is unsuccessful
    ''', () async {
      //Create the mock object
      final authService = MockAuthService();
      //Create the test provider container
      final container = makeProviderContainer(authService);
      //Mock calls and return values or exceptions
      when(() => authService.sendVerificationCodeByEmail(
            testEmail,
            testLanguageCode,
            testVerificationType,
          )).thenThrow(Exception('mock error'));
      //Initialize the listener which is used to listen to the provider
      //state changes.
      final listener = Listener<AsyncValue<void>>();
      //Add the listener to the provider
      container.listen(
        sendVerificationCodeControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Create the initial state of the provider
      const data = AsyncData<void>(null);
      //Verify initial value from build method of the (async) notifier provider
      verify(() => listener(null, data));
      //Get the controller from the provider.
      final controller =
          container.read(sendVerificationCodeControllerProvider.notifier);
      //Execute the method to test.
      await controller.sendVerificationCodeByEmail(
        testEmail,
        testLanguageCode,
        testVerificationType,
      );
      //Verify the order of the states for the provider.
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading>())),
        //data when complete
        () => listener(
            any(
              that: isA<AsyncLoading>(),
            ),
            any(
              that: isA<AsyncError<void>>().having(
                (e) => e.error.toString(),
                'exception',
                'Exception: mock error',
              ),
            )),
      ]);
      //Verify that no more interactions are done with the listener.
      verifyNoMoreInteractions(listener);
    });
  });
}
