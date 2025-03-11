import 'package:flutter_test/flutter_test.dart';
import 'package:piix_mobile/src/features/authentication/application/auth_service_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/application/fake_auth_service.dart';
import 'package:piix_mobile/src/features/authentication/domain/authentication_model_barrel_file.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

void main() {
  const testEmail = 'email@gmail.com';
  const testLanguageCode = 'en';
  final expectedFakeAppUser = FakeAppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
    emailVerified: true,
    verificationCode: '123456',
  );

  FakeAuthService createFakeAuthService() {
    final authService = FakeAuthService(addDelay: false);
    addTearDown(authService.dispose);
    return authService;
  }

  Future<void> setAndCreateNewUser(FakeAuthService authService) async {
    await authService.sendVerificationCodeByEmail(
      testEmail,
      testLanguageCode,
      VerificationType.register,
    );
    await authService.createAccountWithEmailAndVerificationCode(
      testEmail,
      expectedFakeAppUser.verificationCode,
      testLanguageCode,
    );
  }

  group('Fake Auth Service Send Verification Code By Email', () {
    test('''WHEN creating a new FakeAuthService instance
    THEN the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () {
      final authService = createFakeAuthService();
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling sendVerificationCodeByEmail 
    AND verificationType is register
    THEN the email and verification code is added to codes
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () {
      final authService = createFakeAuthService();
      authService.sendVerificationCodeByEmail(
        expectedFakeAppUser.email!,
        testLanguageCode,
        VerificationType.register,
      );
      expect(
        authService.getCodesTable()[testEmail],
        expectedFakeAppUser.verificationCode,
      );
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling sendVerificationCodeByEmail 
    AND verificationType is register
    AND a user is already found with the email
    THEN throw an EmailAlreadyExistsException
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () async {
      final authService = createFakeAuthService();
      await setAndCreateNewUser(authService);
      await authService.signOut();
      expect(
          () async => authService.sendVerificationCodeByEmail(
                expectedFakeAppUser.email!,
                testLanguageCode,
                VerificationType.register,
              ),
          throwsA(isA<EmailAlreadyExistsException>()));
      expect(authService.getUsersList(), [expectedFakeAppUser]);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling sendVerificationCodeByEmail 
    AND verificationType is login
    AND a user is found with the email
    THEN the email and verification code is added to codes
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () async {
      final authService = createFakeAuthService();
      await setAndCreateNewUser(authService);
      await authService.signOut();
      authService.getUsersList().add(expectedFakeAppUser);
      authService.sendVerificationCodeByEmail(
        expectedFakeAppUser.email!,
        testLanguageCode,
        VerificationType.login,
      );
      expect(
        authService.getCodesTable()[testEmail],
        expectedFakeAppUser.verificationCode,
      );
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling sendVerificationCodeByEmail 
    AND verificationType is login
    AND a user is already found with the email
    THEN throw an EmailNotFoundException
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () async {
      final authService = createFakeAuthService();
      expect(
          () async => authService.sendVerificationCodeByEmail(
                expectedFakeAppUser.email!,
                testLanguageCode,
                VerificationType.login,
              ),
          throwsA(isA<EmailNotFoundException>()));
      expect(authService.getUsersList(), isEmpty);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
  });

  group('Fake Auth Service Create Account With Email And Verification Code',
      () {
    test('''WHEN calling createAccountWithEmailAndVerificationCode
    after calling sendVerificationCodeByEmail with verification type register
    AND the email and verification code is added to codes
    THEN the user is added to the users list
    AND the current user is not null
    AND the email and verification code is removed from codes
    AND the emailVerified property is true
    AND the authStateChange emits the user
    AND the idTokenChanges emits the user''', () async {
      final authService = createFakeAuthService();
      expect(authService.getUsersList(), []);
      expect(authService.getCodesTable(), {});
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
      await setAndCreateNewUser(authService);
      expect(authService.getUsersList(), [expectedFakeAppUser]);
      expect(authService.currentUser, expectedFakeAppUser);
      expect(authService.getCodesTable(), {});
      expect(authService.authStateChange(), emits(expectedFakeAppUser));
      expect(authService.idTokenChanges(), emits(expectedFakeAppUser));
    });
    test('''WHEN calling createAccountWithEmailAndVerificationCode
    AND entering am email that already has a users in the list
    THEN throw an EmailAlreadyExistsException 
    AND the users list contains the user
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () async {
      final authService = createFakeAuthService();
      await setAndCreateNewUser(authService);
      await authService.signOut();
      expect(authService.getUsersList(), [expectedFakeAppUser]);
      expect(
          () async => authService.createAccountWithEmailAndVerificationCode(
              expectedFakeAppUser.email!,
              expectedFakeAppUser.verificationCode,
              testLanguageCode),
          throwsA(isA<EmailAlreadyExistsException>()));
      expect(authService.getUsersList(), [expectedFakeAppUser]);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling createAccountWithEmailAndVerificationCode
    without calling sendVerificationCodeByEmail
    THEN throw an UnkownErrorException
    AND there is no code to verify
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () async {
      final authService = createFakeAuthService();
      expect(
          () async => authService.createAccountWithEmailAndVerificationCode(
              expectedFakeAppUser.email!,
              expectedFakeAppUser.verificationCode,
              testLanguageCode),
          throwsA(isA<UnknownErrorException>()));
      expect(authService.getUsersList(), isEmpty);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling createAccountWithEmailAndVerificationCode
    after calling sendVerificationCodeByEmail
    AND the email and verification code is added to codes
    AND entering an incorrect verification code
    THEN throw an IncorrectVerificationCodeException
    AND the email and verification code is not removed from codes
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () async {
      final authService = createFakeAuthService();
      expect(authService.getCodesTable(), {});
      await authService.sendVerificationCodeByEmail(
        expectedFakeAppUser.email!,
        testLanguageCode,
        VerificationType.register,
      );
      expect(
          () async => authService.createAccountWithEmailAndVerificationCode(
              expectedFakeAppUser.email!, 'wrong code', testLanguageCode),
          throwsA(isA<IncorrectVerificationCodeException>()));
      expect(authService.getCodesTable(), {
        testEmail: expectedFakeAppUser.verificationCode,
      });
      expect(authService.getUsersList(), []);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
  });

  group('Fake Auth Service Sign In With Email and Verification Code', () {
    test('''WHEN calling signInWithEmailAndVerificationCode
    AND a user already exists with the email 
    THEN the current user is not null
    AND the authStateChange emits the user
    AND the idTokenChanges emits the user
    ''', () async {
      final authService = createFakeAuthService();
      await setAndCreateNewUser(authService);
      await authService.signOut();
      await authService.sendVerificationCodeByEmail(
        testEmail,
        testLanguageCode,
        VerificationType.login,
      );
      await authService.signInWithEmailAndVerificationCode(
        expectedFakeAppUser.email!,
        expectedFakeAppUser.verificationCode,
        testLanguageCode,
      );
      expect(authService.currentUser, expectedFakeAppUser);
      expect(authService.authStateChange(), emits(expectedFakeAppUser));
      expect(authService.idTokenChanges(), emits(expectedFakeAppUser));
    });
    test('''WHEN calling signInWithEmailAndVerificationCode
    AND a user does not exist with the email
    THEN throw an EmailNotFoundException
    AND the users list is empty
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () {
      final authService = createFakeAuthService();
      expect(
          () => authService.signInWithEmailAndVerificationCode(
                expectedFakeAppUser.email!,
                expectedFakeAppUser.verificationCode,
                testLanguageCode,
              ),
          throwsA(isA<EmailNotFoundException>()));
      expect(authService.getUsersList(), isEmpty);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling signInWithEmailAndVerificationCode
    without calling sendVerificationCodeByEmail
    AND a user with the email is found
    THEN throw an UnkownErrorException
    AND there is no code to verify
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null''', () async {
      final authService = createFakeAuthService();
      await setAndCreateNewUser(authService);
      await authService.signOut();
      expect(
          () async => authService.signInWithEmailAndVerificationCode(
                expectedFakeAppUser.email!,
                expectedFakeAppUser.verificationCode,
                testLanguageCode,
              ),
          throwsA(isA<UnknownErrorException>()));
      expect(authService.getUsersList(), [expectedFakeAppUser]);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling signInWithEmailAndVerificationCode
    after calling createAccountWithEmailAndVerificationCode 
    AND the email and verification code is added to codes
    AND entering an incorrect verification code
    THEN throw an IncorrectVerificationCodeException
    AND the email and verification code is not removed from codes
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null
    ''', () async {
      final authService = createFakeAuthService();
      await setAndCreateNewUser(authService);
      await authService.signOut();
      await authService.sendVerificationCodeByEmail(
        testEmail,
        testLanguageCode,
        VerificationType.login,
      );
      expect(
          () async => authService.signInWithEmailAndVerificationCode(
                expectedFakeAppUser.email!,
                'wrong code',
                testLanguageCode,
              ),
          throwsA(isA<IncorrectVerificationCodeException>()));
      expect(authService.getCodesTable(), {
        testEmail: expectedFakeAppUser.verificationCode,
      });
      expect(authService.getUsersList(), [expectedFakeAppUser]);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
  });
  group('Fake Auth Service Sign Out', () {
    test('''WHEN calling signOut
    after calling createAccountWithEmailAndVerificationCode
    THEN the users list contains the user
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null
    ''', () async {
      final authService = createFakeAuthService();
      await setAndCreateNewUser(authService);
      expect(authService.currentUser, expectedFakeAppUser);
      expect(authService.authStateChange(), emits(expectedFakeAppUser));
      expect(authService.idTokenChanges(), emits(expectedFakeAppUser));
      await authService.signOut();
      expect(authService.getUsersList(), [expectedFakeAppUser]);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
    test('''WHEN calling signOut
    without any user logged in
    THEN the users list is empty
    AND the current user is null
    AND the authStateChange emits null
    AND the idTokenChanges emits null
    ''', () async {
      final authService = createFakeAuthService();
      await authService.signOut();
      expect(authService.getUsersList(), isEmpty);
      expect(authService.currentUser, isNull);
      expect(authService.authStateChange(), emits(null));
      expect(authService.idTokenChanges(), emits(null));
    });
  });
}
