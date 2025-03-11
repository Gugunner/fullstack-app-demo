import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piix_mobile/src/constants/widget_keys.dart';
import 'package:piix_mobile/src/features/authentication/domain/authentication_model_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/presentation/authentication_page_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/mobile_email_verification_code_page.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/tablet_email_verification_code_page.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/one_column_email_verification_code_page.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

import '../../../goldens/device_sizes.dart';
import '../../../mocks.dart';
import '../../../robot.dart';

void main() {
  const testEmail = 'email@gmail.com';
  const testDuration = Duration(seconds: 2);
  const testLanguageCode = 'en';
  final longerTestDuration = Duration(seconds: testDuration.inSeconds + 1);
  const testVerificationCode = '123456';

  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  group('Email send verification  code web page ', () {
    testWidgets(
        '''WHEN opening the email send verification code page in a web mobile device screen
    IT will show the web one column email verification code page
    ''', (tester) async {
      final robot = Robot(tester);
      await robot.golden.setSurfaceSize(DeviceSizes.webMobile);
      await tester.runAsync(() async {
        await robot.auth.pumpAuthPage(
          authService,
          isWeb: true,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
      });
      final oneColumnEmailVerificationCodePageFinder =
          find.byType(OneColumnEmailVerificationCodePage);
      expect(oneColumnEmailVerificationCodePageFinder, findsOneWidget);
    });
    testWidgets(
        '''WHEN opening the email send verification code page in a web tablet device screen
    IT will show the web one column email verification code page
    ''', (tester) async {
      final robot = Robot(tester);
      await robot.golden.setSurfaceSize(DeviceSizes.webTablet);
      await tester.runAsync(() async {
        await robot.auth.pumpAuthPage(
          authService,
          isWeb: true,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
      });
      final oneColumnEmailVerificationCodePageFinder =
          find.byType(OneColumnEmailVerificationCodePage);
      expect(oneColumnEmailVerificationCodePageFinder, findsOneWidget);
    });
    testWidgets('''WHEN opening the email send verification page
    THEN it will show 6 single code boxes and a countdown text.
    ''', (tester) async {
      final robot = Robot(tester);
      //* Execute with runAsync to wait for timer
      await tester.runAsync(() async {
        await robot.auth.pumpAuthPage(
          authService,
          isWeb: true,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
      });
      robot.auth.expectExactlyNSingleCodeBoxes(6);
      await robot.auth.expectTextInTimeToBe(testDuration);
    });
    group('Submit verification code', () {
      testWidgets('''WHEN the verification code is empty 
    AND the submit verification code button is disabled
    THEN the verification code is filled 
    AND the submit verification code button enables
    ''', (tester) async {
        final robot = Robot(tester);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectButtonByKeyToBeEnabled(
          false,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
        await robot.auth.enterVerificationCode();
        await robot.auth.expectButtonByKeyToBeEnabled(
          true,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
      });
      testWidgets('''WHEN submitting the wrong verification code
    THEN it will show an error text explaining that the code is incorrect
    ''', (tester) async {
        final robot = Robot(tester);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode.split('').reversed.join(''),
            testLanguageCode,
          ),
        ).thenThrow(IncorrectVerificationCodeException());
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.enterVerificationCode(reverseCode: true);
        await robot.auth
            .tapButtonByKey(widgetKey: WidgetKeys.submitVerificationCodeButton);
        final textFinder =
            find.text(robot.auth.appIntl.incorrectVerificationCode);
        expect(textFinder, findsOneWidget);
      });
      testWidgets('''WHEN submitting a verification code
    AND an unknown error occurs
    THEN it will show an error explaining that an unknown error has occured.
    ''', (tester) async {
        final robot = Robot(tester);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode.split('').reversed.join(''),
            testLanguageCode,
          ),
        ).thenThrow(UnknownErrorException(Exception('mock error')));
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectSubmitVerificationCodeUnknownException();
      });
      testWidgets('''WHEN submitting a verification code
    AND an unknown error occurs
    AND a at least one single code box changes its value
    THEN the error text will be cleared.
    ''', (tester) async {
        final robot = Robot(tester);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode.split('').reversed.join(''),
            testLanguageCode,
          ),
        ).thenThrow(UnknownErrorException(Exception('mock error')));
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectSubmitVerificationCodeUnknownException();
        final singleCodeBoxFinder = find.byType(TextField).at(0);
        await tester.enterText(singleCodeBoxFinder, '0');
        await tester.pumpAndSettle();
        final textFinder = find.text(robot.auth.appIntl.unknownError);
        expect(textFinder, findsNothing);
      });
      testWidgets('''WHEN submitting a verification code
    THEN it will show a circular progress indicator while loading.
    ''', (tester) async {
        final robot = Robot(tester);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          ),
        ).thenAnswer(
          (_) async => Future.delayed(
            const Duration(milliseconds: 100),
            () => Future.value(),
          ),
        );
        when(() => authService.authStateChange())
            .thenAnswer((_) => const Stream<AppUser>.empty());
        when(() => authService.currentUser).thenReturn(null);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        robot.auth.expectExactlyNSingleCodeBoxes(6);
        await robot.auth.expectTextInTimeToBe(testDuration);
        await robot.auth.enterVerificationCode();
        await robot.auth.tapButtonByKey(
          pupmAndSettle: false,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
        final progressIndicator = find.byType(CircularProgressIndicator);
        expect(progressIndicator, findsOneWidget);
        //* Since pump and settle is being stopped it must be done at the end to allow the timer to finish//
        await tester.pumpAndSettle(longerTestDuration);
      });
      testWidgets('''WHEN submitting a verification code
    AND the code match
    THEN it will show no error.
    ''', (tester) async {
        final robot = Robot(tester);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          ),
        ).thenAnswer(
          (_) async => Future.value(),
        );
        when(() => authService.authStateChange())
            .thenAnswer((_) => const Stream<AppUser>.empty());
        when(() => authService.currentUser).thenReturn(null);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectSubmitVerificationCodeSuccess();
      });
    });

    group('Verification Code Boxes', () {
      testWidgets('''WHEN opening the email send verification page
    THEN the first single code box will have focus.
    ''', (tester) async {
        final robot = Robot(tester);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectButtonByKeyToBeEnabled(
          false,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
        await robot.auth.expectSingleCodeBoxHaveFocusAt(0);
      });
      testWidgets('''WHEN entering the verification code
    THEN each digit will be placed in one single box
    AND the focus node will move to the next one until the last one unfocus all.
    ''', (tester) async {
        final robot = Robot(tester);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectButtonByKeyToBeEnabled(
          false,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
        await robot.auth.enterVerificationCode();
      });
      testWidgets(
          '''WHEN replacing the digit from a single code box to an invisible char
    AND replacing the invisible char to an empty string
    THEN it will loose focus and move to the previous single code box
    ''', (tester) async {
        final robot = Robot(tester);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            isWeb: true,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.enterVerificationCode();
        await robot.auth.deleteSingleCodeBoxAt(5);
        await robot.auth.expectSingleCodeBoxHaveFocusAt(4);
      });
    });

    group('Resend Code', () {
      testWidgets('''WHEN the countdown reaches zero
      THEN the request new code will be enabled
    ''', (tester) async {
        final robot = Robot(tester);
        //* Execute with using pump and settle with a timer bigger than the test one to prevent exceptions of timer not ending //
        await robot.auth.pumpAuthPage(
          authService,
          isWeb: true,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
        await robot.auth
            .expectCountdownToFinish(testDuration, longerTestDuration);
      });
      testWidgets('''WHEN requesting a new code 
      AND an EmailNotFoundException occurs
      THEN it will show an error explaining that the email could not be found
    ''', (tester) async {
        final robot = Robot(tester);
        when(() => authService.sendVerificationCodeByEmail(
              testEmail,
              testLanguageCode,
              VerificationType.login,
            )).thenThrow(EmailNotFoundException());
        //* Execute with using pump and settle with a timer bigger than the test one to prevent exceptions of timer not ending //
        await robot.auth.pumpAuthPage(
          authService,
          isWeb: true,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
        await tester.runAsync(() async {
          await robot.auth
              .expectCountdownToFinish(testDuration, longerTestDuration);
          await robot.auth
              .tapButtonByKey(widgetKey: WidgetKeys.requestNewCodebutton);
          final textFinder = find.text(robot.auth.appIntl.emailNotFound);
          expect(textFinder, findsOneWidget);
        });
      });
      testWidgets('''WHEN requesting a new code 
      AND an EmailAlreadyExists occurs
      THEN it will show an error explaining that the email already exists.
    ''', (tester) async {
        final robot = Robot(tester);
        const verificationType = VerificationType.register;
        when(() => authService.sendVerificationCodeByEmail(
              testEmail,
              testLanguageCode,
              verificationType,
            )).thenThrow(EmailAlreadyExistsException());
        //* Execute with using pump and settle with a timer bigger than the test one to prevent exceptions of timer not ending //
        await robot.auth.pumpAuthPage(
          authService,
          isWeb: true,
          page: const EmailVerificationCodePage(
            email: testEmail,
            verificationType: verificationType,
          ),
          timerDuration: testDuration,
        );
        await tester.runAsync(() async {
          await robot.auth
              .expectCountdownToFinish(testDuration, longerTestDuration);
          await robot.auth
              .tapButtonByKey(widgetKey: WidgetKeys.requestNewCodebutton);
          final textFinder = find.text(robot.auth.appIntl.emailAlreadyExists);
          expect(textFinder, findsOneWidget);
        });
      });
      testWidgets('''WHEN requesting a new code 
      AND an UnknownErrorException occurs
      THEN it will show an error explaining that an unknown error occured.
    ''', (tester) async {
        final robot = Robot(tester);
        when(() => authService.sendVerificationCodeByEmail(
              testEmail,
              testLanguageCode,
              VerificationType.login,
            )).thenThrow(UnknownErrorException(Exception('mock error')));
        //* Execute with using pump and settle with a timer bigger than the test one to prevent exceptions of timer not ending //
        await robot.auth.pumpAuthPage(
          authService,
          isWeb: true,
          page: const EmailVerificationCodePage(
            email: testEmail,
          ),
          timerDuration: testDuration,
        );
        await tester.runAsync(() async {
          await robot.auth
              .expectCountdownToFinish(testDuration, longerTestDuration);
          await robot.auth
              .tapButtonByKey(widgetKey: WidgetKeys.requestNewCodebutton);
          final textFinder = find.text(robot.auth.appIntl.unknownError);
          expect(textFinder, findsOneWidget);
        });
      });
    });
  });

  group('Email send verification code mobile/tablet page', () {
    testWidgets(
        '''WHEN opening the email send verification code page in a mobile device
    THEN it will show mobile email send verification code page''',
        (tester) async {
      final robot = Robot(tester);
      await robot.golden.setSurfaceSize(DeviceSizes.phoneSMPortrait);
      await tester.runAsync(() async {
        await robot.auth.pumpAuthPage(
          authService,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
      });
      final oneColumnEmailVerificationCodePageFinder =
          find.byType(MobileEmailVerificationCodePage);
      expect(oneColumnEmailVerificationCodePageFinder, findsOneWidget);
    });
    testWidgets(
        '''WHEN opening the email send verification code page in a tablet device
    THEN it will show tablet email send verification code page''',
        (tester) async {
      final robot = Robot(tester);
      await robot.golden.setSurfaceSize(DeviceSizes.tabletXLLandscape);
      await tester.runAsync(() async {
        await robot.auth.pumpAuthPage(
          authService,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
      });
      final oneColumnEmailVerificationCodePageFinder =
          find.byType(TabletEmailVerificationCodePage);
      expect(oneColumnEmailVerificationCodePageFinder, findsOneWidget);
    });
    testWidgets('''WHEN opening the email send verification page
    THEN it will show 6 single code boxes and a countdown text.''',
        (tester) async {
      final robot = Robot(tester);
      await robot.golden.setSurfaceSize(DeviceSizes.phoneSMPortrait);
      //* Execute with runAsync to wait for timer
      await tester.runAsync(() async {
        await robot.auth.pumpAuthPage(
          authService,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
      });
      robot.auth.expectExactlyNSingleCodeBoxes(6);
      await robot.auth.expectTextInTimeToBe(testDuration);
    });
    group('Submit verification code', () {
      testWidgets('''WHEN the verification code is empty 
    AND the submit verification code button is disabled
    THEN the verification code is filled 
    AND the submit verification code button enables''', (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.tabletXLLandscape);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectButtonByKeyToBeEnabled(
          false,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
        await robot.auth.enterVerificationCode();
        await robot.auth.expectButtonByKeyToBeEnabled(
          true,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
      });
      testWidgets('''WHEN submitting the wrong verification code
    THEN it will show an error text explaining that the code is incorrect''',
          (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.phoneSMPortrait);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode.split('').reversed.join(''),
            testLanguageCode,
          ),
        ).thenThrow(IncorrectVerificationCodeException());
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.enterVerificationCode(reverseCode: true);
        await robot.auth
            .tapButtonByKey(widgetKey: WidgetKeys.submitVerificationCodeButton);
        final textFinder =
            find.text(robot.auth.appIntl.incorrectVerificationCode);
        expect(textFinder, findsOneWidget);
      });
      testWidgets('''WHEN submitting a verification code
    AND an unknown error occurs
    THEN it will show an error explaining that an unknown error has occured.''',
          (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.tabletXLLandscape);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode.split('').reversed.join(''),
            testLanguageCode,
          ),
        ).thenThrow(UnknownErrorException(Exception('mock error')));
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectSubmitVerificationCodeUnknownException();
      });
      testWidgets('''WHEN submitting a verification code
    AND an unknown error occurs
    AND a at least one single code box changes its value
    THEN the error text will be cleared.''', (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.phoneSMPortrait);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode.split('').reversed.join(''),
            testLanguageCode,
          ),
        ).thenThrow(UnknownErrorException(Exception('mock error')));
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectSubmitVerificationCodeUnknownException();
        final singleCodeBoxFinder = find.byType(TextField).at(0);
        await tester.enterText(singleCodeBoxFinder, '0');
        await tester.pumpAndSettle();
        final textFinder = find.text(robot.auth.appIntl.unknownError);
        expect(textFinder, findsNothing);
      });
      testWidgets('''WHEN submitting a verification code
    THEN it will show a circular progress indicator while loading.''',
          (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.tabletXLLandscape);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          ),
        ).thenAnswer(
          (_) async => Future.delayed(
            const Duration(milliseconds: 100),
            () => Future.value(),
          ),
        );
        when(() => authService.authStateChange())
            .thenAnswer((_) => const Stream<AppUser>.empty());
        when(() => authService.currentUser).thenReturn(null);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        robot.auth.expectExactlyNSingleCodeBoxes(6);
        await robot.auth.expectTextInTimeToBe(testDuration);
        await robot.auth.enterVerificationCode();
        await robot.auth.tapButtonByKey(
          pupmAndSettle: false,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
        final progressIndicator = find.byType(CircularProgressIndicator);
        expect(progressIndicator, findsOneWidget);
        //* Since pump and settle is being stopped it must be done at the end to allow the timer to finish//
        await tester.pumpAndSettle(longerTestDuration);
      });
      testWidgets('''WHEN submitting a verification code
    AND the code match
    THEN it will show no error.''', (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.phoneSMPortrait);
        when(
          () => authService.signInWithEmailAndVerificationCode(
            testEmail,
            testVerificationCode,
            testLanguageCode,
          ),
        ).thenAnswer(
          (_) async => Future.value(),
        );
        when(() => authService.authStateChange())
            .thenAnswer((_) => const Stream<AppUser>.empty());
        when(() => authService.currentUser).thenReturn(null);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectSubmitVerificationCodeSuccess();
      });
    });
    group('Verification code boxes', () {
      testWidgets('''WHEN opening the email send verification page
    THEN the first single code box will have focus.''', (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.tabletXLLandscape);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectButtonByKeyToBeEnabled(
          false,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
        await robot.auth.expectSingleCodeBoxHaveFocusAt(0);
      });
      testWidgets('''WHEN entering the verification code
    THEN each digit will be placed in one single box
    AND the focus node will move to the next one until the last one unfocus all.''',
          (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.phoneSMPortrait);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.expectButtonByKeyToBeEnabled(
          false,
          widgetKey: WidgetKeys.submitVerificationCodeButton,
        );
        await robot.auth.enterVerificationCode();
      });
      testWidgets(
          '''WHEN replacing the digit from a single code box to an invisible char
    AND replacing the invisible char to an empty string
    THEN it will loose focus and move to the previous single code box.''',
          (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.tabletXLLandscape);
        //* Execute with runAsync to wait for timer
        await tester.runAsync(() async {
          await robot.auth.pumpAuthPage(
            authService,
            page: const EmailVerificationCodePage(email: testEmail),
            timerDuration: testDuration,
          );
        });
        await robot.auth.enterVerificationCode();
        await robot.auth.deleteSingleCodeBoxAt(5);
        await robot.auth.expectSingleCodeBoxHaveFocusAt(4);
      });
    });
    group('Resend code', () {
      testWidgets('''WHEN the countdown reaches zero
      THEN the request new code will be enabled.''', (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.phoneSMPortrait);
        //* Execute with runAsync to wait for timer
        await robot.auth.pumpAuthPage(
          authService,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
        await robot.auth
            .expectCountdownToFinish(testDuration, longerTestDuration);
      });
      testWidgets('''WHEN requesting a new code 
      AND an EmailNotFoundException occurs
      THEN it will show an error explaining that the email could not be found.''',
          (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.tabletXLLandscape);
        when(() => authService.sendVerificationCodeByEmail(
              testEmail,
              testLanguageCode,
              VerificationType.login,
            )).thenThrow(EmailNotFoundException());
        //* Execute with runAsync to wait for timer
        await robot.auth.pumpAuthPage(
          authService,
          page: const EmailVerificationCodePage(email: testEmail),
          timerDuration: testDuration,
        );
        await tester.runAsync(() async {
          await robot.auth
              .expectCountdownToFinish(testDuration, longerTestDuration);
          await robot.auth
              .tapButtonByKey(widgetKey: WidgetKeys.requestNewCodebutton);
          final textFinder = find.text(robot.auth.appIntl.emailNotFound);
          expect(textFinder, findsOneWidget);
        });
      });
      testWidgets('''WHEN requesting a new code 
      AND an EmailAlreadyExists occurs
      THEN it will show an error explaining that the email already exists.''',
          (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.phoneSMPortrait);
        const verificationType = VerificationType.register;
        when(() => authService.sendVerificationCodeByEmail(
              testEmail,
              testLanguageCode,
              verificationType,
            )).thenThrow(EmailAlreadyExistsException());
        //* Execute with runAsync to wait for timer
        await robot.auth.pumpAuthPage(
          authService,
          page: const EmailVerificationCodePage(
            email: testEmail,
            verificationType: verificationType,
          ),
          timerDuration: testDuration,
        );
        await tester.runAsync(() async {
          await robot.auth
              .expectCountdownToFinish(testDuration, longerTestDuration);
          await robot.auth
              .tapButtonByKey(widgetKey: WidgetKeys.requestNewCodebutton);
          final textFinder = find.text(robot.auth.appIntl.emailAlreadyExists);
          expect(textFinder, findsOneWidget);
        });
      });
      testWidgets('''WHEN requesting a new code 
      AND an UnknownErrorException occurs
      THEN it will show an error explaining that an unknown error occured.''',
          (tester) async {
        final robot = Robot(tester);
        await robot.golden.setSurfaceSize(DeviceSizes.tabletXLLandscape);
        const verificationType = VerificationType.register;
        when(() => authService.sendVerificationCodeByEmail(
              testEmail,
              testLanguageCode,
              VerificationType.login,
            )).thenThrow(UnknownErrorException(Exception('mock error')));
        //* Execute with runAsync to wait for timer
        await robot.auth.pumpAuthPage(
          authService,
          page: const EmailVerificationCodePage(
            email: testEmail,
            verificationType: verificationType,
          ),
          timerDuration: testDuration,
        );
        await tester.runAsync(() async {
          await robot.auth
              .expectCountdownToFinish(testDuration, longerTestDuration);
          await robot.auth
              .tapButtonByKey(widgetKey: WidgetKeys.requestNewCodebutton);
          final textFinder = find.text(robot.auth.appIntl.unknownError);
          expect(textFinder, findsOneWidget);
        });
      });
    });
  });
}
