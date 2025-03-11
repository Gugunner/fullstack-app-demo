import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piix_mobile/src/features/authentication/application/auth_service.dart';
import 'package:piix_mobile/src/features/authentication/application/auth_service_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/data/auth_repository.dart';
import 'package:piix_mobile/src/features/authentication/domain/authentication_model_barrel_file.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

import '../../../mocks.dart';

void main() {
  const testEmail = 'email@gmail.com';
  const testLanguageCode = 'en';
  const testVerificationType = VerificationType.login;
  const testVerificationCode = '123456';
  final expectedAppUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
    emailVerified: true,
  );
  late MockAuthRepository mockAuthRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  setUp(() async {
    mockAuthRepository = MockAuthRepository();
    mockFirebaseAuth = MockFirebaseAuth();
  });

  AuthService createFakeAuthService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
      ],
    );
    addTearDown(container.dispose);
    return container.read(authServiceProvider);
  }

  MockFirebaseUser createMockFirebaseUser() {
    final user = MockFirebaseUser();
    when(() => user.uid).thenReturn(expectedAppUser.uid);
    when(() => user.email).thenReturn(expectedAppUser.email);
    when(() => user.emailVerified).thenReturn(expectedAppUser.emailVerified);
    return user;
  }

  group('Auth Service', () {
    test('''
    WHEN calling sendVerificationCodeByEmail
    THEN the authRepository.sendVerificationCodeByEmail is called
    ''', () async {
      final authService = createFakeAuthService();
      when(() => mockAuthRepository.sendVerificationCodeByEmail(
                expectedAppUser.email!,
                testLanguageCode,
                testVerificationType,
              ))
          .thenAnswer(
              (_) async => Response(requestOptions: RequestOptions(path: '')));
      await authService.sendVerificationCodeByEmail(
        expectedAppUser.email!,
        testLanguageCode,
        testVerificationType,
      );
      verify(() => mockAuthRepository.sendVerificationCodeByEmail(
            expectedAppUser.email!,
            testLanguageCode,
            testVerificationType,
          )).called(1);
    });
    test('''WHEN calling createAccountWithEmailAndVerificationCode
    AND the authRepository.createAccountWithEmailAndVerificationCode is called
    AND a custom token is obtained
    AND the firebaseAuth.signInWithCustomToken is called
    THEN the user is signed in
    ''', () async {
      const testCustomToken = 'fake_token';
      when(() => mockAuthRepository.createAccountWithEmailAndVerificationCode(
              expectedAppUser.email!, testVerificationCode, testLanguageCode))
          .thenAnswer((_) async => testCustomToken);
      when(() => mockFirebaseAuth.signInWithCustomToken(testCustomToken))
          .thenAnswer((_) => Future.value(MockUserCredential()));
      final authService = createFakeAuthService();
      await authService.createAccountWithEmailAndVerificationCode(
          expectedAppUser.email!, testVerificationCode, testLanguageCode);
      verify(() => mockAuthRepository.createAccountWithEmailAndVerificationCode(
              expectedAppUser.email!, testVerificationCode, testLanguageCode))
          .called(1);
      verify(() => mockFirebaseAuth.signInWithCustomToken(testCustomToken))
          .called(1);
    });
    test('''WHEN calling createAccountWithEmailAndVerificationCode
    AND the authRepository.getCustomTokenWithEmailAndVerificationCode is called
    AND a custom token is obtained
    THEN the firebaseAuth.signInWithCustomToken is called but fails to sign in
    AND a CustomTokenFailedException is thrown
    ''', () async {
      const testCustomToken = 'fake_token';
      when(() => mockAuthRepository.createAccountWithEmailAndVerificationCode(
              expectedAppUser.email!, testVerificationCode, testLanguageCode))
          .thenAnswer((_) async => testCustomToken);
      when(() => mockFirebaseAuth.signInWithCustomToken(testCustomToken))
          .thenThrow(Exception('mock error'));
      final authService = createFakeAuthService();
      expect(
          () async => authService.createAccountWithEmailAndVerificationCode(
              expectedAppUser.email!, testVerificationCode, testLanguageCode),
          throwsA(isA<CustomTokenFailedException>()));
      verify(() => mockAuthRepository.createAccountWithEmailAndVerificationCode(
              expectedAppUser.email!, testVerificationCode, testLanguageCode))
          .called(1);
      verifyNever(
          () => mockFirebaseAuth.signInWithCustomToken(testCustomToken));
    });
    test('''WHEN calling signInWithEmailAndVerificationCode
    AND the authRepository.getCustomTokenWithEmailAndVerificationCode is called
    AND a custom token is obtained
    AND the firebaseAuth.signInWithCustomToken is called
    THEN the user is signed in
    ''', () async {
      const testCustomToken = 'fake_token';
      when(() => mockAuthRepository.getCustomTokenWithEmailAndVerificationCode(
              expectedAppUser.email!, testVerificationCode, testLanguageCode))
          .thenAnswer((_) async => testCustomToken);
      when(() => mockFirebaseAuth.signInWithCustomToken(testCustomToken))
          .thenAnswer((_) => Future.value(MockUserCredential()));
      final authService = createFakeAuthService();
      await authService.signInWithEmailAndVerificationCode(
          expectedAppUser.email!, testVerificationCode, testLanguageCode);
      verify(() =>
          mockAuthRepository.getCustomTokenWithEmailAndVerificationCode(
              expectedAppUser.email!,
              testVerificationCode,
              testLanguageCode)).called(1);
      verify(() => mockFirebaseAuth.signInWithCustomToken(testCustomToken))
          .called(1);
    });
    test('''WHEN calling signInWithEmailAndVerificationCode
    AND the authRepository.getCustomTokenWithEmailAndVerificationCode is called
    AND a custom token is obtained
    THEN the firebaseAuth.signInWithCustomToken is called but fails to sign in
    AND a CustomTokenFailedException is thrown
    ''', () async {
      const testCustomToken = 'fake_token';
      when(() => mockAuthRepository.getCustomTokenWithEmailAndVerificationCode(
              expectedAppUser.email!, testVerificationCode, testLanguageCode))
          .thenAnswer((_) async => testCustomToken);
      when(() => mockFirebaseAuth.signInWithCustomToken(testCustomToken))
          .thenThrow(Exception('mock error'));
      final authService = createFakeAuthService();
      expect(
          () async => authService.signInWithEmailAndVerificationCode(
              expectedAppUser.email!, testVerificationCode, testLanguageCode),
          throwsA(isA<CustomTokenFailedException>()));
      verify(() =>
          mockAuthRepository.getCustomTokenWithEmailAndVerificationCode(
              expectedAppUser.email!,
              testVerificationCode,
              testLanguageCode)).called(1);
      verifyNever(
          () => mockFirebaseAuth.signInWithCustomToken(testCustomToken));
    });
    test('''WHEN calling signOut
    AND the authRepository.revokeRefreshTokens is called
    AND the firebaseAuth.signOut is called
    THEN the user is signed out
    ''', () async {
      final authService = createFakeAuthService();
      when(() => mockAuthRepository.revokeRefreshTokens()).thenAnswer(
          (_) async => Response(requestOptions: RequestOptions(path: '')));
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) => Future.value());
      await authService.signOut();
      verify(() => mockAuthRepository.revokeRefreshTokens()).called(1);
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
    test('''WHEN calling signOut
    AND the authRepository.revokeRefreshTokens throws an exception
    AND the firebaseAuth.signOut is called
    THEN the user is signed out
    ''', () async {
      final authService = createFakeAuthService();
      when(() => mockAuthRepository.revokeRefreshTokens())
          .thenThrow(Exception('mock error'));
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) => Future.value());
      await authService.signOut();
      verify(() => mockAuthRepository.revokeRefreshTokens()).called(1);
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
    test('''WHEN getting the currentUser
    THEN the user is converted to an AppUser
    ''', () {
      final authService = createFakeAuthService();
      final user = createMockFirebaseUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(user);
      expect(
        authService.currentUser,
        isA<AppUser>()
            .having((appUser) => appUser.uid, 'ui', expectedAppUser.uid)
            .having((appUser) => appUser.email, 'email', expectedAppUser.email)
            .having((appUser) => appUser.emailVerified, 'emailVerified',
                expectedAppUser.emailVerified),
      );
    });
    test('''WHEN calling authStateChange
    THEN the user is converted to an AppUser
    ''', () {
      final authService = createFakeAuthService();
      final user = createMockFirebaseUser();
      when(() => mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.fromIterable([user, null]));
      expect(
        authService.authStateChange(),
        emitsInOrder([expectedAppUser, null]),
      );
    });
    test('''WHEN calling idTokenChanges
    THEN the user is converted to an AppUser
    ''', () {
      final authService = createFakeAuthService();
      final user = createMockFirebaseUser();
      when(() => mockFirebaseAuth.idTokenChanges())
          .thenAnswer((_) => Stream.fromIterable([user, null]));
      expect(
        authService.idTokenChanges(),
        emitsInOrder([expectedAppUser, null]),
      );
    });
  });
}
