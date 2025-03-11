import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piix_mobile/src/features/authentication/domain/authentication_model_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/one_column_sign_in_sign_up_submit.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/two_column_sign_in.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

import '../../../goldens/device_sizes.dart';
import '../../../mocks.dart';
import '../../../robot.dart';

void main() {
  late MockAuthService authService;
  setUp(() {
    authService = MockAuthService();
  });

  group('Welcome page', () {
    testWidgets('''WHEN opening the welcome page in a web mobile device screen
    IT will show the web one column welcome page.
    ''', (tester) async {
      final robot = Robot(tester);
      await robot.auth.pumpAuthPage(
        authService,
        isWeb: true,
        platform: TargetPlatform.macOS,
      );
      await robot.golden.setSurfaceSize(DeviceSizes.webMobile);
      final oneColumnWelcomePageFinder =
          find.byType(OneColumnSignInSignUpSubmit);
      expect(oneColumnWelcomePageFinder, findsOneWidget);
      final twoColumnWelcomePageFinder = find.byType(TwoColumnSignIn);
      expect(twoColumnWelcomePageFinder, findsNothing);
    });
    testWidgets('''WHEN opening the welcome page in a web tablet device screen
    IT will show the web one column welcome page.
    ''', (tester) async {
      final robot = Robot(tester);
      await robot.auth.pumpAuthPage(
        authService,
        isWeb: true,
        platform: TargetPlatform.macOS,
      );
      await robot.golden.setSurfaceSize(DeviceSizes.webTablet);
      final oneColumnWelcomePage = find.byType(OneColumnSignInSignUpSubmit);
      expect(oneColumnWelcomePage, findsOneWidget);
      final twoColumnWelcomePage = find.byType(TwoColumnSignIn);
      expect(twoColumnWelcomePage, findsNothing);
    });
    testWidgets('''WHEN opening the welcome page in a desktop device screen
    IT will show the two column welcome page.
    ''', (tester) async {
      final robot = Robot(tester);
      await robot.golden.setSurfaceSize(DeviceSizes.webDesktop);
      await robot.auth.pumpAuthPage(
        authService,
        isWeb: true,
      );
      final twoColumnWelcomePage = find.byType(TwoColumnSignIn);
      expect(twoColumnWelcomePage, findsOneWidget);
      final oneColumnWelcomePage = find.byType(OneColumnSignInSignUpSubmit);
      expect(oneColumnWelcomePage, findsNothing);
    });
    testWidgets('''WHEN submitting an empty email
    IT will show an error text explaining that the email field cannot be empty
    ''', (tester) async {
      final robot = Robot(tester);
      await robot.auth.pumpAuthPage(
        authService,
        isWeb: true,
      );
      await robot.auth.expectEmailCannotBeEmpty();
    });
    testWidgets('''WHEN submitting an email with an invalid format
    IT will show an error text explaining that the email is invalid
    ''', (tester) async {
      final robot = Robot(tester);
      await robot.auth.pumpAuthPage(
        authService,
        isWeb: true,
      );
      await robot.auth.expectEmailIsInvalid();
    });
    testWidgets('''WHEN submitting an email for login 
    AND the email is not used by any user stored
    IT will show an error explaining that the email could not be found.
    ''', (tester) async {
      final robot = Robot(tester);
      when(() => authService.sendVerificationCodeByEmail(
            robot.auth.testSignInEmail,
            robot.auth.locale.languageCode,
            VerificationType.login,
          )).thenThrow(EmailNotFoundException());
      await robot.auth.pumpAuthPage(
        authService,
        isWeb: true,
      );
      await robot.auth.expectEmailNotFound();
    });
    testWidgets('''WHEN submitting an email for login 
    AND an unknow error occurs
    IT will show an error explaining that an unknown error has occured.
    ''', (tester) async {
      final robot = Robot(tester);
      when(() => authService.sendVerificationCodeByEmail(
            robot.auth.testSignInEmail,
            robot.auth.locale.languageCode,
            VerificationType.login,
          )).thenThrow(UnknownErrorException(Exception('mock error')));
      await robot.auth.pumpAuthPage(
        authService,
        isWeb: true,
      );
      robot.auth.expectEmailSubmitUnknowError(robot.auth.testSignInEmail);
    });
    testWidgets('''When submitting a valid email for login
    IT will show a circular progress indicator while loading''',
        (tester) async {
      //* run test in async to wait for all timers to finish
      await tester.runAsync(() async {
        final robot = Robot(tester);
        when(() => authService.sendVerificationCodeByEmail(
              robot.auth.testSignInEmail,
              robot.auth.locale.languageCode,
              VerificationType.login,
              //* Add a delay to allow time for the loading to work
            )).thenAnswer((_) async => Future.delayed(
              const Duration(milliseconds: 100),
              () => Future.value(),
            ));
        when(() => authService.authStateChange())
            .thenAnswer((_) => const Stream<AppUser>.empty());
        when(() => authService.currentUser).thenReturn(null);
        await robot.auth.pumpAuthPage(
          authService,
          isWeb: true,
        );
        await robot.auth.expectSubmitEmailLoadingIndicator();
      });
    });
    testWidgets('''WHEN submitting an email for login 
    AND the email can be found in a stored user
    IT will show no error.
    ''', (tester) async {
      final robot = Robot(tester);
      when(() => authService.sendVerificationCodeByEmail(
            robot.auth.testSignInEmail,
            robot.auth.locale.languageCode,
            VerificationType.login,
          )).thenAnswer((_) => Future.value());
      when(() => authService.authStateChange())
          .thenAnswer((_) => const Stream<AppUser>.empty());
      when(() => authService.currentUser).thenReturn(null);
      await robot.auth.pumpAuthPage(
        authService,
        isWeb: true,
      );
      await robot.auth.expectSubmitEmailSuccess(robot.auth.testSignInEmail);
    });
  });
}
