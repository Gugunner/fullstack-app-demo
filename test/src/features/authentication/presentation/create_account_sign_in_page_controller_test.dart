import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piix_mobile/src/features/authentication/application/auth_service_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/presentation/create_account_sign_in_page_controller.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

import '../../../mocks.dart';

void main() {
  //Test variables
  const testEmail = 'email@gmail.com';
  const testVerificationType = VerificationType.login;
  const testVerificationCode = '123456';
  const testLanguageCode = 'en';

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

  group('Create Account Sign In Page Controller', () {
    test('''WHEN calling authenticateWithEmailAndVerificationCode
    AND using register as the AuthenticationFormType
    THEN the call will be done to authService.createAccountWithEmailAndVerificationCode
    AND the state is updated to AsyncLoading
    AND the state is updated to AsyncData<void> when the call is successful
    ''', () async {
      //Create the mock object
      final authService = MockAuthService();
      //Create the test provider container
      final container = makeProviderContainer(authService);
      //Mock calls and return values or exceptions
      when(() => authService.createAccountWithEmailAndVerificationCode(
              testEmail, testVerificationCode, testLanguageCode))
          .thenAnswer((_) async => null);
      //Initialize the listener which is used to listen to the provider
      //state changes.
      final listener = Listener<AsyncValue<void>>();
      //Add the listener to the provider.
      container.listen(
        createAccountSignInControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Create the initial state of the provider.
      const data = AsyncData<void>(null);
      //Verify initial value from build method of the (async) notifier provider
      verify(() => listener(null, data));
      //Get the controller from the provider.
      final controller =
          container.read(createAccountSignInControllerProvider.notifier);
      //Execute the method to test.
      await controller.authenticateWithEmailAndVerificationCode(
        VerificationType.register,
        email: testEmail,
        verificationCode: testVerificationCode,
        languageCode: testLanguageCode,
      );
      //Verify the order of the states for the provider.
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading<void>>())),
        //data when complete
        () => listener(any(that: isA<AsyncLoading<void>>()), data),
      ]);
      //Verify that the authService.signInWithEmailAndVerificationCode is
      //never called
      verifyNever(() => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          ));
      //Verify that no more interactions are done with the listener.
      verifyNoMoreInteractions(listener);
    });
    test('''WHEN calling authenticateWithEmailAndVerificationCode
    AND using register as the AuthenticationFormType
    THEN the call will be done to authService.createAccountWithEmailAndVerificationCode
    AND the state is updated to AsyncLoading
    AND the state is updated to AsyncError when the call is unsuccessful
    ''', () async {
      //Create the mock object
      final authService = MockAuthService();
      //Create the test provider container
      final container = makeProviderContainer(authService);
      //Mock calls and return values or exceptions
      when(() => authService.createAccountWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          )).thenThrow(Exception('mock error'));
      //Initialize the listener which is used to listen to the provider
      final listener = Listener<AsyncValue<void>>();
      //Add the listener to the provider.
      container.listen(
        createAccountSignInControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Create the initial state of the provider.
      const data = AsyncData<void>(null);
      //Verify initial value from build method of the (async) notifier provider
      verify(() => listener(null, data));
      //Get the controller from the provider.
      final controller =
          container.read(createAccountSignInControllerProvider.notifier);
      //Execute the method to test.
      await controller.authenticateWithEmailAndVerificationCode(
        VerificationType.register,
        email: testEmail,
        verificationCode: testVerificationCode,
        languageCode: testLanguageCode,
      );
      //Verify the order of the states for the provider.
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading<void>>())),
        //data when complete
        () => listener(
            any(that: isA<AsyncLoading<void>>()),
            any(
                that: isA<AsyncError<void>>().having(
              (e) => e.error.toString(),
              'exception',
              'Exception: mock error',
            ))),
      ]);
      //Verify that no more interactions are done with the listener.
      verifyNoMoreInteractions(listener);
    });
    test('''WHEN calling authenticateWithEmailAndVerificationCode
    AND using signIn as the AuthenticationFormType
    THEN the call will be donte to authService.signInWithEmailAndVerificationCode
    AND the state is updated to AsyncLoading
    AND the state is updated to AsyncData<void> when the call is successful
    ''', () async {
      //Create the mock object
      final authService = MockAuthService();
      //Create the test provider container
      final container = makeProviderContainer(authService);
      //Mock calls and return values or exceptions
      when(() => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          )).thenAnswer((_) async => null);
      //Initialize the listener which is used to listen to the provider
      final listener = Listener<AsyncValue<void>>();
      //Add the listener to the provider.
      container.listen(
        createAccountSignInControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Create the initial state of the provider.
      const data = AsyncData<void>(null);
      //Verify initial value from build method of the (async) notifier provider
      verify(() => listener(null, data));
      //Get the controller from the provider.
      final controller =
          container.read(createAccountSignInControllerProvider.notifier);
      //Execute the method to test.
      await controller.authenticateWithEmailAndVerificationCode(
        testVerificationType,
        email: testEmail,
        verificationCode: testVerificationCode,
        languageCode: testLanguageCode,
      );
      //Verify the order of the states for the provider.
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading<void>>())),
        //data when complete
        () => listener(any(that: isA<AsyncLoading<void>>()), data),
      ]);
      //Verify that the authService.createAccountWithEmailAndVerificationCode is
      verifyNever(() => authService.createAccountWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          ));
      //Verify that no more interactions are done with the listener.
      verifyNoMoreInteractions(listener);
    });
    test('''WHEN calling authenticateWithEmailAndVerificationCode
    AND using signIn as the AuthenticationFormType
    THEN the call will be done to authService.signInWithEmailAndVerificationCode
    AND the state is updated to AsyncLoading
    AND the state is updated to AsyncError when the call is unsuccessful
    ''', () async {
      //Create the mock object
      final authService = MockAuthService();
      //Create the test provider container
      final container = makeProviderContainer(authService);
      //Mock calls and return values or exceptions
      when(() => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          )).thenThrow(Exception('mock error'));
      //Initialize the listener which is used to listen to the provider
      final listener = Listener<AsyncValue<void>>();
      //Add the listener to the provider.
      container.listen(
        createAccountSignInControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Create the initial state of the provider.
      const data = AsyncData<void>(null);
      //Verify initial value from build method of the (async) notifier provider
      verify(() => listener(null, data));
      //Get the controller from the provider.
      final controller =
          container.read(createAccountSignInControllerProvider.notifier);
      //Execute the method to test.
      await controller.authenticateWithEmailAndVerificationCode(
        testVerificationType,
        email: testEmail,
        verificationCode: testVerificationCode,
        languageCode: testLanguageCode,
      );
      //Verify the order of the states for the provider.
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading<void>>())),
        //data when complete
        () => listener(
            any(that: isA<AsyncLoading<void>>()),
            any(
                that: isA<AsyncError<void>>().having(
              (e) => e.error.toString(),
              'exception',
              'Exception: mock error',
            ))),
      ]);
      //Verify that no more interactions are done with the listener.
      verifyNoMoreInteractions(listener);
    });
    test('''WHEN calling signOut
    THEN the state is updated to AsyncLoading
    AND the state is updated to AsyncData<void> when the call is successful
    ''', () async {
      //Create the mock object
      final authService = MockAuthService();
      //Create the test provider container
      final container = makeProviderContainer(authService);
      //Mock calls and return values or exceptions
      when(() => authService.signOut()).thenAnswer((_) async => null);
      //Initialize the listener which is used to listen to the provider
      final listener = Listener<AsyncValue<void>>();
      //Add the listener to the provider.
      container.listen(
        createAccountSignInControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Create the initial state of the provider.
      const data = AsyncData<void>(null);
      //Verify initial value from build method of the (async) notifier provider
      verify(() => listener(null, data));
      //Get the controller from the provider.
      final controller =
          container.read(createAccountSignInControllerProvider.notifier);
      //Execute the method to test.
      await controller.signOut();
      //Verify the order of the states for the provider.
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading<void>>())),
        //data when complete
        () => listener(any(that: isA<AsyncLoading<void>>()), data),
      ]);
      //Verify that no more interactions are done with the listener.
      verifyNoMoreInteractions(listener);
    });
    test('''WHEN calling signOut
    THEN the state is updated to AsyncLoading
    AND the state is updated to AsyncError when the call is unsuccessful
    ''', () async {
      //Create the mock object
      final authService = MockAuthService();
      //Create the test provider container
      final container = makeProviderContainer(authService);
      //Mock calls and return values or exceptions
      when(() => authService.signOut()).thenThrow(Exception('mock error'));
      //Initialize the listener which is used to listen to the provider
      final listener = Listener<AsyncValue<void>>();
      //Add the listener to the provider.
      container.listen(
        createAccountSignInControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      //Create the initial state of the provider.
      const data = AsyncData<void>(null);
      //Verify initial value from build method of the (async) notifier provider
      verify(() => listener(null, data));
      //Get the controller from the provider.
      final controller =
          container.read(createAccountSignInControllerProvider.notifier);
      //Execute the method to test.
      await controller.signOut();
      //Verify the order of the states for the provider.
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading<void>>())),
        //data when complete
        () => listener(
            any(that: isA<AsyncLoading<void>>()),
            any(
                that: isA<AsyncError<void>>().having(
              (e) => e.error.toString(),
              'exception',
              'Exception: mock error',
            ))),
      ]);
      //Verify that no more interactions are done with the listener.
      verifyNoMoreInteractions(listener);
    });
  });
}
